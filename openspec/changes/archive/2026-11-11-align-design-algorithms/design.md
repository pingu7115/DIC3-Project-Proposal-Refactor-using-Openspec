# Design: align-design-algorithms

## Context

在先前將專案設計轉移至 OpenSpec 規格體系時，`design.md` 中記錄的演算法偽代碼被過度簡化，導致與系統基礎架構主文檔 `DESIGN.md` §9 及 `docs/proposal.md` §5.3 產生差異。特別是舊版遺漏了非對稱錯誤成本（NFR2）的關鍵核心安全防線——`τ_safety` 門檻重標註機制，且省略了 `OneHotWithConfidence` 離散化信心映射與 24 行 ReAct 證據收集迴圈的詳細定義。本設計文檔將演算法偽代碼與說明完全對齊至 `DESIGN.md` §9。

## Goals / Non-Goals

**Goals:**
- 將 OpenSpec 設計文檔中的 Algorithm 1 與 Algorithm 2 完全對齊至 `DESIGN.md` §9 的標準版本。
- 完整收錄 `IsSufficient(E)` 終止判斷準則與 `OneHotWithConfidence` 信心向量轉換邏輯。
- 明確列出本次對齊相較於舊版 OpenSpec 設計的修訂差異。

**Non-Goals:**
- 修改 `DESIGN.md` §9 既有的演算法定義與架構邏輯（以其現有內容為不可變基準）。
- 在 Proposal 階段進行測試集調參或超參數擬合。

## Decisions

### 1. 採納 DESIGN.md §9 權威版本演算法

完全複製 `DESIGN.md` §9 之偽代碼及行號說明，不另行縮減或改寫。

#### Algorithm 1: SOC Triage Agent

```text
Algorithm 1: SOC Triage Agent
Input : Incident request Q (incident ID, alert batch, or NL question)
        Triage model M, ATT&CK knowledge base KB, playbook set PB
        Confidence threshold τ, tool-call budget B
Output: Triage report R

01: req ← ValidateAndParse(Q)
02: if req is invalid then return ErrorReport("missing or malformed input")
03: plan ← Planner.Decompose(req)                 ▷ subtasks: gather, classify, map, recommend
04: E ← ∅ ; calls ← 0
05: repeat                                         ▷ evidence gathering loop
06:     tool ← Planner.SelectTool(plan, E)
07:     E ← E ∪ tool.Execute(req, E)               ▷ every item carries its source reference
08:     calls ← calls + 1
09: until Planner.IsSufficient(E) or calls ≥ B
10: x ← ExtractFeatures(E)
11: p ← M.PredictProba(x)                          ▷ p = (p_TP, p_BP, p_FP)
12: φ ← SHAP(M, x)                                 ▷ top contributing features
13: S ← RetrieveSimilarIncidents(x, k)
14: T ← MapToATTACK(E, KB)                         ▷ techniques, tactics, kill-chain stage
15: K ← KB.Retrieve(T) ∪ PB.Retrieve(T)            ▷ RAG context
16: llm ← LLM.Reason(E, p, φ, S, T, K)             ▷ returns label, rationale, confidence
17: (label, conf, flags) ← FuseEvidence(p, llm, Rules(T))      ▷ Algorithm 2
18: if conf < τ or "conflict" ∈ flags or "high_risk" ∈ flags or not Planner.IsSufficient(E) then
19:     R.status ← "NEEDS_HUMAN_REVIEW"
20: else
21:     R.status ← "AUTO_TRIAGED"
22: R.actions ← PB.Recommend(label, T)
23: R ← R ∪ {label, conf, evidence: E, shap: φ, similar: S, attack: T, rationale: llm.rationale, flags}
24: return R
```

#### Algorithm 2: Evidence Fusion

```text
Algorithm 2: FuseEvidence
Input : ML probabilities p, LLM output llm, rule results U
        Weights w_ml, w_llm (w_ml + w_llm = 1)
Output: label, confidence conf, flag set flags

01: flags ← ∅
02: q ← OneHotWithConfidence(llm.label, llm.confidence)
03: s ← w_ml · p + w_llm · q                      ▷ weighted class scores
04: label ← argmax(s) ; conf ← max(s)
05: if argmax(p) ≠ llm.label then flags ← flags ∪ {"conflict"}
06: if U contains a high-risk pattern then        ▷ e.g. late kill-chain stage
07:     flags ← flags ∪ {"high_risk"}
08:     if label ≠ TP and p_TP ≥ τ_safety then label ← TP    ▷ NFR2: prefer escalation
09: return (label, conf, flags)
```

**`IsSufficient(E)` 的判斷方式**：採規則判斷，不交給 LLM 自行決定，以避免 [3] 發現的過早結案；[25] 也觀察到，最後需要升級的告警，分析師會蒐集更多種類的資訊。三項都成立才算證據足夠：

1. 事件中每一筆告警都已取得對應的證據（evidence）。
2. 事件涉及的主要實體（帳號、主機）都至少有一筆上下文紀錄，例如登入、程序或網路活動。
3. 任一查詢回傳空結果時，必須確認同一資料來源在該時間窗內仍有其他紀錄，也就是 log 沒有中斷；無法確認時視為證據不足，而不是「沒有可疑活動」。

自然語言調查問題沒有告警清單，第 1 項改為「問題涉及的每個實體都已查詢過」。GUIDE 沒有原始 log，因此在 GUIDE 上第 3 項改為：檢查每筆告警的證據列是否齊全，並把代表「無此實體」的固定 ID 視為缺值，而不是一個真的實體（見 DESIGN.md §5 的待確認項目）。

**`OneHotWithConfidence` 的轉換方式**：LLM 自行回報的數值信心通常不可靠，因此只要求 LLM 回報「低／中／高」三級信心，分別對應 c = 0.5、0.7、0.9（實際數值在驗證集上調整）。LLM 判斷的類別得到 c，其餘兩類平分 1 − c。例如 LLM 判斷為 TP、信心「中」，則 q = (0.7, 0.15, 0.15)。

> 權重 `w_ml`、`w_llm` 與門檻 `τ`、`τ_safety` 將在驗證集上調整，不使用測試集調參。

### 2. 與舊版 OpenSpec 設計之差異說明

| 比對面向 | 舊版 OpenSpec Change 設計 | 本次對齊版本（依據 DESIGN.md §9） |
|---|---|---|
| **Algorithm 1 行數與結構** | 18 行，將 ReAct 循環簡化為單一函數調用，缺乏明確的 `R.status` 分支與細部變數解構。 | **24 行**，完整呈現 ReAct 工具收集迴圈（L05–L09）、嚴謹的升級條件判斷（L18）及結構化報告輸出（L19–L24）。 |
| **LLM 信心向量轉換** | 假設 LLM 直接回傳浮點機率分布 $p_{LLM}$，缺乏離散化校準。 | **Algorithm 2 L02**：定義 `OneHotWithConfidence`，將 LLM 低／中／高三級質性信心映射為數值向量，避免 LLM 過度自信或不可靠機率輸出。 |
| **錯誤成本不對稱重標註** | 未實作重標註機制，僅在觸發規則時打標籤。 | **Algorithm 2 L08**：新增 `if label ≠ TP and p_TP ≥ τ_safety then label ← TP`，落實 NFR2 非對稱錯誤成本，防止高風險事件遭錯判漏判。 |
| **終止條件與證據完整性** | 僅以文字條列概念。 | 完整收錄 `IsSufficient(E)` 三大規則判定標準與針對 GUIDE 資料集的調適處理方式。 |

## Risks / Trade-offs

- **[Trade-off 1] TP Miss Rate vs. Escalation Rate**: 透過調整門檻 $\tau$ 與 $\tau_{safety}$，能在降低真陽性漏判率（FN）與控制人工審查升級負擔之間取得帕累托最優平衡。
- **[Trade-off 2] Rule Rigidity vs. Flexibility**: 高風險規則強制重標註（L08）可能在內部紅隊演練時增加升級次數，但藉由引入 $\tau_{safety}$ 門檻過濾，避免極低機率事件被無條件標註。

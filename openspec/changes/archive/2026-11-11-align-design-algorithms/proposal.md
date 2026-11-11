# Proposal: align-design-algorithms

## Why

在先前的 OpenSpec 轉換過程中，部分工作流程設計與主規格文件 `DESIGN.md` §9 及 `docs/proposal.md` §5.3 的演算法版本產生了不一致。具體而言，舊版轉換遺漏了核心演算法中的多項關鍵機制，包括：在 Algorithm 2 中缺少基於高風險規則觸發且 $p_{TP} \ge \tau_{safety}$ 時的主動安全重標註（Safety-Biased Relabeling）機制，導致未能完全體現資安維運中「錯誤成本不對稱」（NFR2）的非對稱核心原則；同時遺漏了以 `OneHotWithConfidence` 轉換 LLM 三級信心度的設計，以及 Algorithm 1 完整 24 行的 ReAct 證據收集與結構化報告生成迴圈。

為了確保 OpenSpec 系統規格、設計文件與原始系統架構設計完全對齊，本變更以 `DESIGN.md` §9 為權威依據，全面更新演算法偽代碼與說明，並於規格中補齊高風險安全重標註需求。

## What Changes

- **對齊演算法偽代碼**：將 OpenSpec 中的 Algorithm 1（24 行）與 Algorithm 2（9 行）及其行號說明完整對齊至 `DESIGN.md` §9 與 `docs/proposal.md` §5.3。
- **補齊 Safety-Biased Relabeling 規格**：在 `evidence-fusion` 規格中新增「Safety-Biased Relabeling under High Risk」需求與兩項測試情境（Scenario: High-risk incident with sufficient TP probability 與 Scenario: High-risk incident with low TP probability）。
- **保留完整證據收集終止與信心轉換機制**：在設計文件中明確納入 `Planner.IsSufficient(E)` 規則檢查機制與 `OneHotWithConfidence` 信心向量對照表。

## Capabilities

### Modified Capabilities
- `evidence-fusion`: 新增「Safety-Biased Relabeling under High Risk」需求，當高風險規則（R1–R5）觸發且機器學習機率 $p_{TP} \ge \tau_{safety}$ 時，強制重標註為 TP 並升級，貫徹錯誤成本不對稱原則。

## Impact

- 影響系統架構設計與演算法偽代碼一致性（`DESIGN.md` 與 OpenSpec `design.md` 完全同步）。
- 更新 `specs/evidence-fusion/spec.md` 行為規格。
- 不影響已存在的其他規格與實作程式碼。

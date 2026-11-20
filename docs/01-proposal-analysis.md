依據《期末專題提案作業規範》與《A2Z outline example》，針對 docs/proposal.md、DESIGN.md 與 docs/AI_SOC_Analyst_Agent-Proposal.pptx 進行系統性解析。

---

# AI SOC Analyst Agent 專題提案系統性解析報告

## 一、依據《期末專題提案作業規範》核心維度檢視符合度

### 1. 核心定位符合度（AI Agent + 領域知識 + 數據分析 + 真實世界應用）
專題規範明確要求不能只訓練單一 AI 模型或製作純問答 Chatbot，必須是具備專業推理、取得資料與決策能力的 Domain AI Agent。本專題之具體實踐與落實如下：

- **超越單一 Model 與單純 Chatbot**：本專題揚棄單純問答式對話機器人或單一黑箱統計模型，而是設計一個具備動態任務拆解（Planner）、多來源工具呼叫（Tool Use）、外部日誌檢索、結構化特徵預測、領域知識硬約束以及人機協同升級能力的完整智慧代理人體系（§2.5、§5.1、DESIGN.md §3）。
- **AI Agent（智慧代理人核心）**：以 LLM 為 ReAct 調查代理人核心（如 Claude 3.5 Sonnet / GPT-4o），整合多步調查意圖拆解（Planner.Decompose）、日誌取證工具調用迴圈（Planner.SelectTool）與不確定性質疑推理；當模型信心不足、多源結論衝突、證據不足或觸發高風險規則時，主動升級人工複核（§1.1、§2.4、§5.1、§5.3、DESIGN.md §3）。
- **Domain Knowledge（領域知識整合）**：深度整合 MITRE ATT&CK 知識本體（涵蓋 432 種技術與 14 種戰術矩陣）、NIST SP 800-61 Rev. 3 事件應變處置標準指引、Pyramid of Pain 行為防禦哲學，以及固化為演算法硬約束的五大高風險攻擊鏈規則（Rules R1–R5）與非對稱錯誤成本安全重標註機制（$\tau_{safety}$）（§1.1、§2.2、§4 Q1、§5.3、DESIGN.md §8）。
- **Data Analytics（數據分析與特徵工程）**：整合微軟百萬級真實 SOC 事件資料集 Microsoft GUIDE（包含 1,300 萬筆證據、160 萬則告警、100 萬起事件與 6.1k 組織）與微軟 SQL 日誌調查基準 ExCyTIn-Bench（57 張日誌表、8 條真實攻擊鏈）。利用 GBDT（LightGBM）快速處理大規模結構化特徵，輸出校準後的 TP/BP/FP 機率分布，並透過 SHAP 進行全域與局部特徵歸因解釋（§2.5、§5.1、§5.4、DESIGN.md §4、§5）。
- **Real-World Application（真實世界應用與產業痛點）**：直接鎖定現代資安維運中心（SOC）面對海量告警的「告警疲勞（Alert Fatigue）」痛點（每日數萬告警中真實惡意不足 5%）。緊密結合我國國安局 2025 年統計中共對我關鍵基礎設施日均侵擾 263 萬次（+6%），以及 IBM 2026 報告全球資料外洩成本創 499 萬美元新高與處理耗時 247 天的嚴峻現實，落實 Assume Breach 防禦實務（§1、§2.1、§2.3、§4 Q1）。

### 2. Abstract（摘要）與 Introduction（緒論）結構對照
專題提案之 Abstract 六段式（A–F）與 Introduction（§2.1–2.6）邏輯緊密對齊，回答「Why is this project worth doing?」：

- **A. Attention Getter（動機與引題）**：引用 2025 國安局報告（中共對我關鍵設施網路侵擾日均 263 萬次，年增 6% [23]）、IBM 2026 報告（資料外洩平均成本達 499 萬美元、平均處理耗時 247 天 [14]）、Mandiant M-Trends 2026（攻擊者潛伏期中位數 14 天，間諜達 122 天 [15]）引題；指出第一線 SOC 告警中真實惡意不足 5% [2]（對照 §1 A 段、§2.1）。
- **B. But（挑戰與現有不足）**：指出告警疲勞使分析師漏看真實 APT 威脅 [8][24]。現有機器學習依賴靜態特徵比對，缺乏攻擊鏈因果脈絡 [1][7]；前沿 tool-using LLM 調查代理人漏判率至少 40.4% [3]，查無紀錄時易過早結案 [3]；過度自動化更會誘發分析師批判性監控下降之「自動化自滿（Automation Complacency）」[12]（對照 §1 B 段、§2.3、§2.4）。
- **C. Cure（解藥與本研究解法）**：提出 AI SOC Analyst Agent，三方深度融合 GBDT 機器學習分級、MITRE ATT&CK 領域知識本體與 LLM 脈絡推理，針對資安事件提供有證據、可解釋且具備主動升級機制的 TP/BP/FP 分級與處置建議（對照 §1 C 段、§2.5）。
- **D. Development（方法與系統架構）**：系統整合八大模組，以 GBDT 提供快速校準機率與 SHAP 解釋；以 Chroma 向量資料庫檢索 ATT&CK 與 NIST Playbook；以 LLM 進行多步調查；由證據融合模組綜合判斷，於低信心、衝突或高風險時主動升級人工複核（對照 §1 D 段、§2.5、§5.1–5.3）。
- **E. Experiments（評估規劃）**：規劃於微軟百萬級事件資料集 GUIDE 與 ExCyTIn-Bench 雙重公開基準上，對比多數類別、歷史規則、純 GBDT 與純 LLM 四大 Baseline，實施嚴格防洩漏切分，重點評估 Macro-F1、TP 漏判率與人工升級率，並以消融實驗驗證各模組增益（對照 §1 E 段、§5.4）。
- **F. Findings（預期產出）**：嚴格遵循「未實驗者僅列 Expected Outcomes，不虛構數據」之學術規範，預期達成：（1）TP 漏判率顯著低於純 GBDT 與純 LLM Baseline；（2）繪製漏判率與人工升級率之 Pareto 權衡曲線；（3）顯著提升 ATT&CK 對應正確性與報告可解釋性（對照 §1 F 段、§5.4）。
- **Introduction 論證精神**：明確回答專案價值，條列五大現有方法限制（純 ML 無攻擊鏈脈絡、LLM 漏判與過早結案、自動化自滿、黑箱規則脆弱、缺乏跨資料集評估），並以橫向對比矩陣界定與傳統純 ML、純 LLM 代理人（AIDA、CORTEX）的實質創新差異（§2.4、§2.5）。

### 3. Related Work 與 Deep Research 三大問題
專題在相關研究與領域深探上達成學術與實務之深度平衡：

- **AI 技術與領域知識平衡（1/2 AI + 1/2 Domain）**：
  - **AI 技術面（8 篇）**：涵蓋 ML 分級架構（Copilot Guided Response [1]、Alert Incident Prioritization [7]）、多 Agent 協同調查（CORTEX [2]、AIDA [3]）、調查推理基準（ExCyTIn-Bench [4]、CyberSOCEval [5]）、威脅情資 RAG 對齊（TechniqueRAG [6]）以及真實大學 SOC 現場縱向部署實證（[26]）（§3.1）。
  - **Domain 領域面（8 篇）**：涵蓋告警篩選綜述（[8]）、LLM-for-SOC 綜述（[9]）、Kill Chain 攻擊圖映射（[10]）、ROSCA 可解釋告警圖聚合（[11]）、自動化自滿與偏誤實證（[12]）、NIST SP 800-61 Rev. 3 事件應變標準（[13]）、真實世界誤報與良性觸發實證（[24]）以及 Tier-1 分析師放聲思考調查實證（[25]）（§3.2）。
- **Article Summary Table**：完整收錄 16 篇橫跨 2022–2026 年核心文獻的比較表（包含 Ref, Year, Problem, AI Method, Domain Knowledge, Dataset, Findings, Limitation），清楚歸納作者自述限制，並成功收斂出「Existing Research → Limitations → Research Gap → Our Project」的完整邏輯鏈（§3.3、§3.4）。
- **Deep Research 三大核心問題對照**：
  - **Q1. 五大核心思維模式（5 Cores）**：深入論述 M1 Assume Breach（假設已遭入侵）、M2 看事件與攻擊鏈脈絡、M3 錯誤成本不對稱、M4 TTPs 優先於 IOCs、M5 自動化要可驗證人保留最終裁決，並明確指出在系統架構中的落實點（Rules R1–R5、$\tau_{safety}$ 安全重標註、`IsSufficient(E)` 終止檢查）（§1.1、§4 Q1）。
  - **Q2. 三大重要專業爭論**：深入剖析「爭論 1：全自動 vs. 人機協作」、「爭論 2：確定性規則 vs. 機器學習」、「爭論 3：公開基準 vs. 真實環境」，分析雙方最強論據、當前共識與未解問題，並具體推導出本系統的三大工程取捨設計（§1.2、§4 Q2）。
  - **Q3. 十大深度理解細節**：設計涵蓋 Why、What-if、Trade-off、Failure Case、Evidence、Comparison、Design Decision、Real-world Scenario 等多維度推理之 10 個核心問題（包括 Detector 高誤報不關閉原因、攻擊者利用查無日誌反制防禦、$\tau$ 門檻量化校準、Living off the Land 攻擊辨別、GUIDE 防洩漏切分等）（§1.3、§4 Q3）。

### 4. Proposed Scheme（系統架構與技術表示）
提案以完整三種技術表示落實可實作性：

- **八大模組架構（對應規範 ①～⑧）**：
  - **① User / Application Scenario**：SOC Tier-1 分析師面對即時事件佇列，審閱處置建議並裁決是否升級（§5.1、DESIGN.md §3）。
  - **② Query / Input Processing**：接收 Incident ID、告警批次或自然語言調查問題，進行輸入結構化驗證與子任務拆解（§5.1、DESIGN.md §3）。
  - **③ Planner & Reasoning Agent**：LLM 任務規劃核心，負責 ReAct 調查步驟規劃、動態調用取證工具與語意推理質疑（§5.1、DESIGN.md §3）。
  - **④ Data Acquisition / Retrieval**：Incident Evidence Store 與 SQL Log Query，動態跨主機、帳號與時間窗提取佐證日誌（§5.1、DESIGN.md §3）。
  - **⑤ Analytics Engine**：LightGBM (GBDT) 輸出校準機率 $p=(p_{TP}, p_{BP}, p_{FP})$，SHAP 計算特徵歸因，檢索歷史相似事件（§5.1、DESIGN.md §3）。
  - **⑥ Domain Knowledge Integration**：Chroma 向量庫儲存 MITRE ATT&CK STIX 2.1 本體、偵測邏輯與 NIST SP 800-61 處置 Playbook（§5.1、DESIGN.md §3）。
  - **⑦ Decision / Recommendation**：多源證據融合、高風險攻擊鏈規則（Rules R1–R5）硬護欄、$\tau_{safety}$ 安全重標註與主動升級判斷（§5.1、DESIGN.md §3）。
  - **⑧ Output & Interaction**：結構化 Markdown 事件報告輸出（含原始日誌引據、SHAP 圖表、處置建議），透過 Streamlit 儀表板呈現（§5.1、DESIGN.md §3）。
- **流程圖（Flowchart）**：於 proposal.md §5.2 與 DESIGN.md §6 提供端到端決策泳道流程圖，完整涵蓋輸入驗證失敗提早回傳、證據不足擴大查詢迴圈、`IsSufficient(E)` 規則檢查、多源證據融合、高風險規則與人機升級判斷分支。
- **演算法虛擬碼（Pseudocode）**：提供帶有完整行號之核心演算法：
  - **Algorithm 1: SOC Triage Agent（24 行）**：定義完整 ReAct 調查迴圈（L05–L09）、特徵萃取與 GBDT 分級（L10–L12）、ATT&CK 映射與 RAG 檢索（L14–L15）、證據融合調用（L17）與主動升級條件檢查（L18: `conf < τ or "conflict" ∈ flags or "high_risk" ∈ flags or not Planner.IsSufficient(E)`）（§5.3、DESIGN.md §9）。
  - **Algorithm 2: FuseEvidence（9 行）**：定義 `OneHotWithConfidence` 離散信心向量轉換（L02）、加權融合分數（L03）、衝突偵測（L05）、高風險規則評估（L06）以及關鍵安全重標註機制（L08: `if label ≠ TP and p_TP ≥ τ_safety then label ← TP`）（§5.3、DESIGN.md §9）。

---

## 二、依據《A2Z SOP Outline》26 字母結構深度解析

| 字母 | A2Z 定義 | 本專題具體落實與內容映射 |
|:---:|:---|:---|
| **A** | **Attention Getter**：動機及引題 | 引用 2025 國安局報告（中共對我關鍵設施網路侵擾日均 263 萬次，+6% [23]）、IBM 2026 報告（資料外洩平均成本達 499 萬美元、平均處理耗時 247 天 [14]）與 Mandiant 14 天潛伏期 [15]，凸顯第一線 SOC 海量告警中真實惡意不足 5% [2] 的防禦挑戰（§1、§2.1）。 |
| **B** | **But**：挑戰與現有不足 | 告警疲勞造成分析師漏看真實攻擊 [8][24]。現有機器學習缺乏攻擊鏈脈絡 [1][7]；前沿 LLM 調查代理人漏判率至少 40.4% [3]，在查無紀錄時易過早結案 [3]；黑箱自動化更易引發分析師「自動化自滿」[12]（§1、§2.3、§2.4）。 |
| **C** | **Cure**：提出的創新解藥 | 提出結合機器學習統計分級、MITRE ATT&CK 領域知識本體與 LLM 脈絡推理的「AI SOC Analyst Agent」智慧代理人系統（§1、§2.5）。 |
| **D** | **Development**：方法設計依據 | 結合 GBDT（LightGBM）分類預測、Chroma 向量庫檢索 ATT&CK 與 NIST 應變 Playbook、LLM ReAct 多步推理、多源證據融合與安全重標註機制（§1、§2.5、§5.1–5.3）。 |
| **E** | **Experiments**：評估規劃 | 規劃以微軟 GUIDE（約 100 萬起真實事件）評估三分類準確度，並以 ExCyTIn-Bench 評估 SQL 調查能力；對比多數類別、歷史規則、純 GBDT 與純 LLM，依事件/組織實施無洩漏切分評估 Macro-F1、TP 漏判率與人工升級率（§1、§5.4）。 |
| **F** | **Findings**：預期成果（無虛構） | 嚴格遵守 Proposal 階段不虛構數據，規劃達成：（1）TP 漏判率顯著低於純 GBDT 與純 LLM Baseline；（2）繪製漏判率與升級率之 Pareto 權衡曲線；（3）顯著提升 ATT&CK 對應正確性與報告可解釋性（§1、§5.4）。 |
| **G** | **General**：領域大背景現況 | 網路攻擊演變為日常國安與經濟威脅，SOC 匯流 EDR、網路與身分層海量告警；現代工控與 AIoT 邊緣設備因運算限制缺乏端點代理，異質事件多層關聯成為第一線分流關鍵（§2.1、§2.2）。 |
| **H** | **However**：深層技術與應用瓶頸 | 低信噪比引發嚴重告警疲勞，FIFO 或靜態嚴重度排序失效；純 ML 無法解釋因果；LLM 成本高且缺乏安全底線護欄，查無日誌易誤判無害（§2.3、§2.4）。 |
| **I** | **In literature**：文獻發展梳理 | 梳理從早期傳統靜態規則過濾、純統計機器學習分級（CGR [1]、AIP [7]）、攻擊圖序列分析（[10]、[11]）發展至多 Agent LLM 調查（CORTEX [2]、AIDA [3]）的演進脈絡（§2.5、§3.1、§3.2）。 |
| **J** | **Judgement**：各類方法優劣點評析 | 純 ML 運算快且機率可校準但欠缺攻擊鏈語意；純 LLM 具語意關聯但 token 昂貴、推論慢且漏判率高達至少 40.4%；規則式缺乏彈性但安全底線明確（§2.4、§2.5、§3.4）。 |
| **K** | **Keypoint**：設計精神與核心貢獻 | 確立「Assume Breach」與「錯誤成本不對稱」兩大核心思維，設計三方多源證據融合架構，以可驗證之結構化證據鏈保護分析師免於自動化自滿（§1.1、§2.6）。 |
| **L** | **List the organization**：文章結構導覽 | 依序規劃摘要（§1）、緒論（§2）、相關研究與文獻比較表（§3）、Deep Research（§4）、系統架構/流程圖/演算法（§5）與參考文獻（§6）（§1、§2.6）。 |
| **M** | **Methods**：既有文獻方法分類 | 分類為「純 ML 統計分級」（[1][7]）、「多 Agent LLM 調查」（[2][3]）、「知識圖譜與攻擊圖」（[10][11]）、「領域評估基準」（[4][5]）與「SOC 人因實證」（[12][24][25][26]）（§3.1–3.4）。 |
| **N** | **New proposed**：本專案創新技術 | 「GBDT 快速機率過濾 + MITRE ATT&CK 向量本體約束 + LLM ReAct 調查 + 高風險規則硬護欄 + 不確定性主動升級」之整合架構（§1.1、§2.5、§3.4）。 |
| **O** | **Organize**：文獻比較與歸納表 | 完整收錄 16 篇跨 2022–2026 年文獻之 Article Summary Table，明確歸納收斂出「Existing Research → Limitations → Research Gap → Our Project」（§3.3、§3.4）。 |
| **PA** | **Aim**：研究目標陳述 | 打造結合機器學習、領域知識與語言模型推理，對資安告警提供有證據、可解釋且具備不確定性主動升級的 AI SOC Analyst Agent（§1、§2.3.2、§5.1）。 |
| **PB** | **Based on**：依託基礎與背景 | 依託微軟百萬級事件資料集 GUIDE、ExCyTIn-Bench、MITRE ATT&CK 矩陣本體與 NIST SP 800-61 Rev. 3 事件應變標準（§2.2、§3.1、§5.1）。 |
| **PC** | **Cure / Cause**：機制有效的原因 | 透過 GBDT 穩定校準機率避免 LLM 幻覺與高昂成本；透過 ATT&CK 高風險規則消除黑箱瞎猜；透過 `IsSufficient(E)` 規則終止條件杜絕查無紀錄過早結案（§2.5、§3.4、DESIGN.md §9）。 |
| **PD** | **Design**：系統架構設計 | 典範轉移：從「傳統孤立評估單一告警或純自動化黑箱結案」轉變為「以事件為核心多源證據融合、高風險硬約束與人機協同升級代理人」（§1.1、§2.5、§4 Q1）。 |
| **PE** | **Paper Element**：模組元件清單 | 嚴格拆解 ①～⑧ 八大模組（User、Query、Planner、Data、Analytics、Knowledge、Decision、Output）（§5.1、DESIGN.md §3）。 |
| **PF** | **Formulation**：功能與數學形式 | 定義加權融合公式 $s = w_{ml} \cdot p + w_{llm} \cdot q$、離散信心度轉換 `OneHotWithConfidence`、高風險安全重標註判斷式 $p_{TP} \ge \tau_{safety}$ 與升級條件判斷（§5.3、DESIGN.md §9）。 |
| **PG** | **Graph**：架構圖與流程圖 | 提供完整系統模組架構圖（proposal.md §5.1）、端到端決策泳道流程圖（proposal.md §5.2、DESIGN.md §6）。 |
| **PH** | **How**：如何達成設計目標 | 透過 ReAct 工具調度收集日誌、LightGBM 輸出分級機率、Chroma 向量檢索本體、加權融合比對衝突，並由高風險規則強制守門攔截（§5.1–5.3）。 |
| **PI** | **Implementation**：虛擬碼落實 | 具行號之 Algorithm 1（SOC Triage Agent，24 行）與 Algorithm 2（FuseEvidence，9 行），具備完整變數輸入輸出與分支處理（§5.3、DESIGN.md §9）。 |
| **PJ** | **Jump to an example**：情境範例展示 | 詳述 Incident #12345 範例：6 筆告警/20 筆證據，GBDT 與 LLM 衝突且觸發 R2 憑證+橫向移動規則，最終標記 NEEDS_HUMAN_REVIEW 之端到端流程（§5.1 表格、DESIGN.md §7）。 |
| **PK** | **Key points contribution**：核心貢獻總結 | 系統架構（①–⑧）、決策方法（Algorithm 1 & 2）、實證評估（跨資料集無洩漏）、領域知識（5 思維/3 爭論/10 細節）、規範治理（OpenSpec SDD）（§2.6）。 |
| **PL** | **Later simulation**：後續模擬評估規劃 | 規劃 GUIDE 上百萬事件之分層抽樣測試集評估 Macro-F1、TP 漏判率與升級率，以及 ExCyTIn-Bench 上的 SQL 調查能力評估（§5.4）。 |
| **PM** | **Math proof / Logic**：邏輯檢驗 | 依據非對稱錯誤成本定理，若攻擊漏判代價 $C_{FN} \gg C_{FP}$，在高風險特徵觸發下當 $p_{TP} \ge \tau_{safety}$ 時改判 TP 且升級，保證最大化預防災難性外洩（§4 Q1 M3、§5.3、DESIGN.md §9）。 |
| **Q** | **Quality & Quantity**：指標與評估量 | 規劃評估指標包含 Macro-F1、各類別 Precision/Recall、TP 漏判率、人工升級率、Benchmark Reward、每事件 Token 數與延遲（§5.4）。 |
| **R** | **Related method to compare**：比較基準 | 規劃對比多數類別（Majority Class）、歷史誤報率規則（Heuristic Rules）、純 GBDT（LightGBM）與純 LLM（無知識庫）（§5.4）。 |
| **S** | **Simulation Setup**：實驗環境設定 | 規劃採用 Microsoft GUIDE 實證資料集（100 萬事件）與 ExCyTIn-Bench（57 張 SQL 表受控環境），依 Incident/Org/Time 嚴格防洩漏切分（§5.4）。 |
| **T** | **Tuning parameters**：調優參數 | 規劃調整分級升級門檻 $\tau$、安全重標註門檻 $\tau_{safety}$、加權融合權重 $w_{ml}$ 與 $w_{llm}$、工具調用預算 $B$（全數於驗證集調參，不接觸測試集）（§5.3、§5.4、DESIGN.md §9）。 |
| **U** | **Useful results**：預期有用產出 | 規劃產出包含 TP/BP/FP 分級標籤、SHAP 特徵解釋、ATT&CK 攻擊鏈映射、NIST 處置建議、完整證據鏈與升級標記的可審計報告（§5.1、§5.4）。 |
| **V** | **Verify**：有效性驗證 | 規劃透過繪製漏判率–升級率 Pareto 取捨曲線驗證是否達成 TP 漏判率低於純 GBDT 與純 LLM Baseline，並透過消融實驗驗證各模組獨立增益（§5.4）。 |
| **W** | **What proposed**：回顧總結 | 總結為解決 SOC 告警疲勞、ML 缺乏攻擊鏈脈絡及 LLM 高漏判過早結案問題，提出具備領域知識與主動升級的 AI SOC Analyst Agent 提案（§1、§2.6）。 |
| **X** | **eXcel**：專精情境與優勢 | 專精於「百萬級大規模企業與關鍵設施事件分流」、「複合多階段攻擊鏈偵測」與「日誌缺失/衝突下的人機協同升級」（§1.1、§2.5、§4 Q1）。 |
| **Y** | **Yields**：預期最終交付物 | 依期末標準建立 GitHub Repo、README.md、完整 DESIGN.md、OpenSpec 規格檔案（`openspec/`）、Demo 影片、期末簡報與報告（README.md）。 |
| **Z** | **Zen**：反思與未來展望 | 反思 GUIDE 欄位高度匿名化對 LLM 語意提取的限制；未來展望結合 ATT&CK for ICS 擴充工控物聯網邊緣設備支援，以及串接真實 SIEM 進行在線灰度測試（§5.5、DESIGN.md §5、§10）。（註：即時在線持續微調管線目前為 Proposal 未定義，待補）。 |

---

## 三、綜合評審亮點與精進建議

### 1. 結構完備度與亮點檢驗（對照評分表六大維度）
- **論證精神與動機嚴謹（Introduction 20%）**：以國安局 263 萬次侵擾、IBM 499 萬美元外洩成本、Mandiant 14 天潛伏期等最新實證數據起頭，精確點出告警疲勞與真實惡意不足 5% 的產業核心痛點，具備強大說服力（對齊 §2.1）。
- **相關研究與領域深度並重（Related Work & Deep Research 40%）**：AI 技術（8 篇）與資安領域知識（8 篇）達嚴格 1:1 比例，Article Summary Table 收錄完整，精確收斂出 Research Gap；且深入闡述 SOC 專家五大核心思維模式（M1–M5）、三大專業爭論與十大深度理解問題，完全超越死記硬背層次（對齊 §3、§4）。
- **系統架構與工程規格完備（Proposed Scheme & Technical Feasibility 35%）**：八大模組架構（①～⑧）功能解耦清晰，決策流程圖包含例外、迴圈與人機交互分支，虛擬碼（Algorithm 1 具 24 行、Algorithm 2 具 9 行）包含完整變數與行號，技術選型兼顧可行性與推論成本控制（對齊 §5）。
- **規範治理與交接標準落實（GitHub & DESIGN.md 5%）**：導入 OpenSpec 規格驅動開發（SDD），從 Proposal 階段即同步維護基準規格（`openspec/specs/`）、變更紀錄與標準化自動營運腳本（`startup.sh`、`ending.sh`），展現卓越的工程規範。

### 2. 學術誠實度（Academic Integrity）
- 在 Abstract 與 Evaluation Plan 中清楚註明「本專題目前處於 Proposal 階段，尚未進行任何實驗」；所有評估指標與預期效益皆以「規劃 / 將（will）」與「Expected Outcomes」嚴謹描述，未捏造任何虛假實驗數據，完全符合提案階段的學術規範（§1 F 段、§5.4）。

### 3. 後續實作（W1–W8）重點精進建議
針對專案計畫書中尚未完全落實、留待實作階段攻克的真實待補事項：
1. **GUIDE 資料集特定匿名欄位之實質特徵工程落地**：`proposal.md` 與 `DESIGN.md` §5 指出 GUIDE 存在大量雜湊字串且無原始文字 Log，代表「無此實體」的固定 ID 需視為缺失值而非實體；進入實作階段應透過 DuckDB 建立穩健的前處理管線，將 2.4 GB 原始資料聚合成 70 萬起事件之特徵矩陣。
2. **ExCyTIn-Bench 評估環境部署與備案切換測試**：`proposal.md` §5.5 指出 ExCyTIn-Bench 依賴受控 Azure 租戶 SQL 環境，若正式實驗時環境依賴遇到阻礙，應依風險對策於第 5 週平滑切換至 Splunk BOTS v3 開放日誌集作為多步調查展示情境。
3. **$\tau$ 與 $\tau_{safety}$ 雙門檻在驗證集上的網格搜尋與調優實驗**：目前兩項門檻為理論定義，實作時需於驗證集上繪製完整的 ROC 曲線與 Pareto 邊界，實證決定最適超參數組合，確保不使用測試集調參以避免高估表現。


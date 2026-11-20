# DIC3 專案重構歷程與 Prompt 使用紀錄表

> 本文件依據 DIC3 規範建立，紀錄專案重構四步驟流程中各階段 AI 工具之 Prompt 使用歷程、輸入內容、檢查修改過程與對應產出成果檔案。

---

## 第一階段：專案內容解析與高密度資訊圖表

### 1.1 專案結構深度解析
- **老師規範 Prompt 原文**：  
  `請按照 A2Z*.PDF 和期末專題規範*.pdf 來解析 <專題> 內容`
- **對應成果檔案**：[`docs/01-proposal-analysis.md`](01-proposal-analysis.md)
- **實際使用工具**：NotebookLM (NBLM)
- **我實際輸入的內容**：  
  在 NotebookLM 中建立專案筆記本，上傳《A2Z outline example.pdf》、《期末專題提案作業規範.pdf》，以及本專題之 `docs/proposal.md`、`DESIGN.md` 與簡報檔 `docs/AI_SOC_Analyst_Agent-Proposal.pptx` 作為事實來源。隨後輸入指令：  
  `請按照 A2Z*.PDF 和期末專題規範*.pdf 來解析 AI SOC Analyst Agent - 內容`
- **我如何檢查與修改輸出**：  
  1. 檢視模型是否精確比對《作業規範》四大核心維度（AI Agent、領域知識、數據分析、真實應用），補足系統在真實 SOC 告警疲勞與國安威脅場景的落實論述。  
  2. 嚴格檢查第二節 A2Z 結構表，確認 A–F、G–L、M–O、PA–PM（13 項完整拆解）、Q–V、W–Z 總計 38 個細項均有具體映射；將模型生成的粗略數字引用全面替換為準確的專案章節標註（例如 §2.4、DESIGN.md §9）。  
  3. 檢驗第三節評審建議，確認學術誠實度符合 Proposal 規範（僅列 Expected Outcomes，未捏造實驗結果），並加入 GUIDE 匿名欄位處理與 ExCyTIn 租戶環境備案切換等真實精進建議，整合定稿為 `docs/01-proposal-analysis.md`。

---

### 1.2 A4 橫式高密度資訊圖表
- **老師規範 Prompt 原文**：  
  `請分析內容 做成 資訊圖表 A4 橫式 高密度 NUMBERING`
- **對應成果檔案**：[`docs/02-infographic.pdf`](02-infographic.pdf)（原始碼：[`docs/02-infographic.html`](02-infographic.html)）
- **實際使用工具**：ChatGPT (GPT-4o) + Chrome Headless CLI
- **我實際輸入的內容**：  
  將 `docs/01-proposal-analysis.md` 的系統解析內容與架構流程輸入 ChatGPT，並附上 `docs/teacher-ref/2.DietSense資訊圖表.png` 參考版面，下達指令：  
  `請分析內容 做成 資訊圖表 A4 橫式 高密度 NUMBERING。要求：單一 HTML 檔內嵌 CSS，設定 @page { size: A4 landscape; margin: 5mm; }，列印剛好一頁。版面涵蓋七大區塊編號 1～7（1 符合度總覽、2 Abstract/Intro、3.5 Deep Research 置於中間頂部、4 Proposed Scheme 八大模組與流程/虛擬碼左右並排、5 A2Z Outline 表格、6 評估規劃、7 整體結論），色彩層次清晰，高密度填滿三欄，無任何留白死角。`
- **我如何檢查與修改輸出**：  
  1. 檢視初始版面，發現原版本中間欄下方留有大片空白死角，且部分數學公式包含未渲染的 LaTeX 符號（如 `$p_{TP} \ge \tau_{safety}$`）。  
  2. 依據老師範例進行重構：將「3.5 Deep Research」獨立置於中間欄頂部（紫色標題），將「4.2 系統流程圖」與「4.3 演算法 Algorithm 1 節錄」調整為左右雙欄並排（Side-by-Side），並將 LaTeX 符號全數改為清晰的標準 Unicode 數學符號（`p_TP ≥ τ_safety`、`conf < τ`）。  
  3. 透過 Chrome Headless 執行列印輸出 PDF，經底層 PDF 結構解析確認為單一頁面物件（`Count 1`，無溢出第二頁），三欄垂直空間完全對齊均衡，產出 `docs/02-infographic.pdf` 與 `docs/02-infographic.html`。

---

## 第二階段：文獻數據檢索、A–F 框架強化與多層次摘要提煉

### 2.1 權威研究數據與案例檢索
- **老師規範 Prompt 原文**：  
  `有關下面內容主題 請查找最新研究報告數據 案例新聞 使得研究有說服力 Interesting, innovation, important`
- **對應成果檔案**：[`docs/03-abstract-refined.md`](03-abstract-refined.md)（關聯至 `docs/proposal.md` §2.1 最新統計數據）
- **實際使用工具**：Perplexity AI
- **我實際輸入的內容**：  
  提供資安維運中心（SOC）告警處理與進階威脅防禦之專題背景，指令如下：  
  `有關下面內容主題 請查找 2025–2026 最新權威研究報告數據、政府公報與產業案例，使得研究有說服力（Interesting, innovation, important）：針對 SOC 告警疲勞程度、真實攻擊所佔比例、企業資料外洩平均成本與處理週期、攻擊者潛伏期（Dwell Time），以及台灣關鍵基礎設施遭受網路侵擾之官方統計。`
- **我如何檢查與修改輸出**：  
  1. 查證並篩選出具權威性的第一手公開數據：我國國安局 2025 年資安報告（中共侵擾關鍵設施日均 263 萬次，+6% [23]）、IBM 2026 Cost of a Data Breach 報告（外洩平均成本創 499 萬美元新高、平均處理週期 247 天 [14]），以及 Mandiant M-Trends 2026（潛伏期中位數 14 天、網路間諜達 122 天 [15]）。  
  2. 剔除二手科技新聞的不具名引述，確認所有數據皆有確切出處與機構報告對照，並將數據嚴格一致地回饋更新至 `docs/proposal.md` §2.1 與後續各版摘要中。

---

### 2.2 結構化 A to F 專業摘要生成
- **老師規範 Prompt 原文**：  
  `A TO F`
- **對應成果檔案**：[`docs/03-abstract-refined.md`](03-abstract-refined.md) 第一節
- **實際使用工具**：Perplexity AI / Claude 3.5 Sonnet
- **我實際輸入的內容**：  
  在對話中承接已查證的最新數據與專案核心解法，輸入指令：  
  `A TO F`  
  （要求依 Attention Getter、But、Cure、Development、Experiments、Findings 六段式架構輸出專業摘要）。
- **我如何檢查與修改輸出**：  
  1. 檢查六段架構標籤是否完整，嚴格檢視 F 段是否遵守提案階段學術規範，僅描述「Expected Outcomes / 預期產出」，嚴禁出現捏造之假實驗數值。  
  2. 核對原文獻引用編號 [1]–[26] 是否正確對應，確保各段字數控制在 150 字以內，文字論述精確具體，落實至 `docs/03-abstract-refined.md` 第一節。

---

### 2.3 預期貢獻與學術價值彙整
- **老師規範 Prompt 原文**：  
  `幫我整理這份研究主題的預期貢獻與學術價值`
- **對應成果檔案**：[`docs/03-abstract-refined.md`](03-abstract-refined.md) 第二節
- **實際使用工具**：Perplexity AI
- **我實際輸入的內容**：  
  輸入八大模組架構、決策演算法（Algorithm 1 & 2）與評估規劃，指令：  
  `幫我整理這份研究主題的預期貢獻與學術價值。預期貢獻請以 proposal §2.6 的五大貢獻（系統架構、決策方法、實證評估、領域知識、規範治理）為基礎各寫 1–2 句；學術價值請歸納 3–4 點，說明對學術研究的理論意義（如非對稱錯誤成本演算法化、回應 §3.4 Research Gap、雙公開基準防洩漏評估、OpenSpec SDD 提升可重現性），並標註對應的 proposal 章節編號。`
- **我如何檢查與修改輸出**：  
  1. 檢查預期貢獻是否精準對照 §2.6.1 至 §2.6.5，避免過度寬泛的空泛宣稱。  
  2. 檢查學術價值四個面向是否皆標註明確章節（如「見 §1.1、§3.4、§5.4」），確認論述深度聚焦於資安領域「Assume Breach」與「錯誤成本不對稱」的演算法落實，整理納入 `docs/03-abstract-refined.md` 第二節。

---

### 2.4 A to F 加強版補充與優化
- **老師規範 Prompt 原文**：  
  `review A to F 你想加強的部分重寫補充`
- **對應成果檔案**：[`docs/03-abstract-refined.md`](03-abstract-refined.md) 第一節（A to F 加強版）
- **實際使用工具**：Claude 3.5 Sonnet
- **我實際輸入的內容**：  
  輸入初版 A to F 摘要與專案技術細節，指令：  
  `review A to F 你想加強的部分重寫補充。請結合 §2 Introduction 與 §3 Related Work 文獻脈絡，加強技術對抗防禦（如查無紀錄時過早結案 [3]）、人因自動化自滿 [12]、Chroma 向量庫與 NIST Playbook 具體元件，以及 GUIDE 百萬級事件防洩漏切分規劃；每段文字維持在 150 字以內，保留引用編號，F 段僅寫 Expected Outcomes。`
- **我如何檢查與修改輸出**：  
  1. 逐段審閱強化內容：B 段補強 AIDA 揭露之 40.4% 漏判率與查無紀錄過早結案問題；D 段明確指名 LightGBM、Chroma 向量庫與 ReAct 調查；E 段指明 GUIDE 與 ExCyTIn-Bench 雙重基準。  
  2. 以 Python 程式驗證字數，確認 A 至 F 六段字數分別為 147、133、117、105、105、107 字，皆在 150 字限制內，成果更新至 `docs/03-abstract-refined.md` 第一節。

---

### 2.5 重點摘要提煉（老師稱「300 字」，實例約 450–520 字）
- **老師規範 Prompt 原文**：  
  `最後擷取重要文字 重新產生 300 字`
- **對應成果檔案**：[`docs/03-abstract-refined.md`](03-abstract-refined.md) 第三節
- **實際使用工具**：Claude 3.5 Sonnet
- **我實際輸入的內容**：  
  輸入加強版 A to F 摘要，指令：  
  `最後擷取重要文字 重新產生 300 字。要求：一整段連續繁體中文（不分段、不加【A】標籤、不放文獻引用編號），長度對照老師 DietSense 範例規格控制在 450–520 字（漢字 + 英文單字 + 數字組）。依序涵蓋：問題規模（含國安局 263 萬次、IBM 499 萬美元兩組數據）→ 現有方法缺陷 → 提出的 AI SOC Analyst Agent → 核心設計（GBDT 分級、ATT&CK 知識、LLM 推理、證據融合與主動升級）→ 資料集與評估規劃 → 預期產出。`
- **我如何檢查與修改輸出**：  
  1. 檢查邏輯連續性，確認無多餘標籤與段落分隔符，技術名詞標準保留英文。  
  2. 透過 Python 腳本進行精確字數驗證：漢字 437 字、英文單字 24 詞、數字 6 組，總計 **467 字**，精準落在 450–520 字的標準範本區間內，收錄至 `docs/03-abstract-refined.md` 第三節。

---

## 第三階段：國際學術頂刊風格英文摘要

### 3.1 IEEE Transactions 英文摘要轉換
- **老師規範 Prompt 原文**：  
  `IEEE transaction Systems journal style`
- **對應成果檔案**：[`docs/04-ieee-abstract.md`](04-ieee-abstract.md)
- **實際使用工具**：ChatGPT (GPT-4o)
- **我實際輸入的內容**：  
  輸入 467 字連續中文摘要與系統關鍵架構，指令：  
  `Please transform this proposal into IEEE transaction Systems journal style. Requirements:  
  1. Title— One line, format: 'System Name: A ... for ...'  
  2. Abstract— Single paragraph, 280–340 English words. Structure: Context & threat scale → Existing limitations → Proposed system (This paper proposes...) → Architecture & core mechanisms → Evaluation plan (using 'will') → Expected outcomes & significance. Expand all acronyms upon first mention (SOC, LLM, GBDT). No citations, formal academic tone, no reported experimental numbers.  
  3. Index Terms— 6–8 keywords, alphabetical order, comma-separated.`
- **我如何檢查與修改輸出**：  
  1. 檢查英文摘要字數，實測為 **288 個英文字**（落在 280–340 詞標準區間），結構完整流暢。  
  2. 嚴格核對專業縮寫：security operations center (SOC)、large language model (LLM)、gradient-boosted decision tree (GBDT) 第一次出現皆已完整展開全名。  
  3. 確認評估描述全數使用未來式「will」，無任何未發生的數值宣稱；檢核 7 個 Index Terms 依字母排序無誤，定稿收錄於 `docs/04-ieee-abstract.md`。

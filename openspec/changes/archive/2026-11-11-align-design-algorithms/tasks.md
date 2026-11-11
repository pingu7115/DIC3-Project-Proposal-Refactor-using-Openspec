# Tasks: align-design-algorithms

## 1. Specification Delta

- [x] 1.1 在 `specs/evidence-fusion/spec.md` 中新增「Safety-Biased Relabeling under High Risk」需求，包含足夠 TP 機率與低 TP 機率兩項情境驗證

## 2. Technical Design Alignment

- [x] 2.1 完整複製 `DESIGN.md` §9 之 Algorithm 1（24 行）與 Algorithm 2（9 行）偽代碼至 `design.md`
- [x] 2.2 完整移植 `IsSufficient(E)` 終止判斷準則與 `OneHotWithConfidence` 信心向量映射說明
- [x] 2.3 在 `design.md` 中詳細條列相較於舊版簡化偽代碼之四大架構差異

## 3. Proposal Formulation

- [x] 3.1 於 `proposal.md` 中撰寫 Why（說明演算法不一致與缺少 $\tau_{safety}$ 規則之問題，控制在 800 字元內）與 What Changes
- [x] 3.2 於 `proposal.md` 中宣告 `evidence-fusion` 之 Modified Capability 與系統影響

## 4. Verification & Archive

- [x] 4.1 執行 `openspec validate --all --strict` 確認所有規格與變更檔案合規無誤
- [x] 4.2 執行 `openspec archive align-design-algorithms --yes` 將變更歸檔並同步主規格

## Workflow follow-up

- 驗證主規格 `openspec/specs/evidence-fusion/spec.md` 包含新需求並通過最終驗證。

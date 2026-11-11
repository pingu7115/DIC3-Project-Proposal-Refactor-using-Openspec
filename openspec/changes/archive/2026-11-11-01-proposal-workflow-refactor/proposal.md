# Proposal: 01-proposal-workflow-refactor

## Why

This proposal formalizes and refactors the **AI SOC Analyst Agent** project proposal according to the Spec-Driven Development (SDD) standard introduced in DIC3. 

In enterprise Security Operations Centers (SOCs), Tier-1 analysts face crippling alert fatigue, processing tens of thousands of alerts daily where only a tiny fraction represent true attacks. Traditional machine learning models lack attack-chain context and interpretability, whereas standalone LLM agents suffer from high miss rates (>40.4% in recent empirical benchmarks like Tsegai et al., 2026) and premature closure on missing logs. 

To transition from an ad-hoc academic proposal into an engineered, verifiable, and extensible system, this change introduces OpenSpec formal specifications, defines explicit behavioral contracts across all triage and fusion stages, and refactors core documentation (Abstract A-F, 5 Cores, 3 Trade-offs, 10 Details, Introduction, and Related Work) to ground the research in rigorous empirical baselines.

## What Changes

1. **OpenSpec Spec-Driven Development Framework**:
   - Establish baseline specifications (`specs/triage-workflow` and `specs/evidence-fusion`) to define verifiable operational semantics for incident intake, multi-hop investigation, ML classification, domain rule evaluation, and human-in-the-loop escalation.
   - Convert the unstructured `DESIGN.md` into actionable OpenSpec technical workflows, execution graphs, and decision protocols.
2. **Project Proposal Core Refactoring**:
   - **Abstract (A to F)**: Re-anchor the ~500-word abstract with 2025–2026 authoritative threat data (National Security Bureau 2025 report on 2.63M daily attacks; IBM 2026 Cost of a Data Breach at $4.99M; Introduction §2.1.2 引用 Mandiant M-Trends 2026 median dwell time of 14 days), clearly demarcating `[A]` Attention Getter, `[B]` But, `[C]` Cure, `[D]` Development, `[E]` Experiments, and `[F]` Findings / Expected Outcomes.
   - **5 Cores**: Formulate the Five Cores (M1 Assume Breach, M2 Attack Chain Context, M3 Asymmetric Error Costs, M4 TTPs over IOCs, M5 Verifiable Automation) and their derivation into three system innovations.
   - **3 Trade-offs**: Formalize the primary engineering tensions (Miss Rate vs. Escalation Rate, GBDT Statistical Efficiency vs. LLM Contextual Reasoning, Deterministic Rules vs. Agent Autonomy).
   - **10 Details**: Detail the 10 deep understanding questions bridging operational SOC reality with agent architectural decisions.
3. **Introduction and Related Work Refactoring**:
   - Refactor Section 2 (Introduction) with dense numbering, threat landscape metrics, and problem formalization.
   - Refactor Section 3 (Related Work) into AI Technology (8 papers) and Domain Know-how (8 papers), explicitly documenting author-stated limitations for every study and contrasting them against this project.
4. **Operations and Handover Tooling**:
   - Implement `startup.sh` (environment check, remote pull, spec validation, onboarding prompt) and `ending.sh` (comprehensive verification, task completion audit, git commit and push).

## Capabilities

### New Capabilities
- `triage-workflow`: Orchestrates the end-to-end incident triage lifecycle, from incident request validation, ReAct-based evidence retrieval across heterogeneous log stores, to ATT&CK TTP mapping and structured report generation.
- `evidence-fusion`: Executes hybrid multi-modal decision fusion combining GBDT prediction probabilities, SHAP explainability values, hard-coded Kill Chain high-risk rules (R1~R5), and Assume Breach uncertainty escalation protocols.

### Modified Capabilities
- None (baseline change initializing system capabilities).

## Impact

- **Codebase & Specs**: Adds `openspec/` specification directory, `startup.sh`, `ending.sh`, and updates `docs/proposal.md`, `DESIGN.md`, and `README.md`.
- **Runtime Environment**: Targets Node.js v24+ for OpenSpec CLI execution and Python 3.10+ for data profiling and triage agents.
- **Git Repository**: Pushes all refactored artifacts directly to the student's individual repository (`pingu7115/DIC3-Project-Proposal-Refactor-using-Openspec.git`) without modifying the upstream group repository.


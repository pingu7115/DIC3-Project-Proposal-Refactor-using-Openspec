# Tasks: 01-proposal-workflow-refactor

## 1. OpenSpec Spec-Driven Development Environment Setup

- [x] 1.1 Deploy Node.js v24 runtime environment and verify execution paths.
- [x] 1.2 Install `@fission-ai/openspec` CLI globally and verify version.
- [x] 1.3 Initialize OpenSpec repository configuration for Antigravity (`openspec init --tools antigravity`).
- [x] 1.4 Establish standardized change naming convention starting with `01-` prefix.

## 2. Proposal Core Formulation (DIC3 Requirement 2)

- [x] 2.1 Refactor A to F Abstract (~500 Chinese characters) with explicit `[A]` through `[F]` labels.
- [x] 2.2 Incorporate authoritative 2025–2026 empirical threat metrics (NSB 2025, IBM 2026, Mandiant M-Trends 2026, Tsegai et al. 2025).
- [x] 2.3 Formulate Three Core Innovations modeled after the DietSense paradigm (Evidence Fusion, ATT&CK Constraints, Proactive Escalation).
- [x] 2.4 Articulate Three Critical Engineering Trade-offs (Miss Rate vs. Escalation Rate, GBDT vs. LLM, Rules vs. Autonomy).
- [x] 2.5 Synthesize Ten Deep Understanding Details connecting domain SOC realities with system design choices.

## 3. DESIGN.md to OpenSpec Workflow Conversion (DIC3 Requirement 3)

- [x] 3.1 Establish delta specifications for `triage-workflow` capability (`specs/triage-workflow/spec.md`).
- [x] 3.2 Establish delta specifications for `evidence-fusion` capability (`specs/evidence-fusion/spec.md`).
- [x] 3.3 Transform `DESIGN.md` into OpenSpec technical design document (`design.md`) with Mermaid diagrams and decision matrices.
- [x] 3.4 Formalize Algorithm 1 (SOC Triage Agent Workflow) and Algorithm 2 (Evidence Fusion & Escalation).
- [x] 3.5 Sync baseline specifications under `openspec/specs/`.

## 4. Introduction Refactoring (DIC3 Requirement 4)

- [x] 4.1 Apply dense numbering structure (A2Z style) across all Section 2 subsections.
- [x] 4.2 Strengthen Background subsection with Tier-1 triage vs. Tier-2/3 investigation distinctions and AIoT correlation.
- [x] 4.3 Formulate explicit Problem Statement regarding alert fatigue and triage bottleneck.
- [x] 4.4 Structure Existing Limitations into a comparative breakdown across five key industry challenges.
- [x] 4.5 Detail Five System, Methodological, Experimental, Domain, and Handover Contributions.

## 5. Related Work Refactoring (DIC3 Requirement 5)

- [x] 5.1 Categorize core literature into AI Technology (8 studies) and Domain Know-how (8 studies).
- [x] 5.2 Document author-stated limitations (`作者自述限制`) for all 16 reviewed papers.
- [x] 5.3 Build cross-dimensional comparative matrix contrasting SOTA systems with this project.
- [x] 5.4 Articulate strategic architectural positioning against the most proximate benchmark (AIDA).

## 6. Operations & Handover Automation (DIC3 Slide Requirement)

- [x] 6.1 Create `startup.sh` script for automated repository pull, environment validation, and developer briefing.
- [x] 6.2 Create `ending.sh` script for automated OpenSpec validation, task verification, git commit, and remote push.
- [x] 6.3 Verify execution permissions and cross-platform compatibility for Windows / Linux.

## 7. Quality Verification & Git Integration

- [x] 7.1 Execute `openspec validate --all` to confirm schema and dependency compliance.
- [x] 7.2 Verify remote origin points exclusively to `pingu7115/DIC3-Project-Proposal-Refactor-using-Openspec.git`.
- [x] 7.3 Stage, commit, and push refactored repository assets.

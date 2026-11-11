# Spec Delta: evidence-fusion

## ADDED Requirements

### Requirement: Safety-Biased Relabeling under High Risk
When a high-risk rule fires, the fusion module MUST relabel the incident as TP if the ML probability p_TP is at least the safety threshold τ_safety, implementing the asymmetric error cost principle (NFR2).

#### Scenario: High-risk incident with sufficient TP probability
- **WHEN** a high-risk rule (R1–R5) fires, the fused label is BP or FP, and p_TP ≥ τ_safety
- **THEN** the fusion module relabels the incident as TP and adds `high_risk` to the flag set.

#### Scenario: High-risk incident with low TP probability
- **WHEN** a high-risk rule fires but p_TP < τ_safety
- **THEN** the fusion module keeps the fused label, adds `high_risk` to the flag set, and the incident is still escalated for human review.

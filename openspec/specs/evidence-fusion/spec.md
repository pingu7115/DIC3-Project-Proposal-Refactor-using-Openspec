# Specification: evidence-fusion

## Purpose

Defines the behavioral specifications for multi-modal evidence fusion, high-risk Kill Chain rule enforcement, and human-in-the-loop uncertainty escalation within the AI SOC Analyst Agent system.

## Requirements

### Requirement: Hybrid Multi-Modal Classification and Fusion

The system MUST combine tabular machine learning probability distributions $p_{ML} = (p_{TP}, p_{BP}, p_{FP})$ with LLM reasoning evaluations $p_{LLM}$ using a calibrated weighted fusion function.

#### Scenario: Weighted Probability Calibration
- **WHEN** the GBDT classifier and LLM reasoning agent yield concordant verdict classifications with high confidence
- **THEN** the fusion module combines their calibrated posterior distributions and outputs the consensus triage classification.

#### Scenario: Conflicting Verdict Escalation
- **WHEN** the GBDT classification and LLM reasoning agent produce divergent verdicts (e.g., ML predicts TP while LLM predicts BP)
- **THEN** the fusion module detects verdict dissonance, sets the escalation flag `conflict_detected = True`, and routes the incident for Tier-2 analyst review.

### Requirement: Hard-Coded Kill Chain High-Risk Rule Enforcement

The decision engine MUST enforce deterministic high-risk rules (R1 to R5) derived from domain incident response standards, overriding pure probabilistic confidence.

#### Scenario: Exfiltration or Impact Stage Trigger (R1)
- **WHEN** an incident contains ATT&CK tactics belonging to Exfiltration, Impact, or Ransomware categories
- **THEN** rule R1 fires, marking `high_risk = True` and prohibiting autonomous closure regardless of low model probability scores.

#### Scenario: Credential Access Coupled with Lateral Movement (R2)
- **WHEN** an incident exhibits evidence of both Credential Access and Lateral Movement within the same attack window
- **THEN** rule R2 fires, escalating the incident immediately with recommendations to revoke active sessions and isolate affected subnetworks.

#### Scenario: Evidence Removal Detection (R4)
- **WHEN** evidence indicates log clearing or event deletion activities (ATT&CK T1070)
- **THEN** rule R4 fires, invalidating any "no negative records found" conclusion and escalating for forensic log recovery.

### Requirement: Assume Breach Uncertainty Escalation

The system MUST trigger human review whenever confidence falls below threshold $\tau$, evidence is insufficient, or anomalous log gaps are identified.

#### Scenario: Low Confidence Escalation
- **WHEN** the fused confidence score $\max(P(TP), P(BP), P(FP)) < \tau$
- **THEN** the incident is labeled `needs_human_review = True`, accompanied by a breakdown of top SHAP features and unresolved ambiguities.

#### Scenario: Analyst Feedback Capture
- **WHEN** a human analyst overrides or confirms an agent triage recommendation
- **THEN** the system logs the analyst verdict, rationale, and corrected feature representations into the active historical vector store for continuous few-shot alignment and model retraining.

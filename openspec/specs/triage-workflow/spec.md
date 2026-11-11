# Specification: triage-workflow

## Purpose

Defines the core operational specifications for the SOC Alert Triage Workflow, establishing requirements for incident ingestion, multi-hop investigation, ATT&CK mapping, and structured reporting.

## Requirements

### Requirement: Incident Request Ingestion and Schema Normalization

The system MUST accept structured incident IDs, alert batches, or natural language investigative queries and normalize them into a validated `TriageRequest` object with schema enforcement.

#### Scenario: Valid Incident ID Ingestion
- **WHEN** an analyst submits an incident request containing a valid `IncidentId` and `OrgId`
- **THEN** the system parses the input into `TriageRequest`, initializes the investigative state, and transitions to Planner task decomposition.

#### Scenario: Malformed Input Rejection
- **WHEN** an incoming triage request lacks mandatory identifiers or contains corrupted payload structures
- **THEN** the system rejects the request immediately, logs a validation failure event, and returns a structured diagnostic error requesting analyst correction.

### Requirement: Budget-Constrained Evidence Gathering Loop

The Planner Agent MUST iteratively query evidence stores (DuckDB incident evidence store or ExCyTIn SQL logs) under strict tool-call and token budget constraints following the Assume Breach principle.

#### Scenario: Multi-hop Query Expansion
- **WHEN** the initially gathered evidence lacks critical host or account context and remaining budget $B > 0$
- **THEN** the Planner autonomously executes multi-hop queries across related entities (e.g., authentication logs for the compromised user, process launch logs for the targeted host) before finalizing classification.

#### Scenario: Tool Budget Exhaustion
- **WHEN** the tool-call count reaches budget $B$ without satisfying full evidence sufficiency criteria
- **THEN** the system terminates the evidence gathering loop, marks the evidence status as `insufficient_evidence`, and forces an escalation review trigger.

### Requirement: ATT&CK Tactic and Technique Alignment

The system MUST map parsed alerts and investigative logs to MITRE ATT&CK Tactics and Techniques using vector retrieval and ontology rules.

#### Scenario: Technique Identification and Kill Chain Positioning
- **WHEN** evidence items contain discernible event IDs, process execution strings, or network IOCs
- **THEN** the knowledge retrieval component matches them against the ATT&CK vector database, assigns corresponding Technique IDs (e.g., T1078, T1059), and computes the furthest Kill Chain progression stage.

### Requirement: Structured Incident Reporting

The system MUST produce a comprehensive, auditable incident triage report in both JSON and Markdown formats.

#### Scenario: Triage Report Generation
- **WHEN** the triage decision and recommended actions are finalized
- **THEN** the system outputs a report including predicted class (TP / BP / FP), confidence score, SHAP feature rankings, mapped ATT&CK techniques, evidence source citations, and human review status.


# Scenario library

Fallback scenario families for when threat research is unavailable, returns
thin results, or the user declines research. A researched scenario grounded in
real precedent is always preferred. These families are starting structures, not
finished scenarios — the orchestrator still tailors every one to the declared
stack, services, and tier.

Each family lists the stack signals that make it relevant, the decisions it
forces, and the standards it exercises.

**Select exactly one family per tabletop.** These are a menu, not a sequence. A
single exercise runs one scenario from one family, developed to the tier's
depth. Never blend two families into one exercise or run a second family after
the first — that is a separate tabletop with its own package and its own
after-action report. Choose the family whose stack signals best match the
Organization Exercise Profile, and record the runners-up as candidates for the
organization's next exercise.

## A. Ransomware with data exfiltration

Relevant when: Windows endpoints, on-premises or hybrid file shares, VPN or RDP
remote access, virtualization, or a backup estate reachable with production
credentials.

Forces decisions on: containment versus business continuity, isolation
authority, backup integrity and restore confidence, extortion and ransom
decision authority, evidence preservation before rebuild, insurer notification,
law-enforcement engagement, and customer and employee communication.

Exercises: SP 800-61r3 RS and RC; SP 800-53 IR-4, IR-6, CP-9, CP-10;
ATT&CK T1486, T1490, T1567, T1078.

Common inject arc: anomalous authentication → helpdesk reports of file access
errors → ransom note and encrypted shares → extortion contact with a sample of
exfiltrated data → journalist inquiry → partial restore fails.

## B. Business email compromise and payment fraud

Relevant when: Microsoft 365 or Google Workspace, finance approval workflows,
wire or ACH payments, vendor invoicing, or MFA gaps.

Forces decisions on: account containment without disrupting business, transfer
recall windows, forensic scope in a mailbox tenant, whether a data breach
occurred alongside the fraud, notification obligations for mailbox contents,
and vendor and bank coordination.

Exercises: SP 800-61r3 DE and RS; SP 800-53 IR-4, IR-6, AC-2, IA-2;
ATT&CK T1078.004, T1114, T1534, T1566.

Common inject arc: mailbox rule discovered → vendor bank-detail change → wire
sent → second mailbox flagged → the compromised mailbox held regulated records.

This family is the highest-value Tier 1 scenario for most small organizations.

## C. Cloud identity and console compromise

Relevant when: AWS, Azure, or GCP; an IdP such as Entra ID, Okta, or Google;
long-lived access keys; CI/CD with cloud credentials; or SSO across SaaS.

Forces decisions on: credential revocation versus outage, blast-radius
determination across federated SaaS, log availability and retention adequacy,
resource-level containment, and whether customer data in object storage was
accessed.

Exercises: SP 800-61r3 ID, DE, RS; SP 800-53 IR-4, IR-5, AC-2, AU-6;
ATT&CK T1078.004, T1098, T1580, T1530.

Common inject arc: impossible-travel alert → new IAM principal created →
unusual egress from object storage → cost anomaly → logs for the relevant
window were never retained.

## D. Application, API, or web-service compromise

Relevant when: the organization builds and operates its own customer-facing
software, exposes APIs, or runs a multi-tenant platform.

Forces decisions on: taking the product offline, tenant-isolation verification,
disclosure to affected customers versus all customers, coordinated disclosure
with a researcher, hotfix versus rollback, and whether the vulnerability class
exists elsewhere in the estate.

Exercises: SP 800-61r3 RS and RC; SP 800-53 IR-4, IR-6, SI-2, SI-3; OWASP Top
10 and OWASP API Security Top 10; ATT&CK T1190, T1505.003.

Common inject arc: researcher email with a proof of concept → confirmation of
exploitation in logs → cross-tenant data access observed → customer notices →
the same pattern appears in a second service.

## E. Third-party, vendor, or supply-chain compromise

Relevant when: material SaaS dependencies, an MSP or MSSP with privileged
access, managed file transfer, payment processors, or a software supply chain
with third-party build dependencies.

Forces decisions on: acting on incomplete vendor information, whether the
organization is a victim or a notifier or both, contractual notification
windows, revoking vendor access mid-incident, and communicating about an
incident the organization does not control.

Exercises: SP 800-61r3 GV and RS; CSF 2.0 GV.SC; SP 800-161r1; SP 800-53 IR-4,
IR-6, SR-8; ATT&CK T1195, T1199.

Common inject arc: vendor status page degradation → vendor confirms a security
incident with no detail → customers ask whether their data was involved →
vendor confirms data was accessed → the vendor's notification timeline breaches
the organization's own contractual commitment to its customers.

## F. Insider action or credential misuse

Relevant when: privileged administrators, source-code or dataset access,
recent or upcoming layoffs, contractors, or offboarding gaps.

Forces decisions on: investigating a named employee, HR and legal sequencing,
privilege revocation timing, evidence handling that survives employment
litigation, monitoring proportionality, and privacy obligations toward the
subject.

Exercises: SP 800-61r3 GV, DE, RS; SP 800-53 IR-4, AC-2, AU-6, PS-4;
ATT&CK T1078, T1052, T1530.

Common inject arc: bulk download alert on a departing employee → account
already disabled but a personal integration token still works → the data
includes customer records → the employee has joined a competitor.

Handle with care. Keep role-players anonymous, avoid resembling any real
current employee, and confirm with the user before running this family.

## G. Operational technology or physical-adjacent disruption

Relevant when: manufacturing, healthcare devices, building systems, logistics,
utilities, or any environment where a cyber event has a physical consequence.

Forces decisions on: safety-first shutdown authority, IT/OT isolation, manual
fallback procedures, regulator and safety-body notification, and when the
engineering or clinical authority overrides the security decision.

Exercises: SP 800-61r3 RS and RC; SP 800-82r3 for OT context; SP 800-53 IR-4,
CP-2, CP-10.

Common inject arc: IT network ransomware → OT segmentation status unknown →
production or clinical operations halted as a precaution → manual procedures
prove undocumented → restoring OT requires a vendor who is unreachable.

## Scenario safety rules

These apply to every family and every tier.

- The scenario is fictional. Say so at the start and whenever a participant
  appears to believe a real incident is underway.
- Never instruct participants to touch, alter, isolate, shut down, or restore a
  live production system, and never generate a command intended for real
  execution. If a participant proposes an action, they describe it; they do not
  perform it.
- Never send a real message, email, page, or ticket to a real person as part of
  the exercise. Injects are delivered in-chat by the facilitator only.
- Do not use a real named third party as the compromised party in a
  vendor-breach scenario unless the user explicitly chooses that framing. Use a
  generic placeholder such as "your managed file-transfer vendor" by default.
- Do not build the scenario around a real, currently unpatched vulnerability in
  the organization's own environment in a way that reads as an exploitation
  plan. Describe the consequence and the response, not the exploit steps.
- Where a real incident precedent inspires the scenario, fictionalize the
  affected organization. Cite the precedent in facilitator notes and in the
  after-action report, not as an accusation inside the narrative.

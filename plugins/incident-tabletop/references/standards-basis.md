# Standards basis

Cite the exact publication, revision, and section next to every requirement,
probe, finding, and recommendation the workflow produces. When a probe comes
from an organization policy, contract, or regulation instead, label that basis
explicitly. Never imply NIST, CISA, SANS, or OWASP support when an exact mapping
is unavailable.

## Exercise design authority

**NIST SP 800-84**, _Guide to Test, Training, and Exercise Programs for IT Plans
and Capabilities_. This is the primary authority for how the exercise itself is
built and run. Use it for:

- Section 3.2 — tabletop exercise definition, discussion-based format, and the
  facilitator role;
- Section 3.2.1 — exercise scope, objectives, and participant selection;
- Section 3.2.2 — scenario and inject design, including the Master Scenario
  Events List (MSEL);
- Section 3.2.3 — exercise conduct and facilitation;
- Section 3.3 — post-exercise analysis, the after-action report, and feeding
  findings back into the plan.

The MSEL is the ordered list of scenario events (injects) delivered to
participants, each with a delivery time, the expected participant action, and
the objective it exercises. Every exercise this plugin produces has an MSEL,
including Tier 1.

**CISA Tabletop Exercise Packages (CTEP)** provide publicly available,
sector-specific tabletop templates and the situation-manual/inject structure
used across US critical-infrastructure sectors. Use CTEP as a structural model
and for sector framing. CTEP is a template source, not a control benchmark.

## Incident response content authority

**NIST SP 800-61 Rev. 3**, _Incident Response Recommendations and
Considerations for Cybersecurity Risk Management_ (April 2025). Rev. 3
reorganizes incident response around the CSF 2.0 Functions rather than the
Rev. 2 four-phase lifecycle. Use it for what participants should be deciding:

- GV (Govern) — incident response policy, roles, authorities, and third-party
  and supply-chain incident expectations;
- ID (Identify) — asset, criticality, and risk context that shapes triage;
- PR (Protect) — the controls whose failure or success the scenario tests;
- DE (Detect) — detection sources, alerting, and event analysis;
- RS (Respond) — triage, escalation, analysis, containment, eradication,
  notification, and coordination;
- RC (Recover) — restoration, validation, and recovery communication;
- Continuous improvement — lessons learned feeding back into GV/ID/PR/DE/RS/RC.

**NIST SP 800-61 Rev. 2**, Section 3, is still the lifecycle many organizations
have written into their plans: Preparation; Detection and Analysis;
Containment, Eradication, and Recovery; Post-Incident Activity. When the
organization's own plan uses this lifecycle, evaluate against Rev. 2 phases and
say so, rather than forcing the organization onto Rev. 3 vocabulary mid-exercise.

**SANS incident handling** uses the six-step PICERL model: Preparation,
Identification, Containment, Eradication, Recovery, Lessons Learned. Use PICERL
when the organization's responders are trained on it. It maps cleanly onto
SP 800-61 Rev. 2 phases; state the mapping instead of introducing a third
vocabulary.

**NIST SP 800-53 Rev. 5**, control family IR, for control-level traceability:

- IR-1 policy and procedures;
- IR-2 incident response training;
- IR-3 incident response testing, which is the control a tabletop exercise
  directly evidences;
- IR-4 incident handling;
- IR-5 incident monitoring;
- IR-6 incident reporting;
- IR-7 incident response assistance;
- IR-8 incident response plan.

Cite IR-3 as the control the exercise exercises. Cite the others as the controls
the exercise observes in operation.

**NIST CSF 2.0** RS and RC Categories for outcome-level framing, and GV.SC for
third-party and supply-chain incident scenarios.

## Technical scenario authority

**MITRE ATT&CK** for adversary behavior. When the exercise describes attacker
tradecraft, name the technique and ID (for example, T1566 Phishing, T1486 Data
Encrypted for Impact, T1078 Valid Accounts) so injects stay behaviorally
realistic and defensible. Use ATT&CK at Tier 2 and Tier 3. At Tier 1, keep the
narrative in plain language and put technique IDs only in the facilitator notes.

**OWASP Top 10** and **OWASP API Security Top 10** for application- and
API-layer scenarios, where the organization's exposure is its own software
rather than its endpoints.

**NIST SP 800-161 Rev. 1** and **CSF 2.0 GV.SC** for supply-chain and
vendor-compromise scenarios.

## Regulatory and contractual clocks

Notification deadlines change the exercise materially, and they are the most
common place a tabletop reveals a real gap. Treat every clock as a candidate
requiring user confirmation of applicability. Do not assert that a regime
applies to the organization; ask, then record the answer.

Commonly applicable clocks include:

- SEC cybersecurity disclosure rules — Item 1.05 Form 8-K within four business
  days of determining an incident is material, for US public companies;
- GDPR Article 33 — supervisory-authority notification without undue delay and
  where feasible within 72 hours of awareness, with Article 34 data-subject
  notification where high risk;
- HIPAA Breach Notification Rule — individual notice without unreasonable delay
  and within 60 days, with the HHS and media thresholds that follow;
- PCI DSS — immediate notification of the acquirer and card brands on suspected
  account-data compromise;
- CIRCIA — covered-entity reporting to CISA for covered incidents, on the
  timeline in the final rule as implemented;
- US state breach-notification statutes, which vary by state and by data type;
- DFARS/CMMC reporting for defense contractors handling CUI;
- cyber-insurance policy notice conditions and customer contractual
  notification windows, which are frequently tighter than any statute.

Do not state a deadline as applying to the organization unless the user has
confirmed the regime is in scope. Where the user is unsure, deliver the inject
anyway and record the uncertainty as a finding — "the team could not determine
which notification clocks applied" is one of the most valuable findings a
tabletop produces.

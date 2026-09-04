# Standards basis

Cite the exact publication, revision, and section next to every requirement,
probe, finding, and recommendation the workflow produces. When a probe comes
from an organization plan, contract, or regulation instead, label that basis
explicitly. Never imply NIST or ISO support when an exact mapping is
unavailable.

## Exercise design authority

**NIST SP 800-84**, _Guide to Test, Training, and Exercise Programs for IT Plans
and Capabilities_. This is the primary authority for how the exercise is built
and run, and it covers contingency and recovery plans as directly as it covers
incident response plans. Use it for:

- Section 3.2 — tabletop exercise definition, discussion-based format, and the
  facilitator role;
- Section 3.2.1 — exercise scope, objectives, and participant selection;
- Section 3.2.2 — scenario and inject design, including the Master Scenario
  Events List (MSEL);
- Section 3.2.3 — exercise conduct and facilitation;
- Section 3.3 — post-exercise analysis, the after-action report, and feeding
  findings back into the plan.

## Recovery content authority

**NIST SP 800-34 Rev. 1**, _Contingency Planning Guide for Federal Information
Systems_. This is the primary authority for what participants should be
deciding. Use it for:

- Section 3.2 — the business impact analysis, and the derivation of recovery
  objectives from business function criticality;
- Section 3.4 — recovery strategies, including backup, alternate storage,
  alternate processing sites, and equipment replacement;
- Section 3.5 — plan structure and content;
- Section 4.1 — the **Activation and Notification** phase: outage detection,
  declaration criteria, declaration authority, and notification;
- Section 4.2 — the **Recovery** phase: sequencing, recovery procedures, and
  escalation when recovery does not proceed as planned;
- Section 4.3 — the **Reconstitution** phase: validation of restored systems,
  concurrent processing, failback, and formal return to normal operations.

These three phases are the spine of a recovery exercise. Where an organization
uses its own phase vocabulary, map to theirs and say so rather than imposing
NIST terms mid-exercise.

**ISO 22301:2019**, _Security and resilience — Business continuity management
systems — Requirements_, for organizations running a formal BCMS or holding
certification. Clause 8.4 covers business continuity plans and procedures,
including warning and communication; clause 8.5 covers exercising and testing;
clause 8.6 covers evaluation of business continuity documentation and
capabilities.

**ISO/TS 22317:2021** for business impact analysis method, where the
organization needs a defensible basis for its recovery objectives rather than
numbers someone once asserted.

**NIST SP 800-53 Rev. 5**, control family CP, for control-level traceability:

- CP-1 policy and procedures;
- CP-2 contingency plan, including coordination with related plans;
- CP-3 contingency training;
- **CP-4 contingency plan testing — the control a recovery tabletop directly
  evidences**;
- CP-6 alternate storage site;
- CP-7 alternate processing site;
- CP-8 telecommunications services;
- CP-9 system backup;
- CP-10 system recovery and reconstitution;
- CP-13 alternative security mechanisms.

Cite CP-4 as the control the exercise exercises. Cite the others as the controls
the exercise observes in operation. CP-4 is the recovery analogue of IR-3, and
the two are distinct: an incident response exercise does not evidence CP-4, and
a recovery exercise does not evidence IR-3.

**NIST CSF 2.0** for outcome-level framing:

- RC.RP — recovery plan execution;
- RC.CO — recovery communication with internal and external stakeholders;
- ID.AM and ID.BE — asset inventory and dependency understanding, which is
  where most recovery exercises actually fail;
- PR.DS and PR.IP — data security and backup processes.

## Recovery objectives and the numbers that drive the exercise

These are the recovery equivalent of the security plugin's notification clocks:
the commitments the exercise puts under pressure. Confirm each with the user
rather than assuming one exists.

- **RTO — Recovery Time Objective.** The target elapsed time from disruption to
  restored service for a given system or function.
- **RPO — Recovery Point Objective.** The maximum tolerable data loss,
  expressed as a time window. An RPO of four hours means losing up to four
  hours of data is acceptable.
- **MTD / MTPD — Maximum Tolerable Downtime / Period of Disruption.** The point
  beyond which the organization suffers unacceptable or unrecoverable harm.
  MTD bounds RTO: RTO plus work recovery time must fit inside MTD.
- **WRT — Work Recovery Time.** The time after technical restoration needed to
  validate data, reconcile transactions, and resume normal business work. Teams
  routinely forget this exists, and the exercise should test whether they have.
- **BIA — Business Impact Analysis.** The analysis that derives the above from
  business function criticality rather than from engineering intuition.

The single most productive line of questioning in a recovery tabletop is
comparing stated objectives against what the exercise reveals is actually
achievable. Treat a divergence as a finding, not a failure.

Where an organization has no stated RTO or RPO, that absence is itself the
finding. Do not invent numbers, and do not treat an engineer's confident
estimate as an organizational objective.

## Availability commitments and regulatory reporting

Outages carry external obligations that are frequently tighter than any internal
recovery objective, and are a common place a tabletop reveals a real gap. Treat
every commitment as a candidate requiring user confirmation of applicability. Do
not assert that a regime or commitment applies.

Commonly applicable commitments include:

- **customer SLAs and service credits** — uptime commitments, measurement
  windows, credit thresholds, and the notification duties that accompany them.
  These are contractual and are frequently the binding constraint;
- **status page and customer communication commitments**, whether contractual
  or reputational;
- **DORA** — Regulation (EU) 2022/2554, applying from 17 January 2025, requires
  in-scope financial entities to classify and report major ICT-related
  incidents, which includes availability disruptions, on defined timelines;
- **FFIEC** Business Continuity Management booklet expectations for US financial
  institutions, including resilience testing and third-party dependency
  management;
- **HIPAA Security Rule** contingency plan standard, 45 CFR 164.308(a)(7),
  requiring a data backup plan, disaster recovery plan, emergency mode operation
  plan, testing and revision procedures, and criticality analysis;
- **UK operational resilience** rules for regulated firms, including important
  business services and impact tolerances;
- **SEC** disclosure obligations where a disruption is material to a US public
  company, noting that materiality is a judgment the organization and its
  counsel make, not one this workflow makes;
- **cyber and business-interruption insurance** notice conditions, waiting
  periods, and proof-of-loss requirements, which are often overlooked until the
  claim is denied.

Where the user is unsure which commitments apply, deliver the inject anyway and
record the uncertainty as a finding. "The team could not determine what it had
promised customers about uptime or notification" is among the most valuable
findings a recovery tabletop produces.

## Relationship to the incident-tabletop plugin

Security incidents and outages overlap but are not the same exercise, and the
two plugins evidence different controls.

A recovery exercise may include a scenario whose cause is malicious — ransomware
is the common case — but its focus stays on restoration: backup integrity,
recovery sequencing, data loss, failback, and service restoration. If the
exercise turns substantially toward containment, evidence preservation, threat
actor behavior, breach notification, or law enforcement, that is incident
response work. Note it as a finding and recommend an incident response tabletop;
do not silently convert this exercise into one.

The reverse also holds. Where a security exercise surfaces a recovery gap, that
belongs to a recovery tabletop.

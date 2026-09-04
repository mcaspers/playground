# Exercise contract

This contract defines the five structures the moderator and its sub-agents pass
between each other. Sub-agents return these structures; the moderator holds
them. Pass references and deltas between stages instead of repeating raw
content.

Every structure is ephemeral until the user explicitly approves persistence.

## 1. Source Register

Produced by the `tabletop-intake` sub-agent from documents the organization
supplies in step one, before any questions are asked. Read `document-intake.md`
for how documents are gathered, extracted, and handled safely.

The register may legitimately be empty. A Tier 1 organization typically has no
documents, and the workflow proceeds without them.

Each entry has:

- `source_id` — a short stable identifier used to cite the document elsewhere;
- `title`, `type` — incident response plan or policy, playbook, severity and
  escalation criteria, on-call or delegation document, client contract or DPA,
  cyber insurance policy, DFIR retainer, asset or data inventory, network or
  identity documentation, security policy, prior after-action report, compliance
  artifact, other;
- `version_or_date` and `approval_status` — approved, draft, or unknown. A draft
  plan and an approved plan are different evidence;
- `provided_as` — attached file, file path, pasted text, or verbal summary;
- `coverage` — which profile fields this document addresses;
- `extracted_claims` — each with the profile field, the value, the location
  (section, heading, or page), and whether it was stated directly or inferred.
  A claim without a location cannot be cited in a finding;
- `not_covered` — topics the document is silent on. Frequently the most useful
  part of the entry;
- `staleness_indicators` — last-reviewed date, references to systems or people
  that intake later contradicts, or an asserted cadence;
- `conflicts` — with another source or with a user statement.

**Every extracted claim is a claim about the organization, not a verified fact
about it.** Record document-sourced facts as "the plan states X," never as "the
organization does X." A plan asserting an annual test cadence is evidence of
intent, not of testing. Flag claims the exercise can put under pressure as
`claims_to_test` for the orchestrator.

Never extract credentials, keys, connection strings, or secrets into the
register. If a document contains them, say so to the user and continue with the
rest of the document.

## 2. Organization Exercise Profile

Produced by the `tabletop-intake` sub-agent, first from the Source Register and
then from the moderator's collected answers. Consumed by `tabletop-threat-intel` and `tabletop-orchestrator`.

Required fields — the exercise cannot be designed without these:

- `industry` — sector and sub-sector, plus the customer type served;
- `tech_stack` — cloud providers, operating systems, identity provider,
  endpoint and network tooling, data stores, CI/CD, and material SaaS;
- `services` — what the organization runs and delivers, whether internal or
  customer-facing, and which are revenue- or safety-critical.

Strongly preferred fields:

- `org_size` — headcount, and separately the size of IT and security staff;
- `security_ownership` — who is accountable for security, including "nobody"
  and "an outside MSP or MSSP" as valid answers;
- `crown_jewels` — the systems and data whose loss would hurt most;
- `data_types` — PII, PHI, cardholder data, credentials, source code, or
  regulated records;
- `regulatory_scope` — user-confirmed applicable regimes and contractual
  notification obligations;
- `ir_plan_status` — none, informal, documented, or documented and tested,
  with the lifecycle vocabulary the plan uses;
- `participants` — roles attending, and which decision authorities are present
  versus absent;
- `detection_capability` — what would actually generate the first alert, and
  who watches it, including after hours;
- `backup_and_recovery` — what is backed up, whether restores are tested, and
  whether backups are isolated from production credentials;
- `third_parties` — MSP, MSSP, cloud dependencies, payment processors, key
  vendors, incident-response retainer, and cyber-insurance carrier;
- `prior_incidents` — past incidents or near-misses the organization will
  discuss;
- `exercise_objectives` — what the user wants to learn;
- `constraints` — time available, topics out of scope, and sensitivities.

Field discipline:

- mark every field `confirmed`, `assumed`, or `unknown`;
- record every field's **provenance** alongside its confidence:
  - `document:<source_id>#<location>` — extracted from a supplied document;
  - `user_stated` — the user said it in conversation;
  - `inferred` — derived by the workflow, with what it was derived from;
  - `absent` — not established by any source;
- never promote an assumption to a confirmed fact, and never upgrade
  `user_stated` to `document` without an actual document reference;
- a document-sourced field records what the document **claims**. It does not
  establish that the organization does it. Where a document claim can be put
  under pressure by the exercise, mark it `claim_to_test`;
- where a document and a user statement disagree, keep both, mark the conflict,
  and return a question resolving it. Do not silently prefer either;
- `unknown` is a legitimate terminal state. Design the exercise around it and
  let the exercise surface it.

Notification obligation basis, which is where provenance matters most:

- `contractual` — found in a supplied client agreement, MSA, or DPA, with the
  source and location recorded. Frequently tighter than any statute, and the
  obligation responders most often do not know they carry;
- `regulatory` — a regime the user has confirmed applies, cited to the statute
  or rule. **Never infer regulatory scope from a document mentioning a regime.**
  A policy referencing GDPR is not proof the organization is in scope;
- `policy` — the organization's own commitment in a supplied policy;
- `asserted` — stated only in conversation;
- `none` — no obligation established.

Severity, declaration, and escalation thresholds are recorded as `documented`
with a location, or `improvised`. A documented threshold participants cannot
recall under pressure is a different and more useful finding than no threshold
at all. Record decision authorities the same way, with their location, so the
exercise can test whether each survives contact with the scenario — particularly
where the named authority is the compromised party.

## 3. Threat Landscape Brief

Produced by the `tabletop-threat-intel` sub-agent. Consumed by
`tabletop-orchestrator` and shown to the user before scenario selection.

Contains 3–7 `incident_precedents`, each with:

- `title` and one-paragraph summary of what actually happened;
- `date` of the incident and of the reporting;
- `sector_relevance` — why this matters to this organization's industry;
- `stack_relevance` — which element of this organization's declared stack or
  service model the precedent maps onto;
- `initial_access` and `impact`, in ATT&CK terms where supportable;
- `sources` — URL, publisher, source type, retrieval date;
- `confidence` — well-documented, partially reported, or contested;
- `limitations` — what the public reporting does not establish.

Plus:

- `threat_themes` — 3–5 recurring patterns, each traceable to at least two
  precedents or to a named industry report;
- `relevant_advisories` — CISA advisories, sector ISAC bulletins, or vendor
  advisories touching the declared stack, with dates;
- `candidate_scenarios` — 3–5 one-line scenario concepts, each tied to the
  precedents and themes supporting it, and each labeled with the stack or
  service element it exercises. These are a menu from which the user selects
  **exactly one** to build the exercise around. The unselected candidates are
  suggestions for future, separate tabletops; they are never combined into one
  exercise.

Evidence discipline:

- every precedent must be a real, publicly reported incident with a retrievable
  source. Never invent an incident, a company, a date, or a CVE;
- distinguish confirmed reporting from vendor marketing and from speculation;
- if research returns thin results for a niche sector or stack, say so and fall
  back to sector-adjacent precedents, labeled as adjacent. Do not pad;
- never assert that this organization was affected by any precedent, and never
  imply the organization is currently compromised.

## 4. Exercise Package

Produced by the `tabletop-orchestrator` sub-agent. Delivered by the moderator.

**One package describes one exercise built on one scenario.** Never place two
scenarios in a package, and never run a second scenario in the same exercise. A
different scenario is a separate tabletop with its own package and its own
after-action report.

Header:

- `title`, `tier`, `scenario_summary` — one scenario, stated in a short
  paragraph;
- `inject_count` — how many injects the MSEL contains. This is how exercise
  size is expressed to the user. The package carries no duration, time
  estimate, or time budget of any kind;
- `objectives` — 3–6, each written as an observable participant behavior, each
  mapped to the standards basis, and each traceable to a precedent or theme;
- `assumptions` and `artificialities` — what participants must accept as given
  and what the exercise deliberately simplifies;
- `participant_roles` and `role_assignments`, including which roles are absent
  and must be played by the facilitator or declared unavailable;
- `ground_rules` — no-fault, plan-as-written not plan-as-intended, no live
  systems touched, and "I do not know" is a valid and useful answer;
- `safety_note` — the standing statement that this is a simulation.

`msel` — the ordered inject list.

An **inject** is one development in the scenario that the moderator delivers to
participants, after which the moderator stops and asks what they would do. The
discussion that follows is part of that inject; the moderator then delivers the
consequence and moves on. Injects are not puzzles with right answers, and the
scenario does not branch — the story advances regardless of what participants
decide.

Each inject has:

- `inject_id` and `sequence` — position in the MSEL. Sequence is the only
  pacing instrument. Do not attach wall-clock offsets or elapsed-time targets to
  an inject; the workflow does not track real time;
- `scenario_time` — in-narrative time, which may compress or jump between
  injects (for example "Tuesday 09:15" then "Wednesday 06:40"). This is story
  content delivered to participants, not a measure of the session;
- `channel` — how it arrives: alert, ticket, phone call, email, customer
  report, journalist, executive, regulator, or attacker contact;
- `content` — the text delivered verbatim to participants;
- `expected_actions` — what a prepared organization would do, at this tier;
- `facilitator_probes` — 2–4 follow-up questions, ordered from open to
  specific, used only after participants have responded on their own;
- `objectives_exercised` and `standards_mapping`;
- `escalation_triggers` — conditions under which the facilitator adds pressure;
- `decision_point` — boolean, and if true, who must decide and what authority
  the decision requires.

`evaluation_criteria` — per objective, what demonstrated, partially
demonstrated, and not demonstrated look like at this tier.

`hotwash_questions` — 5–8 questions for the immediate debrief.

`optional_injects` — spares for a group moving fast, and cut-points for a group
moving slowly. Both stay inside the one scenario and serve the same objectives;
a spare inject is never a second scenario. Never add injects beyond the tier's
count without the user agreeing to extend.

## 5. Exercise outputs — two documents

Produced by the moderator after the hotwash. Every completed exercise produces
**both**:

1. **After-Action Report** — internal, complete, with all findings, gaps in
   authority, and the improvement plan;
2. **Exercise Summary** — external, for auditors, assessors, clients, and
   insurers. Attests the exercise happened and that findings and corrective
   actions exist and are held separately, without disclosing them.

The Summary is derived from the Report. Write the Report first, have the user
correct it, then produce the Summary from the corrected Report. The two must
never disagree on a fact.

**Read `report-templates.md` for the full section-by-section structure of both
documents.** It is the authority on their contents, ordering, and formatting.

Findings discipline:

- a finding is an observation from this exercise, not a general best practice.
  If the exercise did not surface it, it belongs in "not exercised," not in
  findings;
- never record a participant's name against a negative finding. Record the role;
- do not convert a participant's uncertainty during a discussion-based exercise
  into a claim that the underlying control has failed. The exercise tests the
  response, not the control. Say which one the evidence supports;
- severity reflects consequence in a real incident, not exercise performance;
- something the exercise did not assess is an open question, not a finding.
  Regulatory applicability is the common case: record it explicitly as
  unassessed and name who should resolve it, rather than inferring a gap;
- where a participant identified a weakness themselves during the hotwash, say
  so in the finding. It is evidence the organization can see the problem.

## Persistence and action intents

The exercise, transcript, and after-action report stay in-chat until the user
explicitly approves persistence. Propose intents in plain language first, and
resolve them to a connector or file destination only after the user selects
both the intent and the destination:

- `save_after_action_report` — the internal document, complete with findings
- `save_exercise_summary` — the external evidence document. Offer both
  separately: an organization may want the summary in a shared or
  auditor-accessible location while the report stays internal. Never place the
  summary somewhere its audience can reach the report by association without
  the user intending it
- `save_exercise_package` — for reuse or for a repeat run with another group
- `create_improvement_task` — one per improvement-plan item the user selects
- `create_or_update_risk` — for findings the user wants in a risk register
- `record_ir_plan_change_request`
- `attach_exercise_evidence` — the IR-3 testing record for an audit or
  compliance program
- `notify_owner`

Do not infer an owner, approver, or recipient from a document author, connector
account, or incidental metadata. Use a user-confirmed person or role, or mark
the field missing.

Do not claim a write succeeded unless the connector confirms it. If an action
cannot execute, report it as not executed and give a manual recovery path.

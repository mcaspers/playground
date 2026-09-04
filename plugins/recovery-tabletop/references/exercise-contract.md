# Exercise contract

This contract defines the five structures the moderator and its sub-agents pass
between each other. Sub-agents return these structures; the moderator holds
them. Pass references and deltas between stages instead of repeating raw
content.

Every structure is ephemeral until the user explicitly approves persistence.

## 1. Source Register

Produced by the `recovery-intake` sub-agent from documents the organization
supplies in step one, before any questions are asked. Read `document-intake.md`
for how documents are gathered, extracted, and handled safely.

The register may legitimately be empty. A Tier 1 organization typically has no
documents, and the workflow proceeds without them.

Each entry has:

- `source_id` — a short stable identifier used to cite the document elsewhere;
- `title`, `type` — recovery plan, BIA, RTO/RPO register, runbook, architecture
  document, dependency inventory, backup policy, restore-test evidence, SLA or
  contract, prior after-action report, on-call or delegation document, other;
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

## 2. Organization Recovery Profile

Produced by the `recovery-intake` sub-agent, first from the Source Register and
then from the moderator's collected answers. Consumed by `recovery-outage-research` and `recovery-orchestrator`.

Required fields — the exercise cannot be designed without these:

- `industry` — sector and sub-sector, plus the customer type served;
- `tech_stack` — cloud providers and regions, hosting model, operating systems,
  data stores, network and DNS arrangements, identity provider, CI/CD, and
  material SaaS;
- `services` — what the organization runs and delivers, whether internal or
  customer-facing, and which are revenue- or safety-critical.

Strongly preferred fields:

- `critical_functions` — the business functions that must keep running, and
  what breaks first when they stop;
- `recovery_objectives` — stated RTO, RPO, and MTD per critical service, each
  marked `documented`, `asserted`, or `none`. Record who stated it and whether
  it was ever validated;
- `dependency_map` — upstream providers and downstream consumers, including
  dependencies the organization does not control;
- `backup_posture` — what is backed up, how often, where it lives, whether it
  is isolated from production credentials and network, and when a restore was
  last actually performed;
- `recovery_architecture` — standby, replica, multi-region, alternate site, or
  none, and whether failover has ever been exercised;
- `org_size` — headcount, and separately the size of the infrastructure and
  operations function;
- `recovery_ownership` — who is accountable for recovery, including "nobody"
  and "an outside MSP or provider" as valid answers;
- `declaration_authority` — who can declare a disaster and invoke the plan;
- `dr_plan_status` — none, informal, documented, or documented and tested, with
  the phase vocabulary the plan uses;
- `detection_capability` — what would actually reveal an outage first, who
  watches it, and whether that holds after hours;
- `availability_commitments` — user-confirmed SLAs, service credits, status-page
  commitments, and regulatory reporting obligations;
- `participants` — roles attending, and which decision authorities are present
  versus absent;
- `third_parties` — cloud providers, MSP, key vendors, colocation, ISPs,
  insurers, and support contracts with their response tiers;
- `prior_outages` — past outages or near-misses the organization will discuss;
- `exercise_objectives` — what the user wants to learn;
- `constraints` — topics out of scope and sensitivities.

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

Recovery objective basis, which is where provenance matters most:

- `documented` — found in a supplied plan, BIA, or service-tier register, with
  the source and location recorded;
- `contractual` — found in a customer contract or SLA. Outranks an internal
  objective where the two conflict; record both and flag the conflict;
- `asserted` — stated only in conversation. An engineer's confident estimate is
  not an organizational objective;
- `none` — no figure exists.

Validation is a separate fact from the figure. A documented four-hour RTO with
no restore-test evidence remains unvalidated, and a document does not change
that. Record the absence of validation evidence explicitly.

## 3. Outage Precedent Brief

Produced by the `recovery-outage-research` sub-agent. Consumed by
`recovery-orchestrator` and shown to the user before scenario selection.

Contains 3–7 `outage_precedents`, each with:

- `title` and one-paragraph summary of what actually happened;
- `date` of the outage and of the reporting or postmortem;
- `trigger` — the initiating cause, and the failure mode that made it severe;
- `duration_and_impact` — how long, how widely, and what broke downstream;
- `sector_relevance` — why this matters to this organization's industry;
- `stack_relevance` — which element of this organization's declared stack,
  architecture, or dependency set the precedent maps onto;
- `recovery_difficulty` — what made restoration hard, which is the part a
  tabletop can actually exercise;
- `sources` — URL, publisher, source type, retrieval date;
- `confidence` — official postmortem, credible reporting, or partial;
- `limitations` — what the public account does not establish.

Plus:

- `failure_themes` — 3–5 recurring patterns, each traceable to at least two
  precedents or to a named industry source;
- `provider_advisories` — published postmortems, status-page histories, or
  provider guidance touching the declared stack, with dates;
- `candidate_scenarios` — 3–5 one-line scenario concepts, each tied to the
  precedents and themes supporting it, and each labeled with the stack or
  dependency element it exercises. These are a menu from which the user selects
  **exactly one** to build the exercise around. The unselected candidates are
  suggestions for future, separate tabletops; they are never combined into one
  exercise.

Evidence discipline:

- every precedent must be a real, publicly reported outage with a retrievable
  source. Never invent an outage, a provider, a date, or a duration;
- prefer official provider postmortems, which are unusually detailed for this
  domain, over secondhand reporting;
- distinguish confirmed postmortem detail from speculation and from
  status-page language written during the event;
- if research returns thin results for a niche stack, say so and fall back to
  architecture-adjacent precedents, labeled as adjacent. Do not pad;
- never assert that this organization was affected by any precedent, and never
  imply the organization is currently experiencing an outage.

## 4. Exercise Package

Produced by the `recovery-orchestrator` sub-agent. Delivered by the moderator.

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
- `recovery_objectives_under_test` — the stated RTO, RPO, or MTD the scenario
  will put under pressure, and what the scenario does to stress each;
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
- `scenario_time` — in-narrative elapsed outage time, which is central to this
  exercise type ("you are ninety minutes in," "this is now hour six, and past
  your stated RTO"). This is story content delivered to participants, never a
  measure of the session;
- `channel` — how it arrives: monitoring alert, support ticket, customer email,
  vendor status page, provider support, executive, regulator, or journalist;
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
   authority, the recovery objectives assessment, and the improvement plan;
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
  into a claim that a recovery capability has failed. The exercise tests the
  response, not the capability. A tabletop cannot establish that a restore
  works or that a failover succeeds — only that the team could or could not
  describe how it would proceed. Say which one the evidence supports;
- severity reflects consequence in a real outage, not exercise performance;
- something the exercise did not assess is an open question, not a finding.
  Regulatory and contractual applicability is the common case: record it
  explicitly as unassessed and name who should resolve it;
- where a participant identified a weakness themselves during the hotwash, say
  so in the finding. It is evidence the organization can see the problem.

## Persistence and action intents

The exercise, transcript, and both documents stay in-chat until the user
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
- `record_dr_plan_change_request`
- `record_recovery_objective_revision` — where the exercise showed a stated RTO,
  RPO, or MTD to be unachievable and the organization wants it revisited
- `attach_exercise_evidence` — the CP-4 testing record for an audit or
  compliance program
- `notify_owner`

Do not infer an owner, approver, or recipient from a document author, connector
account, or incidental metadata. Use a user-confirmed person or role, or mark
the field missing.

Do not claim a write succeeded unless the connector confirms it. If an action
cannot execute, report it as not executed and give a manual recovery path.

# Incident Tabletop

The `incident-tabletop` plugin runs an incident response tabletop exercise in
Claude Code. Claude acts as the **moderator**: it collects the organization's
profile, researches real incidents in the organization's sector and technology
stack, designs a scenario with an inject sequence, facilitates the discussion
inject by inject, runs the hotwash, and writes an after-action report.

The exercise is a discussion-based simulation. No live system is touched, no
real message is sent, and nothing is saved until the user approves it.

## Scope

- **NIST SP 800-84** is the exercise-design authority: scope, objectives, the
  Master Scenario Events List, conduct, and after-action analysis.
- **NIST SP 800-61 Rev. 3** (CSF 2.0-aligned) supplies the incident response
  content, with Rev. 2 phases and the SANS PICERL model used when the
  organization's own plan uses them.
- **CISA CTEP** provides the situation-manual and inject structure; **MITRE
  ATT&CK** keeps adversary behavior realistic; **OWASP** covers application and
  API scenarios; **SP 800-53 IR-3** is the control the exercise evidences.
- Every scenario is grounded in real, publicly reported incident precedents with
  retrievable sources — or explicitly labeled as pattern-based when research is
  thin or declined.

## Maturity tiers

Every tabletop is **one exercise built on one scenario**, run start to finish.
The tier changes how deeply that single scenario is developed — how many injects
it carries and how precisely it is evaluated — never how many scenarios you get.
Testing a second scenario is a second tabletop.

The user picks the tier. It is a scope choice, not a score.

| Tier | For | Injects |
|---|---|---|
| **1 — Basic** | No dedicated security staff, no formal plan, first exercise | 3–5 |
| **2 — Standard** | A plan, defined roles, small security or security-responsible IT function | 8–12 |
| **3 — Advanced** | Dedicated security function, tested plan, regulatory clocks | 15–25 |

**Tier 1** asks a short set of questions about the organization, researches
incidents that have hit similar organizations, then runs one straightforward
incident that unfolds in a few steps — described in plain terms, with no
jargon — and closes with a conversation about what was learned and a short
report.

**Tier 2** adds a fuller intake, distinct participant roles, and a complication
partway through that changes the picture. It covers detection through recovery
including notification obligations, and produces a full report.

**Tier 3** develops one incident through several interleaved complications,
including a false lead, information contradicting what was established earlier,
and pressure from outside the organization. Executives and external parties are
role-played. It produces a detailed report and a gap register.

### What an inject is

An inject is one development in the scenario that the moderator hands to
participants — a monitoring alert, a helpdesk call, a customer email, a message
from the attacker, a journalist's question — after which the moderator stops and
asks what they would do. The discussion that follows is part of the inject.

Injects are not puzzles with right answers and the scenario does not branch. The
story advances regardless of what participants decide; what they decide is what
the exercise measures.

**Inject count is how exercise size is expressed.** The plugin gives no duration
estimates: how long a tabletop takes depends entirely on the group and how much
discussion each inject provokes. It also does not track elapsed time, announce a
halfway point, or ask how long anything took — it paces by injects remaining,
which it can actually know. The intake, research, and design stages need no
participants present and can be done ahead of the session.

Tier 1 keeps participant-facing language plain — no ATT&CK IDs, no control
numbers — and asks the questions that matter to a small organization: who gets
called, who can authorize taking something offline, and whether anyone has ever
restored from a backup. A Tier 1 exercise that ends with "we have nobody to
call" has succeeded; that is the finding.

## Inputs

### Documents first

Intake **starts by asking for documentation**, before any questions. Supply an
incident response plan or policy, playbooks, severity and escalation criteria,
on-call and delegation documents, client contracts with breach-notification
terms, a cyber insurance policy, a DFIR retainer, asset or data inventories,
security policies, or a prior after-action report — any subset helps.

The intake sub-agent extracts what it can into a Source Register, populates the
profile from it, and then asks **only what the documents did not answer**. Where
a document gives an answer needing verification, you get a confirmation question
rather than an open one. Nobody is asked to type out what their own plan already
says.

Having no documents is normal, especially at Tier 1, and never blocks the
exercise.

Three consequences worth knowing:

- **A document is a claim, not a verified fact.** A plan asserting an annual
  test cadence is evidence of intent, not of testing. Document assertions are
  carried forward as `claims_to_test` and become some of the best inject
  material available — the exercise finds out what the organization would
  actually do, and the gap against the plan is the most productive finding type
  this plugin produces.
- **Findings can cite plan sections.** "Acme Incident Response Plan v1.0,
  Section 3.2" is more actionable than a control reference, because it names the
  paragraph to go and change.
- **A document never settles regulatory scope.** A policy referencing GDPR is
  not proof the organization is in scope. Applicability is always confirmed with
  the user.

Contractual notification terms are the highest-value extraction here — they are
frequently tighter than any statute and are the obligation responders least
often know they carry.

Documents stay yours: cited by title, version, and section, never reproduced,
never persisted without approval, and client-confidential ones are title-only
and excluded by name from the external summary. Credentials are never extracted
— if a document contains secrets, you are told so you can handle it.

### Then questions

At minimum the workflow needs **industry**, **tech stack**, and **services**.
Everything else improves the exercise but never blocks it — "we do not know" is
a valid answer that becomes an exercise finding rather than a gap to fill.

More context produces a sharper exercise: security ownership, IR plan status,
crown jewels, data types, regulatory and contractual scope, detection
capability, backup and recovery posture, third parties, participants, prior
incidents, and objectives.

The plugin never asks for credentials, tokens, hostnames, addresses, or system
access.

## Architecture

The primary agent is the moderator, implemented as the `incident-tabletop`
skill. It coordinates three bespoke sub-agents:

- **`tabletop-intake`** — extracts supplied documents into a Source Register,
  normalizes answers into the Organization Exercise Profile, and prepares the
  prioritized questions the documents left unanswered;
- **`tabletop-threat-intel`** — researches real incidents across three axes
  (industry, tech stack, service model) and returns a sourced Threat Landscape
  Brief with candidate scenarios;
- **`tabletop-orchestrator`** — designs the Exercise Package: objectives, ground
  rules, the MSEL with facilitator probes, evaluation criteria, and hotwash
  questions.

Sub-agents cannot talk to the user, so the moderator asks every question and
delivers every inject. Intake prepares and normalizes; the orchestrator designs;
the moderator facilitates. The structures passed between them are defined in
`references/exercise-contract.md`.

## Safety

- The scenario is fictional and is labeled as such throughout.
- No inject instructs anyone to touch, isolate, shut down, or restore a live
  system, and the package contains no command intended for execution.
- Injects are delivered only in-chat. No real person is contacted.
- If a real incident surfaces, the exercise stops.
- Real third parties are not cast as the breached party unless the user chooses
  that framing; precedents are cited in facilitator notes, not as accusations
  inside the narrative.
- Scenarios describe consequences and response decisions, not exploitation
  steps.
- Findings record roles, never individuals.

## Claude Code usage

Install the marketplace locally, then install the plugin:

```text
/plugin marketplace add mcaspers/playground
```

```text
/plugin install incident-tabletop@playground
```

Run it with:

```text
/incident-tabletop:incident-tabletop
```

## Outputs

Every completed exercise produces **two documents**.

**After-Action Report** — internal. Scenario summary, objectives with their
basis, assumptions carried in unverified, what worked, findings with severities
and their plan/control/contractual basis, gaps in decision authority, what was
*not* exercised, a prioritized improvement plan with owners and target dates,
the recommended next exercise, and the participant hotwash in their own words.

**Exercise Summary** — external, for auditors, assessors, clients, and insurers.
An evidence artifact rather than a condensed report: it records that the
exercise took place, its methodology, scope, participation, and control
relevance, and confirms that findings and corrective actions were captured and
are available on request. It contains no findings, severities, gaps, or
improvement items, and it states that applicability is the assessor's call, not
the organization's.

The Summary is derived from the Report, so the two can't disagree. Both are
drafted in chat for correction and stay there until the user approves
persistence and chooses destinations — asked separately, since the Summary often
belongs somewhere the Report does not.

The Summary is the artifact to hand an assessor as evidence for SP 800-53 IR-3
incident response testing.

## License

MIT — see [LICENSE](LICENSE). Use, modify, and redistribute it as you see fit;
keep the copyright and permission notice in copies or substantial portions.

### Third-party references

The plugin cites public standards and frameworks; it does not reproduce them.
Anyone extending it who pastes source text in should check the terms attached to
that source:

- **NIST** SP 800-84, SP 800-61, SP 800-53, SP 800-161, and CSF 2.0, and **CISA**
  CTEP materials, are US Government works and are not subject to domestic
  copyright protection.
- **MITRE ATT&CK** is © MITRE, made freely available under the ATT&CK Terms of
  Use, which require attribution.
- **OWASP** Top 10 and API Security Top 10 are published under Creative Commons
  Attribution-ShareAlike.
- **SANS** courseware is proprietary. This plugin references the PICERL
  six-step model as a concept and reproduces no SANS material.

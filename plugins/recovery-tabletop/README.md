# Recovery Tabletop

The `recovery-tabletop` plugin runs a disaster recovery and service outage
tabletop exercise in Claude Code. Claude acts as the **moderator**: it collects
the organization's recovery profile, researches real outages and published
provider postmortems for its platforms and sector, designs a scenario with an
inject sequence, facilitates the discussion inject by inject, runs the hotwash,
and writes an after-action report and an assessor-facing exercise summary.

It is the companion to `incident-tabletop`. Same machinery, different subject:
that one exercises incident response and evidences SP 800-53 IR-3; this one
exercises contingency planning and evidences **CP-4**.

The exercise is a discussion-based simulation. No live system is touched, no
failover or restore is triggered, no real message or status-page update is sent,
and nothing is saved until the user approves it.

## Scope

- **NIST SP 800-84** is the exercise-design authority: scope, objectives, the
  Master Scenario Events List, conduct, and after-action analysis.
- **NIST SP 800-34 Rev. 1** supplies the recovery content — business impact
  analysis, recovery strategies, and the Activation/Notification, Recovery, and
  Reconstitution phases that form the spine of the exercise.
- **ISO 22301:2019** and **ISO/TS 22317:2021** for organizations running a
  formal BCMS or needing a defensible basis for their recovery objectives.
- **NIST SP 800-53 Rev. 5 CP family** for control traceability, with **CP-4**
  the control the exercise evidences; **CSF 2.0** RC.RP, RC.CO, ID.AM, and ID.BE
  for outcome framing.
- Every scenario is grounded in real, publicly reported outages with retrievable
  sources — provider postmortems first — or explicitly labeled as pattern-based
  when research is thin or declined.

## Maturity tiers

Every tabletop is **one exercise built on one scenario**, run start to finish.
The tier changes how deeply that scenario is developed, never how many scenarios
you get.

| Tier | For | Injects |
|---|---|---|
| **1 — Basic** | No dedicated infrastructure staff, no documented plan, first exercise | 3–5 |
| **2 — Standard** | A documented plan, defined roles, stated recovery objectives | 8–12 |
| **3 — Advanced** | Dedicated resilience function, tested plan, regulatory availability obligations | 15–25 |

**Tier 1** asks what the organization runs and depends on, researches outages
that have hit similar organizations, then runs one straightforward outage in
plain language — no RTO/RPO jargon unless defined in the moment. It asks who
notices, who decides it is serious, where the backups are, whether anyone has
ever restored from them, and what customers get told.

**Tier 2** adds distinct roles, stated recovery objectives under pressure, and a
complication partway through. It covers detection through reconstitution
including customer commitments.

**Tier 3** develops one outage through interleaved complications including a
failed or partial recovery, an unmapped dependency, and external pressure.
Executives and external parties are role-played.

### What an inject is

An inject is one development in the scenario that the moderator hands to
participants — a monitoring alert, a customer complaint, a failed restore, a
vendor status update, an executive asking when service returns — after which the
moderator stops and asks what they would do. The discussion that follows is part
of the inject.

Injects are not puzzles with right answers and the scenario does not branch.

**Inject count is how exercise size is expressed.** The plugin gives no duration
estimates and does not track elapsed session time. It paces by injects
remaining. In-narrative outage time is different and is used heavily — "you are
now at hour six, past your stated RTO" is scenario content and often the most
valuable moment in the exercise.

## Inputs

### Documents first

Intake **starts by asking for documentation**, before any questions. Supply a
recovery or continuity plan, a business impact analysis, an RTO/RPO table,
runbooks, architecture or dependency documentation, backup policy, restore-test
evidence, customer SLAs, or a prior after-action report — any subset helps.

The intake sub-agent extracts what it can into a Source Register, populates the
profile from it, and then asks **only what the documents did not answer**. Where
a document gives an answer needing verification, you get a confirmation question
rather than an open one. Nobody is asked to type out what their own plan already
says.

Having no documents is normal, especially at Tier 1, and never blocks the
exercise.

Two consequences worth knowing:

- **A document is a claim, not a verified fact.** A plan asserting an annual
  test cadence is evidence of intent, not of testing. Document assertions are
  carried forward as `claims_to_test` and become some of the best inject
  material available — the exercise finds out what the organization would
  actually do, and the gap against the plan is the most productive finding type
  this plugin produces.
- **Findings can cite plan sections.** "Acme Recovery Plan v2.1, Section 4.2" is
  more actionable than a control reference, because it names the paragraph to go
  and change.

Documents stay yours: cited by title, version, and section, never reproduced,
never persisted without approval. Credentials are never extracted — if a
document contains secrets, you are told so you can handle it.

### Then questions

At minimum the workflow needs **industry**, **tech stack**, and **services**.
Everything else improves the exercise but never blocks it — "we have never
tested a restore" is a valid answer that becomes a finding.

Two questions change the exercise more than any others: what breaks first when
the main system stops, and whether anyone has ever actually restored from a
backup.

Recovery objectives are recorded with their basis — `documented` (with source
document and section), `contractual`, `asserted`, or `none` — and separately
whether they have ever been validated. A contractual commitment outranks an
internal objective where the two conflict, and both are shown. The plugin never
invents an RTO or RPO, and never lets an engineer's estimate become an
organizational objective. Where none exist, that absence is the finding.

The plugin never asks for credentials or system access, and never asks the user
to run a restore or failover to answer a question.

## Architecture

The primary agent is the moderator, implemented as the `recovery-tabletop`
skill. It coordinates three sub-agents:

- **`recovery-intake`** — extracts supplied documents into a Source Register,
  normalizes answers into the Organization Recovery Profile, and prepares the
  prioritized questions the documents left unanswered;
- **`recovery-outage-research`** — researches real outages across platform,
  industry, and service model, weighted toward *recovery difficulty* rather than
  spectacle, and returns a sourced Outage Precedent Brief;
- **`recovery-orchestrator`** — designs the Exercise Package: objectives,
  recovery objectives under test, the MSEL with facilitator probes, evaluation
  criteria, and hotwash questions.

Sub-agents cannot talk to the user, so the moderator asks every question and
delivers every inject.

## Relationship to incident-tabletop

The two plugins are complementary and deliberately do not overlap.

| | `incident-tabletop` | `recovery-tabletop` |
|---|---|---|
| Subject | Security incident response | Outage and disaster recovery |
| Content authority | SP 800-61r3 | SP 800-34r1, ISO 22301 |
| Control evidenced | SP 800-53 IR-3 | SP 800-53 CP-4 |
| Signature finding | Undefined decision authority | Stated objectives never validated |

A ransomware scenario legitimately appears in both. Here it stays focused on
restoration — backup integrity, sequencing, data loss, validation, failback. If
an exercise turns substantially toward containment, evidence preservation, or
breach notification, the moderator records it as a finding and recommends an
incident response tabletop rather than silently converting the exercise.

Running both produces a consistent evidence set: matching report structures,
different control mappings.

## Safety

- The scenario is fictional and is labeled as such throughout.
- No inject instructs anyone to touch, fail over, restore, restart, or shut down
  a live system. This is enforced harder than in the security plugin, because
  recovery actions look routine and are easy to run by reflex.
- Injects are delivered only in-chat. No real message, ticket, customer
  communication, or status-page update is sent. Drafted communications stay in
  chat as exercise artifacts.
- If a real outage surfaces, the exercise stops.
- Real vendors are not cast as the failed party unless the user chooses that
  framing; published postmortems are cited in facilitator notes.
- Findings record roles, never individuals.

## Claude Code usage

Install the marketplace locally, then install the plugin:

```text
/plugin marketplace add mcaspers/playground
```

```text
/plugin install recovery-tabletop@playground
```

Run it with:

```text
/recovery-tabletop:recovery-tabletop
```

## Outputs

Every completed exercise produces **two documents**.

**After-Action Report** — internal. Scenario summary, objectives with basis,
assumptions, a **recovery objectives assessment** comparing stated RTO/RPO
against what the exercise suggested, what worked, findings with severities, gaps
in decision authority, dependencies surfaced, what was *not* exercised, a
prioritized improvement plan, the recommended next exercise, and the participant
hotwash in their own words.

**Exercise Summary** — external, for auditors, assessors, clients, and insurers.
An evidence artifact: it records that the exercise took place, its methodology,
scope, participation, and control relevance, and confirms findings and
corrective actions exist and are available on request. It contains no findings,
and it states plainly that a discussion-based exercise does not evidence
technical recovery testing such as restore verification or failover drills.

Both are drafted in chat for correction and stay there until the user approves
persistence and chooses destinations — asked separately.

## License

MIT — see [LICENSE](LICENSE). Use, modify, and redistribute it as you see fit;
keep the copyright and permission notice in copies or substantial portions.

### Third-party references

The plugin cites public standards; it does not reproduce them. NIST SP 800-84,
SP 800-34 Rev. 1, SP 800-53 Rev. 5, and CSF 2.0 are US Government works and are
not subject to domestic copyright protection. **ISO 22301 and ISO/TS 22317 are
copyrighted standards sold by ISO and national bodies** — this plugin cites
clause numbers and titles only, and anyone extending it must not paste in ISO
text. Provider postmortems cited during research remain the property of their
publishers and are referenced by link.

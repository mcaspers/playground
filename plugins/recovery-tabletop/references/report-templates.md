# Report templates

Every completed exercise produces **two documents**. Both are drafted in chat
for the user to correct, and neither is persisted until the user approves
persistence and chooses a destination.

| Document | Audience | Contains findings? |
|---|---|---|
| **After-Action Report** | Internal — the organization's management and responders | Yes, in full |
| **Exercise Summary** | External — auditors, assessors, clients, insurers | No. Attests they exist and are held separately |

The Exercise Summary is **derived from** the After-Action Report. Write the
report first, have the user correct it, and only then produce the summary. The
two must never disagree on a fact. Never write the summary independently, and
never let it assert something the report does not support.

These templates mirror the `incident-tabletop` plugin's structure so an
organization running both exercises produces a consistent evidence set. The
differences are deliberate: the control evidenced is CP-4 rather than IR-3, the
plan tested is the recovery or continuity plan, and the report carries a
recovery objectives assessment that has no incident response equivalent.

## Shared discipline

These rules govern both documents.

- **Roles, not names, in findings.** Participants are named once, in the header
  roster. Every finding, gap, and observation refers to a role.
- **Severity reflects consequence in a real outage, not exercise performance.**
  State this explicitly in the report's findings preamble.
- **The exercise tested the response process, not recovery capability.** A
  tabletop cannot establish that a restore works, that a failover succeeds, or
  that an RTO is achievable. It establishes what the team could and could not
  describe. Both documents carry a closing disclaimer saying so, and confirming
  that no live system was accessed, modified, failed over, or restored and no
  communication was issued to any external party.
- **Unassessed is not the same as absent.** Where something was not evaluated —
  contractual and regulatory applicability being the common case — record it as
  an open question, explicitly not a finding, and say who should resolve it.
- **No session timing.** Do not report how long the exercise or any part of it
  took. In-narrative outage time appears throughout findings, because it is the
  substance of this exercise type ("recovery was still not underway at hour
  four of the scenario"). Elapsed real time of the session is never recorded.
- **Assumptions stay labeled.** Anything carried into the exercise unverified is
  listed as an assumption in the report and never restated elsewhere as fact.
- **Proposed owners require confirmation.** Never infer an owner. Mark proposed
  owners as requiring management confirmation.

## Document 1 — After-Action Report

Title: **Disaster Recovery Tabletop Exercise — After-Action Report**

### Header metadata table

Two columns, Field and Detail:

- Organization
- Exercise title — the scenario's name, in quotes, followed by a plain-language
  descriptor
- Date conducted
- Exercise type — discussion-based tabletop, tier, inject count, and participant
  count
- Methodology basis — NIST SP 800-84, with its full title
- Recovery framework basis — NIST SP 800-34 Rev. 1, and ISO 22301:2019 where the
  organization runs a BCMS
- Scenario basis — the date range of the outage reporting the scenario drew on,
  and what it was matched to (industry, architecture, dependencies)
- Plan tested — the organization's recovery or continuity plan and version, with
  its approval status. Record "none supplied" where the organization has no plan
- Documents reviewed — count and types supplied at intake, or "none supplied"
- Participant — names and contact, listed once here only
- Not present — roles absent and how they were handled
- Facilitator note — who facilitated, and whether the design, MSEL, and probes
  were withheld from participants during conduct
- Control mapping — NIST SP 800-53 Rev. 5, CP-4

### 1. Scenario summary

One or two paragraphs of what happened in the scenario, written as narrative
fact in past tense, including the trigger, the failure mode, the services
affected, the in-narrative duration, and the business impact. Close with a
sentence stating the exercise ran one scenario across N injects followed by a
facilitated hotwash.

### 2. Exercise objectives

Table with columns `#`, Objective, Basis. Each objective is written as the
decision or capability it tested. Basis cites the organization's own plan where
one exists, plus the SP 800-34 phase and the SP 800-53 CP control.

Follow the table with any scope note — most commonly a note recording that
contractual or regulatory applicability was not assessed and remains an open
question rather than a finding.

### 3. Assumptions

Bulleted. The conditions carried into the exercise as stated and not verified.
Open with a line saying exactly that. Recovery exercises accumulate more
assumptions than security exercises — backup currency, replica health, standby
capacity, vendor response times — so this section carries real weight.

Mark each assumption's source: extracted from a named document, stated by a
participant, or carried in by the exercise design. An assumption taken from a
supplied plan is still an assumption — the plan asserts it, the exercise did not
verify it — and saying so plainly is what keeps the report honest.

### 4. Recovery objectives assessment

**This section has no incident response equivalent and is the analytical core of
a recovery after-action report.**

Table with columns Service or function, Stated RTO, Stated RPO, Basis of the
stated figure, and What the exercise suggested. The basis column records whether
each figure was **documented** (naming the source document and section),
**contractual** (naming the agreement), **asserted** by a participant, or
**absent**. Add a validation column where the organization supplied restore-test
evidence, or record its absence explicitly — a documented objective with no
evidence of testing is unvalidated, and the document does not change that.

Where an internal objective and a contractual commitment conflict, show both
rows and flag the conflict. An organization promising customers a tighter figure
than it holds itself to internally is a finding in its own right.

Follow the table with a short narrative on divergence. Be precise about what a
tabletop can and cannot establish: it can show that a team could not describe a
path to meeting an objective, that a dependency makes an objective implausible,
or that no one knew what the objective was. It cannot demonstrate that an
objective is unachievable in practice. State which of these the evidence
supports.

Where an organization has no stated objectives, say so plainly and record it as
a finding rather than inventing figures.

### 5. What worked

Bulleted, each a short bold-led claim followed by the specific observation that
supports it. Note where a correct action was taken unprompted.

This section is not padding. If the exercise surfaced few strengths, list few.

### 6. Findings

Open with the severity and no-fault preamble.

Each finding: **F-n — short title** followed by **(Severity)**, then one to
three sentences of observation and why it matters, then an italic
***Basis:*** line citing the organization's plan, the SP 800-34 phase, the
SP 800-53 CP control, the contract, or the organizational commitment it is
assessed against.

Where a supplied document supports the finding, **cite it by title and section**
in the basis line — "Acme Recovery Plan v2.1, Section 4.2" is far more actionable
than a generic control reference, because it tells the reader exactly which
paragraph to go and change.

The most valuable finding type this report produces is a **divergence between
the plan as written and the response as described**. State both sides: what the
document says, and what the exercise revealed. Do not present the document's
claim as the organization's practice, and do not present a participant's
description as proof the document is wrong — say which the evidence supports.

Order by severity, High first. Use High, Medium, Low.

Where a participant identified a gap themselves during the hotwash, say so.

### 7. Gaps in authority

Kept separate because undefined decision authority is the most common tabletop
finding and typically the least expensive to fix. In recovery exercises the
recurring gaps are who may declare a disaster, who may authorize a failover,
who may accept data loss, and who may tell customers. Retain this section even
when empty.

Table with columns Decision, What the plan says, What occurred in the exercise.
"Silent" is the correct entry when the plan does not address a decision.

Close with a structural observation naming the pattern the table reveals.

### 8. Dependencies surfaced

Recovery exercises reliably discover dependencies the organization had not
mapped. Record them: the dependency, how it surfaced, whether the organization
controls it, and whether it affects a stated recovery objective.

Omit this section only if the exercise genuinely surfaced none.

### 9. Documents reviewed

Where documents were supplied at intake, list them: title, version or date,
approval status, and what each contributed to the exercise. Note any that were
found stale, internally inconsistent, or contradicted by participants.

Cite documents by title, version, and section. **Do not reproduce their
contents.** Where a document is client-confidential or covered by an NDA, cite
the title only.

Omit this section where no documents were supplied. Do not record the absence as
a finding here — if it matters, it belongs in the findings section as a plan gap.

### 10. Not exercised

Bulleted, prefaced by a line stating these are recorded so they are not mistaken
for areas the exercise validated. Include explicitly that no restore, failover,
or recovery procedure was technically tested — a discussion-based exercise
cannot do that, and the distinction matters to an assessor.

Where the exercise touched security response but did not pursue it, record that
here and point to an incident response tabletop.

### 11. Improvement plan

Table with columns `#`, Item, Type, Owner, Target, Effort. IDs are I-n. Type is
**Plan**, **Authority**, **Tooling/Architecture**, or **Validation** — the last
covering restore tests, failover drills, and BIA work the tabletop showed to be
overdue. Order by priority.

Precede the table with a note on what effort estimates assume and that proposed
owners require management confirmation.

Cross-reference findings where an item resolves one.

### 12. Recommended next exercise

A short paragraph naming the scenario class for the next tabletop and the
finding or gap that motivates it. Where the exercise repeatedly brushed against
security response, recommend an incident response tabletop explicitly.

### 13. Participant hotwash — in the participant's words

Prefaced with a line stating it is recorded substantially as stated, ahead of
facilitator interpretation. Bulleted, each led by the topic in italics: the
greatest uncertainty, the missing information, what should change first.

Preserve the participant's own phrasing.

### Closing disclaimer

Italic. States the report follows NIST SP 800-84, records the outcome of a
discussion-based exercise, does not constitute an assessment of recovery
capability or control effectiveness, and that no live system was accessed,
modified, failed over, or restored.

## Document 2 — Exercise Summary

Title: **Disaster Recovery Exercise Summary**, with a subtitle line naming the
organization and its purpose.

This is an **evidence artifact**, not a condensed report. Its job is to let an
auditor, assessor, client, or insurer confirm that contingency plan testing
occurred, with enough specificity to be credible and without exposing the
organization's unremediated weaknesses.

Do not include findings, severities, gaps in authority, the recovery objectives
assessment, dependencies surfaced, or the improvement plan. Do not sanitize the
exercise into sounding clean either — the summary states plainly that findings
were recorded and corrective actions assigned, and that both are available on
request.

### Purpose

One paragraph: this summary records that the organization conducted the
exercise, describes its nature, scope, and participation, and is intended as
evidence that contingency plan testing was performed. State that detailed
observations and the corrective action plan are maintained separately and
available on request.

### Exercise record

Two-column table, Field and Detail:

- Organization
- Date conducted
- Exercise type
- Methodology — NIST SP 800-84 with full title
- Recovery framework — NIST SP 800-34 Rev. 1, and ISO 22301:2019 where relevant
- Plan tested — the recovery or continuity plan and version, with approval
  status, or "none supplied"
- Documents reviewed — count and types supplied at intake, by category only.
  Never name a client-confidential document in an externally shared summary
- Scenario class — the disruption type in general terms, not narrative details
- Scenario derivation — the reporting period the scenario drew on and what it
  was selected for relevance to
- Structure — inject count and that a structured hotwash followed
- Participants
- Roles simulated
- Facilitation — whether design, MSEL, and probes were withheld from
  participants until conduct was complete
- Systems affected — **None**, with the full statement that the exercise was
  discussion-based, that no system was accessed, modified, failed over,
  restored, or tested, and no communication was issued to any external party

### Scope and objectives

The objective areas as bullets, phrased as capabilities tested. No outcomes.

### Conduct and outcome

Attests that the exercise was conducted in full: injects delivered and responded
to, proceeding to hotwash without early termination. Then states that
observations were captured and documented in a full after-action report, that
findings were recorded against the response process rather than individuals,
that each observation carries a severity reflecting potential consequence in an
actual outage, and that corrective actions have owners and target dates spanning
plan, authority, tooling/architecture, and validation work.

Where the exercise reviewed stated recovery objectives, say that it did, without
disclosing the assessment.

If the exercise ended early or an objective was not reached, say so here. Never
claim completion that did not occur.

### Control relevance

Preface: the exercise is offered as evidence of contingency plan testing, and
**applicability and sufficiency are determined by the assessor, not by the
organization**. That sentence is required.

Table with columns Reference and Control objective. Typically SP 800-53 CP-4 and
CP-2, ISO 22301 clause 8.5 where the organization runs a BCMS, and the
organization's own plan's testing clause.

Add a scope note: this exercise is discussion-based and does not evidence
technical recovery testing such as restore verification or failover drills.
Assessors frequently require both, and overstating this artifact is the fastest
way to lose credibility with one.

### Documentation available on request

Bulleted: the full after-action report, the exercise package, and the
organization's recovery or continuity plan.

### Closing disclaimer

Italic. States the document summarizes the conduct of a discussion-based
exercise, does not constitute an assessment of recovery capability or control
effectiveness, does not assert that any recovery procedure was tested, and that
no live system was accessed, altered, failed over, or restored.

## Formatting

Both documents are professional deliverables, not transcripts or Markdown dumps.
Use real headings, readable tables, bold sparingly for finding titles and field
labels, and italics for basis lines and disclaimers.

When a document is created in Google Workspace, Confluence, or another
human-facing destination, apply the professional-document requirements: native
heading styles, consistent typography, readable tables, restrained color, and
working source links. After creation, read the document back and verify sections,
tables, and values before reporting success. If the destination cannot produce
and verify a professionally formatted artifact, say so and propose an
alternative rather than claiming completion.

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

## Shared discipline

These rules govern both documents.

- **Roles, not names, in findings.** Participants are named once, in the header
  roster. Every finding, gap, and observation refers to a role — "the
  responder," "the vCISO," "the CTO" — never to a named individual.
- **Severity reflects consequence in a real incident, not exercise
  performance.** State this explicitly in the report's findings preamble.
- **The exercise tested the response process, not control effectiveness.** Both
  documents carry a closing disclaimer saying so, and confirming that no live
  system was accessed, modified, or tested and no communication was issued to
  any external party.
- **Unassessed is not the same as absent.** Where something was not evaluated —
  regulatory applicability being the common case — record it as an open
  question, explicitly not a finding, and say who should resolve it.
- **No session timing.** Do not report how long the exercise or any part of it
  took. In-narrative scenario time may appear in findings where the story
  carried it ("the CTO was in transit; containment stalled until the following
  morning"), because that is scenario content. Elapsed real time of the session
  is never recorded.
- **Assumptions stay labeled.** Anything carried into the exercise unverified is
  listed as an assumption in the report and never restated elsewhere as fact.
- **Proposed owners require confirmation.** Never infer an owner. Mark proposed
  owners as requiring management confirmation.

## Document 1 — After-Action Report

Title: **Incident Response Tabletop Exercise — After-Action Report**

### Header metadata table

Two columns, Field and Detail:

- Organization
- Exercise title — the scenario's name, in quotes, followed by a plain-language
  descriptor (for example: *"Nothing Looked Wrong" — Google Workspace account
  takeover to business email compromise*)
- Date conducted
- Exercise type — discussion-based tabletop, tier, inject count, and participant
  count (for example: *Discussion-based tabletop exercise, Tier 1 (4 injects),
  single participant*)
- Methodology basis — NIST SP 800-84, with its full title
- Scenario basis — the date range of the incident reporting the scenario drew
  on, and what it was matched to (industry, service model, technology stack)
- Plan tested — the organization's incident response plan and version, with its
  approval status. Record "none supplied" where the organization has no plan
- Documents reviewed — count and types supplied at intake, or "none supplied"
- Participant — names and contact, listed once here only
- Not present — roles absent and how they were handled
- Facilitator note — who facilitated, and whether the design, MSEL, and probes
  were withheld from the participant during conduct
- Control mapping — NIST SP 800-53 Rev. 5, IR-3

### 1. Scenario summary

One or two paragraphs of what happened in the scenario, written as narrative
fact in past tense, including the initial access, the mechanism, the business
impact with figures, and the escalation. Close with a sentence stating the
exercise ran one scenario across N injects followed by a facilitated hotwash.

### 2. Exercise objectives

Table with columns `#`, Objective, Basis. Each objective is written as the
decision or capability it tested, not as a topic. Basis cites the
organization's own plan where one exists, plus the SP 800-53 control.

Follow the table with any scope note — most commonly a note on regulatory
applicability recording it as an open question rather than a finding.

### 3. Assumptions

Bulleted. The conditions carried into the exercise as stated and not verified.
Open with a line saying exactly that.

Mark each assumption's source: extracted from a named document, stated by a
participant, or carried in by the exercise design. An assumption taken from a
supplied plan is still an assumption — the plan asserts it, the exercise did not
verify it — and saying so plainly is what keeps the report honest.

### 4. What worked

Bulleted, each a short bold-led claim followed by the specific observation that
supports it. Note where a correct action was taken unprompted. Be concrete: name
what the participant actually did and the reasoning they gave.

This section is not padding. If the exercise surfaced few strengths, list few.

### 5. Findings

Open with the severity and no-fault preamble.

Each finding: **F-n — short title** followed by **(Severity)**, then one to
three sentences of observation and why it matters, then an italic
***Basis:*** line citing the organization's plan, the SP 800-53 control, the
contract, or the organizational commitment it is assessed against.

Where a supplied document supports the finding, **cite it by title and section**
in the basis line — "Acme Incident Response Plan v1.0, Section 3.2" is far more
actionable than a generic control reference, because it tells the reader exactly
which paragraph to go and change.

The most valuable finding type this report produces is a **divergence between
the plan as written and the response as described**. State both sides: what the
document says, and what the exercise revealed. Do not present the document's
claim as the organization's practice, and do not present a participant's
description as proof the document is wrong — say which the evidence supports.

Order by severity, High first. Use High, Medium, Low.

Where a participant identified a gap themselves during the hotwash, say so —
it belongs in the finding.

### 6. Gaps in authority

Kept separate because undefined decision authority is the most common tabletop
finding and typically the least expensive to fix. Open with a sentence saying
that. Retain this section even when empty.

Table with columns Decision, What the plan says, What occurred in the exercise.
"Silent" is the correct entry when the plan does not address a decision.

Close with a structural observation naming the pattern the table reveals.

### 7. Documents reviewed

Where documents were supplied at intake, list them: title, version or date,
approval status, and what each contributed to the exercise. Note any that were
found stale, internally inconsistent, or contradicted by participants.

Cite documents by title, version, and section. **Do not reproduce their
contents.** Where a document is client-confidential or covered by an NDA — client
contracts and insurance policies being the common cases — cite the title only.

Omit this section where no documents were supplied. Do not record the absence as
a finding here; if it matters, it belongs in the findings section as a plan gap.

### 8. Not exercised

Bulleted, prefaced by a line stating these are recorded so they are not mistaken
for areas the exercise validated. This is what keeps the report honest about its
own scope.

### 9. Improvement plan

Table with columns `#`, Item, Type, Owner, Target, Effort. IDs are I-n. Type is
**Plan**, **Authority**, or **Tooling**. Order by priority.

Precede the table with a note on what effort estimates assume and that proposed
owners require management confirmation.

Cross-reference findings where an item resolves one.

### 10. Recommended next exercise

A short paragraph naming the scenario class for the next tabletop and the
finding or gap that motivates it — typically something this exercise touched
but could not test properly.

### 11. Participant hotwash — in the participant's words

Prefaced with a line stating it is recorded substantially as stated, ahead of
facilitator interpretation. Bulleted, each led by the topic in italics: the
greatest uncertainty, the missing information, what should change first.

Preserve the participant's own phrasing. Do not tidy it into report register.

### Closing disclaimer

Italic. States the report follows NIST SP 800-84, records the outcome of a
discussion-based exercise, does not constitute an assessment of control
effectiveness, and that no live system was accessed, modified, or tested.

## Document 2 — Exercise Summary

Title: **Incident Response Exercise Summary**, with a subtitle line naming the
organization and its purpose (for example: *Surton, Inc. | Prepared for external
assessment purposes*).

This is an **evidence artifact**, not a condensed report. Its job is to let an
auditor, assessor, client, or insurer confirm that incident response testing
occurred, with enough specificity to be credible and without exposing the
organization's unremediated weaknesses. Detailed findings stay in the
After-Action Report.

Do not include findings, severities, gaps in authority, the improvement plan, or
the hotwash. Do not sanitize the exercise into sounding clean either — the
summary states plainly that findings were recorded and corrective actions
assigned, and that both are available on request.

### Purpose

One paragraph: this summary records that the organization conducted the
exercise, describes its nature, scope, and participation, and is intended as
evidence that testing was performed. State that detailed observations and the
corrective action plan are maintained separately and available on request.

### Exercise record

Two-column table, Field and Detail:

- Organization
- Date conducted
- Exercise type
- Methodology — NIST SP 800-84 with full title
- Plan tested — the organization's IR plan and version, where one exists
- Documents reviewed — count and types supplied at intake, by category only.
  Never name a client-confidential document in an externally shared summary
- Scenario class — the incident type in general terms, not the scenario's
  narrative details
- Scenario derivation — the reporting period the scenario drew on and what it
  was selected for relevance to
- Structure — inject count and that a structured hotwash followed
- Participants
- Roles simulated
- Facilitation — whether design, MSEL, and probes were withheld from
  participants until conduct was complete
- Systems affected — **None**, with the full statement that the exercise was
  discussion-based, no system was accessed, modified, isolated, or tested, and
  no communication was issued to any external party

### Scope and objectives

The objective areas as bullets, phrased as capabilities tested. No outcomes.

### Conduct and outcome

Attests that the exercise was conducted in full: injects delivered and responded
to, proceeding to hotwash without early termination. Then states that
observations were captured and documented in a full after-action report, that
findings were recorded against the response process rather than individuals,
that each observation carries a severity reflecting potential consequence in an
actual incident, and that corrective actions have owners and target dates
spanning plan, authority, and tooling changes.

If the exercise ended early or an objective was not reached, say so here. Never
claim completion that did not occur.

### Control relevance

Preface: the exercise is offered as evidence of incident response testing, and
**applicability and sufficiency are determined by the assessor, not by the
organization**. That sentence is required.

Table with columns Reference and Control objective. Typically SP 800-53 IR-3 and
IR-8, plus the organization's own plan's periodic-evaluation clause.

### Documentation available on request

Bulleted: the full after-action report, the exercise package, and the
organization's incident response plan.

### Closing disclaimer

Italic. States the document summarizes the conduct of a discussion-based
exercise, does not constitute an assessment of control design or operating
effectiveness, does not assert that any control was tested for effectiveness,
and that no live system was accessed or altered.

## Formatting

Both documents are professional deliverables, not transcripts or Markdown dumps.
Use real headings, readable two- and multi-column tables, bold sparingly for
finding titles and field labels, and italics for basis lines and disclaimers.

When a document is created in Google Workspace, Confluence, or another
human-facing destination, apply the professional-document requirements: native
heading styles, consistent typography, readable tables, restrained color, and
working source links. After creation, read the document back and verify sections,
tables, and values before reporting success. If the destination cannot produce
and verify a professionally formatted artifact, say so and propose an
alternative rather than claiming completion.

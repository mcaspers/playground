# Maturity tiers

The tier sets exercise depth, inject count, vocabulary, and what the
after-action report asks the organization to do next. The user selects the tier.
Never raise the tier because the workflow judges the organization unprepared,
and never lower it because the organization looks small.

A tier is a scope choice, not a score. Do not describe a Tier 1 organization as
immature or non-compliant in participant-facing material.

## One exercise, one scenario

Every tabletop this plugin runs is **one exercise built around exactly one
scenario**. The tier changes how deeply that single scenario is developed — how
many injects it carries, how many complications unfold within it, and how
precisely it is evaluated. The tier never adds a second scenario.

Where a tier lists multiple "threads," those are interleaved developments inside
the one scenario — a recovery attempt that reinfects, a dependency that fails
alongside the primary event — not alternate or parallel scenarios.

If the user wants to test a different scenario family, that is a separate
tabletop, run separately, with its own package and its own after-action report.
Offer it as a next exercise; never fold it into the current one.

## What an inject is

An **inject** is a single development in the scenario that the moderator
delivers to participants, after which the moderator stops and asks what they
would do. It might be a monitoring alert, a helpdesk call, an email from a
customer, a message from the attacker, a question from a journalist, or an
executive demanding an update.

The discussion that follows a delivered event is part of that inject. When the
discussion has run its course, the moderator delivers the consequence and moves
to the next inject.

Injects are not puzzles with right answers, and the scenario does not branch.
The story advances to the next inject regardless of what participants decide —
what they decide is what the exercise is measuring.

**Inject count is how exercise size is expressed.** Use it in place of a
duration whenever the user needs to know how big an exercise is. Do not state,
estimate, or track how long an exercise will take or has taken: how long a group
spends on an inject varies enormously by group, and the workflow cannot observe
elapsed time in any case.

Do not track elapsed time during the exercise. Do not announce a halfway point,
ask the user what time it is, or claim to know how long anything has taken.
Pace by injects remaining in the MSEL, which is knowable, rather than by a
clock, which is not.

If the user asks how long a tier takes, say plainly that it depends on the group
and how much discussion each inject provokes, give them the inject count, and
tell them the preparation stages need no participants present and can be done
ahead of the session.

## Tier 1 — Basic

For organizations with no dedicated security staff, no formal incident response
plan, or no prior exercise experience. The goal is a first useful rehearsal, not
an assessment.

- what it entails: a short set of intake questions about the organization,
  brief research into incidents that have hit similar organizations, then one
  straightforward incident that unfolds in a few steps. Each step is described
  in plain terms, the participants say what they would do, and the story moves
  on. It closes with a conversation about what was learned and a short written
  report;
- **injects: 3–5**;
- participants: 1–5, often one person wearing every role;
- scenario: one, single-threaded, with no complicating second development;
- vocabulary: plain language. No ATT&CK IDs, no CSF Function codes, and no
  control identifiers in participant-facing text. Keep those in facilitator
  notes and in the traceability appendix of the after-action report;
- decision focus: who is called first, who can authorize taking a system
  offline, where the backups are and whether anyone has restored from them,
  what gets said to customers, and which outside party (insurer, MSP, counsel,
  law enforcement) is contacted;
- evaluation: observations and a short prioritized action list. Do not score;
- after-action report: two to three pages, with the first five things to fix
  and a suggested date for the next exercise.

A Tier 1 exercise that ends with "we do not have anyone to call" has succeeded.
Record it as a finding, not a failure.

## Tier 2 — Standard

For organizations with an incident response plan, some defined roles, and
either a small security team or a security-responsible IT function.

- what it entails: a fuller intake covering the environment, obligations, and
  who attends; researched incident precedents for the sector and stack; then one
  incident that develops a complication partway through and changes the picture.
  Participants hold distinct roles and are pressed on who decides what. It
  covers detection through recovery, including notification obligations, and
  closes with a structured debrief and a full report;
- **injects: 8–12**;
- participants: 5–12 across IT, security, engineering, leadership, legal or
  privacy, and communications;
- scenario: one, with a single complicating development that unfolds partway
  through;
- vocabulary: ATT&CK technique names and IDs are appropriate. Use the incident
  lifecycle the organization's own plan uses;
- decision focus: detection and triage, severity classification against the
  organization's own criteria, escalation and incident-commander designation,
  containment authority and business trade-offs, evidence preservation,
  regulatory and contractual notification clocks, customer and internal
  communications, and recovery validation;
- evaluation: performance against stated exercise objectives, with each
  objective marked demonstrated, partially demonstrated, not demonstrated, or
  not exercised;
- after-action report: full structure with findings mapped to SP 800-61
  Functions or phases and to SP 800-53 IR controls, an improvement plan with
  owners and target dates, and plan-document change requests.

## Tier 3 — Advanced

For organizations with a dedicated security function, a tested plan, and
regulatory or contractual obligations that carry defined clocks.

- what it entails: deep intake covering environment, obligations, authorities,
  and attendees; thorough precedent research; then one incident developed
  through several interleaved complications, including a false lead, information
  that contradicts what was established earlier, and pressure arriving from
  outside the organization. Executives and external parties are role-played.
  It closes with a full debrief, a detailed report, and a gap register. The
  exercise may be split across two sittings — still one exercise and one
  scenario, resuming the same MSEL where it stopped;
- **injects: 15–25**, including at least one contradictory or false-lead inject,
  one compressed decision, and one inject that arrives from outside the
  organization (a journalist, a customer, a regulator, or the attacker);
- participants: 10–25, including executive decision-makers and external-party
  role-players (counsel, insurer, forensics retainer, key customer);
- scenario: one, developed through 2–3 interleaved threads. These are
  complications within the single scenario — a recovery attempt that reinfects,
  a supply-chain dependency that fails alongside the primary event — never
  separate scenarios;
- vocabulary: full technical and regulatory precision. ATT&CK-mapped adversary
  behavior, CSF 2.0 Function and Category references, SP 800-53 IR control
  citations, and named notification regimes with real deadlines;
- decision focus: everything in Tier 2, plus materiality determination and
  disclosure judgment, legal privilege handling, ransom and extortion decision
  authority, law-enforcement engagement, cyber-insurance notice conditions,
  parallel-workstream coordination, and executive/board communication;
- evaluation: objective-by-objective, plus an explicit list of decisions the
  organization could not make because authority was undefined, and for each
  significant decision whether it was reached directly, required escalation, or
  needed facilitator probing to surface;
- after-action report: full structure plus a control-traceability appendix, a
  gap register suitable for import into a risk register, and recommendations
  separated into plan changes, tooling changes, and authority/delegation
  changes.

## Selecting a tier

Ask the user directly. Show what each tier entails and its inject count beside
each option, and explain what an inject is before or alongside the question so
the count means something to someone who has never run a tabletop. Do not
attach a time estimate to any option. Offer a recommendation based on what
intake found — presence of an incident response plan, dedicated security staff,
and regulatory scope are the strongest signals — but the user's choice governs.

If the user picks a tier that the workflow judges mismatched, run the tier they
chose and note the mismatch once, in facilitator notes, before the exercise
begins. Do not re-raise it during conduct.

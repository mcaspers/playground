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
the one scenario — a restore that completes but with corrupted data, a
dependency that fails while recovery is underway — not alternate or parallel
scenarios.

If the user wants to test a different scenario family, that is a separate
tabletop, run separately, with its own package and its own after-action report.
Offer it as a next exercise; never fold it into the current one.

## What an inject is

An **inject** is a single development in the scenario that the moderator
delivers to participants, after which the moderator stops and asks what they
would do. It might be a monitoring alert, a customer complaint, a failed restore,
a vendor status page update, an executive asking when service returns, or a
report that the failover site is also degraded.

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

Recovery scenarios are full of *in-narrative* time — "the restore is four hours
in," "you are now past your stated RTO." That is scenario content and is
essential to this exercise type. It is not a measure of the session, and the two
must never be confused.

## Tier 1 — Basic

For organizations with no dedicated infrastructure or continuity staff, no
documented recovery plan, or no prior exercise experience. The goal is a first
useful rehearsal, not an assessment.

- what it entails: a short set of intake questions about what the organization
  runs and depends on, brief research into outages that have hit similar
  organizations or the same platforms, then one straightforward outage that
  unfolds in a few steps. Each step is described in plain terms, the
  participants say what they would do, and the story moves on. It closes with a
  conversation about what was learned and a short written report;
- **injects: 3–5**;
- participants: 1–5, often one person wearing every role;
- scenario: one, single-threaded, with no complicating second development;
- vocabulary: plain language. Do not use RTO, RPO, MTD, or control identifiers
  in participant-facing text without defining them in the moment, and keep
  control mappings in facilitator notes and the traceability appendix. Ask "how
  long could you be down before this really hurts" rather than "what is your
  MTD";
- decision focus: who notices something is wrong and how, who decides this is
  serious, where the backups are and whether anyone has ever restored from
  them, how long the organization can operate without the system, what gets
  said to customers and who says it, and which vendor or provider gets called;
- evaluation: observations and a short prioritized action list. Do not score;
- after-action report: two to three pages, with the first five things to fix
  and a suggested date for the next exercise.

A Tier 1 exercise that ends with "we have never actually tried restoring that"
has succeeded. Record it as a finding, not a failure.

## Tier 2 — Standard

For organizations with a documented recovery or continuity plan, some defined
roles, and stated recovery objectives — whether or not those objectives have
ever been validated.

- what it entails: a fuller intake covering the environment, dependencies,
  stated recovery objectives, and who attends; researched outage precedents for
  the platforms and service model; then one outage that develops a complication
  partway through and changes the recovery picture. Participants hold distinct
  roles and are pressed on declaration authority and recovery sequencing. It
  covers detection through reconstitution, including customer commitments, and
  closes with a structured debrief and a full report;
- **injects: 8–12**;
- participants: 5–12 across infrastructure, engineering, support, leadership,
  and communications;
- scenario: one, with a single complicating development that unfolds partway
  through;
- vocabulary: RTO, RPO, MTD, and WRT are appropriate and should be used
  precisely. Use the recovery phase vocabulary the organization's own plan uses;
- decision focus: detection and declaration, who has authority to declare a
  disaster and invoke the plan, recovery sequencing and which services come
  back first, failover decisions and their reversibility, acceptable data loss,
  degraded-mode and manual workarounds, customer and internal communication
  cadence, SLA and contractual exposure, restore validation, and the decision
  that service is genuinely restored;
- evaluation: performance against stated exercise objectives, with each
  objective marked demonstrated, partially demonstrated, not demonstrated, or
  not exercised, plus an explicit comparison of stated recovery objectives
  against what the exercise suggested was achievable;
- after-action report: full structure with findings mapped to SP 800-34 phases
  and SP 800-53 CP controls, an improvement plan with owners and target dates,
  and plan-document change requests.

## Tier 3 — Advanced

For organizations with dedicated infrastructure or resilience functions, a
tested plan, validated recovery objectives, and regulatory or contractual
availability obligations.

- what it entails: deep intake covering environment, dependency topology,
  validated objectives, authorities, and attendees; thorough precedent research
  including published provider postmortems; then one outage developed through
  several interleaved complications, including a recovery attempt that fails or
  makes things worse, a dependency nobody had mapped, and pressure arriving from
  outside the organization. Executives and external parties are role-played. It
  closes with a full debrief, a detailed report, and a gap register;
- **injects: 15–25**, including at least one failed or partial recovery, one
  cascading dependency failure, one inject that arrives from outside the
  organization (a customer, a regulator, a journalist, or the provider), and one
  decision made on incomplete information under commercial pressure;
- participants: 10–25, including executive decision-makers and external-party
  role-players (cloud provider support, key vendor, major customer, insurer);
- scenario: one, developed through 2–3 interleaved threads. These are
  complications within the single scenario — a restore that completes with data
  divergence, a failback that risks a second outage — never separate scenarios;
- vocabulary: full technical and regulatory precision. SP 800-34 phase
  references, SP 800-53 CP control citations, ISO 22301 clauses where the
  organization runs a BCMS, and named availability commitments with real
  thresholds;
- decision focus: everything in Tier 2, plus prioritization across competing
  services with finite recovery capacity, partial recovery and data divergence,
  failback risk and timing, regulatory reporting judgments, executive and board
  communication, insurer notification, and the authority to accept permanent
  data loss;
- evaluation: objective-by-objective, plus an explicit list of decisions the
  organization could not make because authority was undefined, an assessment of
  stated versus demonstrated recovery objectives, and for each significant
  decision whether it was reached directly, required escalation, or needed
  facilitator probing to surface;
- after-action report: full structure plus a control-traceability appendix, a
  gap register suitable for import into a risk register, and recommendations
  separated into plan changes, tooling and architecture changes, and
  authority/delegation changes.

## Selecting a tier

Ask the user directly. Show what each tier entails and its inject count beside
each option, and explain what an inject is before or alongside the question so
the count means something to someone who has never run a tabletop. Do not
attach a time estimate to any option. Offer a recommendation based on what
intake found — presence of a documented recovery plan, stated recovery
objectives, and whether restores have ever been tested are the strongest
signals — but the user's choice governs.

If the user picks a tier that the workflow judges mismatched, run the tier they
chose and note the mismatch once, in facilitator notes, before the exercise
begins. Do not re-raise it during conduct.

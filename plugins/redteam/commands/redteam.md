---
description: Run the repeatable multi-agent black-box adversarial test of any authorized target — interactive scoping intake, recon, discovery, MITRE/NIST plan, approval gate, gated execution, report.
argument-hint: "[dry|live] — dry (default) plans and describes; live executes approved probes"
require-confirmation: no
disable-model-invocation: true
---

You are the **lead** of an authorized Red Team engagement ("red team") against a
target the operator declares and authorizes. This is defensive security testing of
a system the operator owns or is authorized to test. Drive the engagement through
the phases below, delegating to the sub-agents. **Never** let live offensive probes
run without the explicit human approval gate in Phase 5, and **never** proceed past
intake until the authorized scope is attested.

The requested mode is: **$ARGUMENTS** (treat empty as `dry`).

Plugin assets are under `${CLAUDE_PLUGIN_ROOT}`:
- Scripts: `${CLAUDE_PLUGIN_ROOT}/scripts/` (new-engagement, scope-check, run-probes, approve-plan, teardown).
- Reference: `${CLAUDE_PLUGIN_ROOT}/reference/` (target-kinds, catalogs, MITRE map, NIST map, RoE + report templates).
- Sub-agents: `redteam-intake`, `redteam-recon`, `redteam-inspector`, `redteam-planner`, `redteam-operator`, `redteam-adjudicator`.

## Set up the engagement
Create the engagement dir under the Red Team home, never in the working tree:
`ENG="$(bash "${CLAUDE_PLUGIN_ROOT}/scripts/new-engagement.sh")"`. This creates
`~/.redteam/engagements/<key>/<UTC-timestamp>/` (owner-only, `0700`), keyed by
workspace. Call it `$ENG`; all state lives here, so `git status` stays clean.

## Phase 0 — Scoping intake (HUMAN, MANDATORY — the gate for everything)
Spawn **`redteam-intake`** with `$ENG`. It interviews the operator to establish
*what* is being tested, *where they sit*, and *what they are authorized to touch*,
then derives the target definition and writes `$ENG/roe.md` and `$ENG/scope.json`.
**Do not proceed** until `scope.json` exists with `authorization_attested: true`.
If authorization is not attested, stop and tell the operator the engagement is
blocked until a human attests it. The plugin has no default target — it only tests
what intake authorized.

## Phase 1 — Recon
Spawn **`redteam-recon`** (2–3 in parallel over different surfaces for breadth if
useful). Give each `$ENG`, the reference dir, and the in-scope targets. It produces
an attack-surface map of hypotheses grounded in the target's catalog. Save to
`$ENG/recon.md`.

## Phase 2 — Confirm the target is in scope
For each target, confirm reachability and scope with
`bash ${CLAUDE_PLUGIN_ROOT}/scripts/scope-check.sh --engagement "$ENG" --target "<host-or-url>"`.
Nothing here should contact anything the scope guard refuses.

## Phase 3 — Discovery
Spawn **`redteam-inspector`** with `$ENG`. It runs **read-only**, scope-guarded
discovery and returns observed facts keyed to the target's catalog. Save to
`$ENG/inspection.md`.

## Phase 4 — Plan
Spawn **`redteam-planner`** with `$ENG`, `recon.md`, `inspection.md`, and the
reference dir. It writes `$ENG/plan.md`: SP 800-53A-shaped objectives drawn from
the target's catalog, each mapped to ATT&CK + NIST and scaled by the impact
baseline, with a clearly separated **"Requires live approval"** section. Present
the plan to the operator.

## Phase 5 — Approval gate (HUMAN, MANDATORY for live)
- If mode is `dry`: skip live approval; go to Phase 6 in dry mode.
- If mode is `live`: show the operator exactly which probes would fire, against
  which in-scope targets, and what each does. **You may not write the approval
  token yourself.** The human must run, in their own terminal:
  `bash ${CLAUDE_PLUGIN_ROOT}/scripts/approve-plan.sh --engagement "$ENG" --confirm "I APPROVE LIVE PROBES"`
  Do not proceed to live execution until `$ENG/APPROVAL` exists. (The PreToolUse
  hook and `run-probes.sh` both refuse live probes without it — do not work around
  them.)

## Phase 6 — Execute (gated)
Spawn **`redteam-operator`** with `$ENG` and the mode. It runs each planned probe
through `${CLAUDE_PLUGIN_ROOT}/scripts/run-probes.sh` (scope-guarded, dry describes
/ live gated), writing `$ENG/results.jsonl` and raw evidence under `$ENG/evidence/`.

## Phase 7 — Adjudicate & report
Spawn **`redteam-adjudicator`** with `$ENG`. It verifies candidate findings, scores
severity, and writes `$ENG/report.md` per the report template with ATT&CK + NIST
800-53A coverage tables. Then run
`bash ${CLAUDE_PLUGIN_ROOT}/scripts/teardown.sh --engagement "$ENG"` to invalidate
the approval token and record close-out.

## Close-out
Summarize for the operator: headline verdict, counts (passed / findings by severity
/ informational), and the path to `$ENG/report.md`. Remind them the engagement is
repeatable: re-invoke `/redteam:redteam` after a change to regression-test.

### Non-negotiables
- Target only what `scope.json` authorizes. Every target contact is scope-guarded;
  never touch a host, network, or service outside the attested scope.
- No run before intake attests authorization. The plugin has no built-in target.
- The human approval gate for live probes is mandatory and must not be bypassed.
- Never exfiltrate or persist a real credential; never include one in the report.

---
name: engagement
description: The repeatable methodology for a black-box adversarial test of any authorized target — NIST SP 800-115 phases, an interactive scoping intake, MITRE ATT&CK + NIST SP 800-53/53A mapping, standards-grounded test catalogs, and the dry-run-default / scope-gated / human-approved safety model. Use to run or understand a Red Team engagement.
disable-model-invocation: false
tags:
  - security
  - penetration-testing
  - red-team
require-confirmation: no
---

# Red Team engagement — methodology

This skill is the **method**; the `/redteam:redteam` command is the **driver** that
automates it with sub-agents. Read this to run an engagement by hand, to understand
what the command does, or to extend it. Nothing here is tied to a specific product,
vendor, or technology — the **target is whatever the operator declares and
authorizes at intake**.

## The target and the adversary
The **target** is any system the operator is authorized to test — a network, a
host, a web application, a cloud tenant, a device, or a bespoke system. The
**adversary** is whatever the target's threat model implies (an external attacker,
an authenticated user, an insider). Both are established in Phase 0; the plugin
holds no built-in target.

## Why "black box"
Recon builds *hypotheses* from whatever is knowable (source if authorized, docs,
passive signal); every claim is settled by **observable behaviour** against the
authorized target under the scope guard. Information informs the plan; the running
system decides the verdict.

## Phases (NIST SP 800-115)
| Phase | 800-115 | What happens | Artifact |
|---|---|---|---|
| 0 | Planning | **Interactive intake**: scope, authorization, and the derived target definition | `roe.md`, `scope.json` |
| 1 | Planning | Recon → attack-surface map (source/OSINT as available) | `recon.md` |
| 2 | Discovery | Confirm the authorized target is reachable / in scope | (notes) |
| 3 | Discovery | Read-only discovery of the target (scope-guarded) | `inspection.md` |
| 4 | Attack (plan) | Catalog-driven, ATT&CK + NIST-mapped plan | `plan.md` |
| 5 | Attack (gate) | **Human** approval for live probes | `APPROVAL` |
| 6 | Attack (exec) | Run probes through the guarded executor (dry default / gated live) | `results.jsonl`, `evidence/` |
| 7 | Reporting | Adjudicate, score, report; close out | `report.md` |

## The safety model (read this before live)
- **Scope is the spine.** Phase 0 writes `scope.json` — the authorized targets and
  their `in_scope_patterns`, plus `out_of_scope` carve-outs. **Nothing runs** until
  `scope.json` exists and its `authorization_attested` is `true`. Every target
  contact is checked with `roe_assert_in_scope`; there is no hard-coded "safe"
  target — a local test is simply a scope whose patterns include `localhost`.
- **Dry-run is the default.** Dry probes only *describe* what they would do.
- **Two independent barriers gate live execution.** `run-probes.sh` refuses live
  mode without a valid `<eng>/APPROVAL`; a PreToolUse **hook** redundantly denies
  it. The approval is bound to the **scope fingerprint**, so widening scope after
  approval invalidates it.
- **Only a human writes APPROVAL**, via `approve-plan.sh` with the exact phrase
  `I APPROVE LIVE PROBES`. The agent cannot self-authorize.
- **Authorization is attested, never inferred.** For any target the operator does
  not own, intake records an explicit authorization attestation. No attestation →
  no run.

## Target kinds & catalogs (grounded, not invented)
`target_kind` is an **open, RoE-declared** string the intake derives — never a
frozen enum. Each carries a **grounding** citation to a maintained, offense-oriented
reference (a MITRE ATT&CK platform/domain, or an OSSTMM channel for physical/human
planes), or an explicit `first-party` marker. The **test catalog** is a separate,
extensible layer:

| Catalog (`reference/catalogs/`) | Backing standard |
|---|---|
| `web-url` | OWASP WSTG v4.2 (tests) + ASVS v5.0.0 (oracle) |
| `host-network` | NIST SP 800-115 §3–5 + platform-specific CIS Benchmark |
| `isolation-boundary` | generic container/sandbox isolation (built on 800-115 + ATT&CK + 800-53) |
| *(author your own)* | `reference/catalogs/authoring-a-catalog.md` |

See `reference/target-kinds.md` for the model and `reference/target-classification-research.md`
/ `reference/profiles-research.md` for the sourced rationale.

## Mapping (for the report / an assessor)
- **MITRE ATT&CK** — `reference/mitre-attack-mapping.md`. Keep `(analogy)` marks.
- **NIST SP 800-53 Rev 5** controls, written as **SP 800-53A** assessment
  objectives (EXAMINE / TEST) with a satisfied / other-than-satisfied determination
  — `reference/nist-references.md`. Breadth scales by the target's `impact_baseline`
  (SP 800-53B Low/Moderate/High).

## Running it by hand (no command)
```bash
P="$CLAUDE_PLUGIN_ROOT"
ENG="$(bash "$P/scripts/new-engagement.sh")"   # ~/.redteam/engagements/<key>/<UTC>/ (0700), never in-tree
# Phase 0: interview the operator; write $ENG/roe.md and $ENG/scope.json
#          (use redteam-intake, or fill reference/roe-template.md by hand)
# Phase 1: write $ENG/recon.md   (redteam-recon)
bash "$P/scripts/scope-check.sh" --engagement "$ENG" --target "<host-or-url>"   # Phase 2: confirm in scope
# Phase 3: read-only discovery (redteam-inspector) -> $ENG/inspection.md
# Phase 4: write $ENG/plan.md    (redteam-planner)
bash "$P/scripts/run-probes.sh" --engagement "$ENG" --id T1 --target "<t>" --mode dry -- <cmd>   # Phase 6 dry
# Phase 5 (human): to go live —
#   bash "$P/scripts/approve-plan.sh" --engagement "$ENG" --confirm "I APPROVE LIVE PROBES"
bash "$P/scripts/run-probes.sh" --engagement "$ENG" --id T1 --target "<t>" --mode live -- <cmd>  # Phase 6 live (gated)
# Phase 7: adjudicate -> $ENG/report.md, then
bash "$P/scripts/teardown.sh" --engagement "$ENG"
```

## Repeatability
An engagement is a regression test for the target's controls. Re-run after any
change to the target and diff `report.md` against the previous engagement to catch
a regression the moment it lands.

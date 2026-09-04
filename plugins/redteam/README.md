# redteam

A repeatable, multi-agent, **black-box adversarial testing** plugin for **any
authorized target** — a network, host, virtual server, web app, cloud tenant, or
bespoke system. It is target-agnostic: nothing about a specific product or
technology is baked in. An interactive **intake** derives the target and its
authorized scope from a conversation with the operator; the engagement then follows
NIST SP 800-115, maps to MITRE ATT&CK + NIST SP 800-53/53A, draws tests from
standards-grounded catalogs (OWASP WSTG/ASVS, CIS, NIST 800-115, OSSTMM), and — on
explicit human approval — executes them against the target the operator authorized.
**Dry-run by default; live probes are gated behind scope enforcement and a
human-written approval token.**

## Install (via the Playground marketplace)
```
/plugin marketplace add mcaspers/playground
/plugin install redteam@playground
```
Then run the engagement:
```
/redteam:redteam          # dry-run: intake, recon, discovery, plan (no live probes)
/redteam:redteam live     # same, but offer the human live-approval gate at Phase 5
```

## What it does (NIST SP 800-115)
0. **Intake** — `redteam-intake` interviews the operator, derives each target's
   `target_kind` + `grounding` + `test_catalog`, and writes `scope.json` + `roe.md`.
   **Nothing runs until scope is declared and authorization is attested.**
1. **Recon** — `redteam-recon` builds an attack-surface map (source/OSINT as available).
2. **Confirm scope** — `scope-check.sh` verifies each target is in the authorized scope.
3. **Discovery** — `redteam-inspector` runs read-only, scope-guarded enumeration.
4. **Plan** — `redteam-planner` → `plan.md`, each test mapped to ATT&CK + NIST 800-53A.
5. **Approve** — a **human** writes the approval token; the agent cannot self-authorize.
6. **Execute** — `redteam-operator` runs probes via the guarded executor (dry / gated live).
7. **Report** — `redteam-adjudicator` verifies findings, scores, writes `report.md`; close out.

## Safety model
- **Scope is the spine.** `scope.json` lists the authorized targets and their
  `in_scope_patterns`; every target contact is checked (`roe_assert_in_scope`).
  There is no hard-coded target — a local test is just a scope whose patterns
  include `localhost`.
- **Authorization is attested, never inferred.** No `authorization_attested: true`
  → nothing runs.
- **Dry-run is the default** and always allowed.
- **Two independent barriers** gate live probes: `run-probes.sh` and a PreToolUse
  hook both refuse live mode without a valid `APPROVAL`, and the token is **bound to
  the scope fingerprint** — widening scope invalidates it.
- Probes never exfiltrate or persist a real credential.

## Layout
```
commands/redteam.md                 the /redteam:redteam orchestrator
agents/redteam-*.md                 intake · recon · inspector · planner · operator · adjudicator
skills/engagement/SKILL.md          the repeatable methodology (also standalone)
reference/target-kinds.md           the open, grounded target-kind model
reference/catalogs/                 web-url · host-network · isolation-boundary · authoring-a-catalog
reference/mitre-attack-mapping.md   ATT&CK cross-map
reference/nist-references.md        SP 800-115 / 800-53 / 800-53A / 800-53B
reference/*-research.md             sourced rationale for the taxonomy decisions
reference/roe-template.md           RoE + report templates
hooks/hooks.json + scripts/guard    the live-execution safety gate
scripts/                            new-engagement · scope-check · run-probes · approve-plan · teardown
scripts/tests/                      the scope-guard / approval-gate test
```

Engagement state is written under the Red Team home, never inside the working tree:
`~/.redteam/engagements/<key>/<UTC-timestamp>/` (owner-only `0700`, keyed by
workspace) holds `roe.md`, `scope.json`, `recon.md`, `inspection.md`, `plan.md`,
`APPROVAL`, `results.jsonl`, `evidence/`, `report.md`. Retention is manual by design
— engagement evidence is audit material and nothing auto-prunes it.

> **Authorized testing only.** Run this only against systems you own or are
> explicitly authorized to test. The intake records that authorization; the scope
> guard confines every probe to it. Point it at a target you are not authorized to
> test and you are on your own — the tooling refuses out-of-scope targets, but it
> cannot vouch for your authorization.

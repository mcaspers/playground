# Catalog: `isolation-boundary` — container / sandbox / VM isolation

For a `target_kind` that is an **isolation boundary**: a container, sandbox, microVM,
or any confinement meant to keep a workload from reaching the host, the network, or
secrets it should not. This catalog is **generic** — it names the *classes* of
control an isolation boundary tends to claim, not any specific product's
implementation. When you test a concrete system, treat this as `first-party`
grounding and specialize it to that system's actual claims (see
[`authoring-a-catalog.md`](authoring-a-catalog.md)).

**Backing.** Built on NIST SP 800-115 (method), MITRE ATT&CK (mapping), and NIST SP
800-53 (SC-7 boundary protection, AC-4 information-flow, AC-6 least privilege, SC-39
process isolation, IA-5 authenticators, AU-9 audit protection, SI-4 monitoring,
SC-24 fail-in-known-state). NIST SP 800-190 (Application Container Security) and SP
800-207 (Zero Trust) are useful context. There is no single public *offensive*
catalog for isolation boundaries, which is why this is grounded first-party.

> Scope discipline: the boundary under test must be the operator's own, declared in
> `scope.json` (typically a local target whose in_scope_patterns include
> `localhost`). Escape attempts are intrusive — live only under approval.

## Control classes (specialize per system)

| Item | Control class | Attacker objective | Probe idea | Expected-secure |
|---|---|---|---|---|
| I-EGRESS | Network egress control | reach a non-allowlisted host without record | attempt direct TCP/UDP/DNS off the confined segment, bypassing the mandated path | no route off except the mandated one; refusals recorded |
| I-MOUNT | Filesystem isolation | read/write host paths outside the workspace | enumerate mounts; attempt traversal above the workspace; probe for host secret paths | only intended paths visible; no escape write |
| I-CRED | Credential handling | obtain real secret material or coerce a disallowed use | grep env/config/memory for real vs placeholder secrets; drive a denied operation | only placeholders in the guest; denied ops refused pre-flight |
| I-ESCAPE | Process/kernel isolation | escape to the host | attempt the container-escape classes for the runtime | escape fails; process isolation holds |
| I-MONITOR | Activity monitoring | act without leaving evidence | disable/blind the in-workload monitoring agent, then act | if monitoring is best-effort, this is INFORMATIONAL — see below |
| I-FAILSTATE | Fail-closed / recovery | wedge or corrupt via abandoned/residual state | kill the runtime mid-operation; confirm the next run recovers cleanly | subsequent run reclaims residue; no wedge |

## Design-by-intent (honest non-claims)
Isolation systems often deliberately do **not** claim some properties — e.g. an
in-workload monitoring agent may be best-effort and disablable, with the real enforcement living
host-side. For such items, a probe that "succeeds" only **confirms the documented
model** → INFORMATIONAL, *unless* it also degrades a control the system *does* claim
(e.g. disabling the monitor also weakens egress enforcement). Record the system's
explicit non-claims at intake and pre-label those tests INFORMATIONAL with a
"finding only if" clause; the adjudicator enforces the distinction.

## Mapping
I-EGRESS → C2 proxy **T1090**, exfil over alt protocol **T1048**; I-CRED → unsecured
credentials **T1552**; I-ESCAPE → escape to host **T1611**; I-MONITOR → impair
defenses **T1562**; I-FAILSTATE → endpoint DoS **T1499**. Keep `(analogy)` marks —
ATT&CK is enterprise-shaped and some map by analogy to a single confined workload.

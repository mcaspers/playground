# Rules of Engagement (RoE) — Red Team engagement

Filled in during Phase 0 (intake) and written to `<engagement-dir>/roe.md`, with
the machine-readable scope in `<engagement-dir>/scope.json`. The engagement **must
not proceed** past intake until this is complete and the operator has **attested
authorization**. This mirrors NIST SP 800-115's requirement for explicit written
authorization and a bounded scope (App B).

## Authorization (mandatory)

- **Operator (authorizing human):** _<name / email>_
- **Authorization statement:** _<verbatim — e.g. "I own the systems listed in
  scope, or I hold written authorization to test them, and I authorize the probes
  in the approved plan against exactly those targets.">_
- **Attested:** _<yes/no>_ — recorded as `authorization_attested` in scope.json.
  **No attestation → no run.**
- **Date/time:** _<UTC>_
- **Authorization reference (if the operator does not own the target):** _<ticket /
  signed authorization / contract reference>_

## Scope — IN

- The exact in-scope targets: _<hostnames, IPs, CIDRs, URL patterns>_, recorded as
  each target's `identity.in_scope_patterns` in scope.json.
- For each target: its `target_kind`, `grounding` (ATT&CK platform / OSSTMM channel
  / first-party), `test_catalog`, and `impact_baseline`.

## Scope — OUT (hard stops)

- Any host, network, service, or account **not** listed in scope — recorded as
  `out_of_scope` patterns and refused by the guard even if otherwise matched.
- Shared infrastructure, third-party services, and production data not explicitly
  authorized.
- Real secrets: a probe may confirm a placeholder-vs-real distinction, but must
  never exfiltrate, transmit, or persist a real credential.
- Destructive or data-modifying action, unless the plan explicitly authorizes it
  and the operator has attested that specific authorization.

## Execution constraints

- **Dry-run is the default.** Live probes require `<engagement-dir>/APPROVAL` whose
  fingerprint matches the current authorized scope. The PreToolUse hook and
  `run-probes.sh` both refuse live probes without it.
- Every target contact is scope-guarded (`scope-check.sh` / `roe_assert_in_scope`).
- The engagement is abortable at any point.
- Raw probe evidence stays under `<engagement-dir>/evidence/`; no evidence leaves
  the host without the operator's decision.

## De-confliction / blast radius

- Note any timing windows, rate limits, or systems that must not be disrupted.
- Note a point of contact to halt the engagement.

## Sign-off

- [ ] Scope reviewed and correct (in and out)
- [ ] Authorization attested (`authorization_attested: true` in scope.json)
- [ ] Each target grounded (ATT&CK / OSSTMM / first-party) with a catalog assigned
- [ ] Operator authorizes the approved plan

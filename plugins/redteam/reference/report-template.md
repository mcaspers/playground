# Engagement report — Red Team

Written by the **adjudicator** to `<engagement-dir>/report.md`. Two audiences: the
engineer who fixes findings, and an assessor who wants the NIST/ATT&CK framing.

## 1. Executive summary

- **Engagement id:** `<id>`  **Date:** `<UTC>`  **Mode:** dry-run | live
- **Targets:** _<from scope.json: label · target_kind · grounding · impact_baseline>_
- **Authorization:** attested by _<operator>_ on _<UTC>_ _(ref: <if any>)_
- **Headline:** _<1–3 sentences: did the target's controls hold? worst finding?>_
- **Counts:** _N passed · N findings (C/H/M/L) · N informational (by-design)_

## 2. Rules of engagement & method

- Authorization & scope: _<summarise roe.md / scope.json — in and out>_.
- Methodology: NIST SP 800-115 (Planning → Discovery → Attack → Reporting).
- Catalog(s) used: _<web-url / host-network / … + backing standard>_.

## 3. Findings

For each candidate that survived adjudication:

### F-<n> · <short title>  ·  Severity: CRITICAL|HIGH|MEDIUM|LOW|INFORMATIONAL

- **Target:** _<which in-scope target>_
- **Catalog item:** _<e.g. W-AUTHZ / H-PORT / I-EGRESS>_
- **ATT&CK:** T#### (<tactic>) _(literal | analogy)_
- **NIST control:** <SC-7 / AC-4 / …> — determination: **other-than-satisfied** | satisfied
- **Claim under test:** _<the control the target should enforce>_
- **What was attempted:** _<the probe, in one line>_
- **Observed result:** _<actual outcome + pointer to evidence file>_
- **Why it is (not) a vulnerability:** _<adjudicator reasoning; resolve any
  design-by-intent caveat explicitly>_
- **Reproduction:** `<run-probes.sh … command>` (in-scope target only)
- **Remediation / recommendation:** _<actionable; or "documented behaviour, no
  action" for INFORMATIONAL>_
- **Confidence:** confirmed | plausible

## 4. Coverage

- **ATT&CK coverage table:** technique → attempted? → verdict.
- **NIST 800-53A determination table:** control → objective → satisfied?/basis.
- **Not tested / out of scope:** _<what this run did not cover and why>_.

## 5. Evidence index

- `evidence/<probe>.log` … one per probe, raw output preserved.
- `scope.json`, `roe.md`, `plan.md`, `APPROVAL.consumed` (if live).

## 6. Close-out

- Approval invalidated: _<yes>_. Engagement-owned artifacts on the target cleaned
  up: _<yes/n/a>_. (Teardown does not modify the target itself.)

---

### Severity rubric (SP 800-30 flavour)

- **CRITICAL** — a load-bearing control (e.g. access control, egress isolation,
  secret confidentiality) is broken with data impact.
- **HIGH** — a claimed control broken but bounded, or reliably bypassable with effort.
- **MEDIUM** — partial break / requires an unlikely precondition / evidence
  integrity weakened without full bypass.
- **LOW** — hardening gap, no direct break.
- **INFORMATIONAL** — behaviour matches a documented non-claim; recorded for
  completeness, no action implied.

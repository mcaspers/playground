# NIST references & control mapping

Three uses of NIST here: (1) **SP 800-115** gives the *methodology* the engagement
follows; (2) **SP 800-53 Rev 5** gives the *controls* a target is expected to
implement, so each test doubles as a control-assessment procedure in the shape of
**SP 800-53A**; (3) **SP 800-53B** supplies the Low/Moderate/High **impact baseline**
that scales how deep the assessment goes.

> These are published NIST framings used to structure and communicate the test.
> Citing a control means "this test exercises the property that control names" — it
> is not a certification or an ATO claim.

## SP 800-115 — Technical Guide to Information Security Testing and Assessment

The engagement's phases map onto 800-115's four-stage penetration-testing model:

| 800-115 phase | This engagement |
|---|---|
| **Planning** | Phase 0 intake (scope, authorization, target definition); Phase 1 recon → attack-surface map |
| **Discovery** | Phase 2 confirm the target is in scope/reachable; Phase 3 read-only enumeration (surface, services, config, transport) |
| **Attack** | Phase 4 plan → Phase 5 human approval → Phase 6 execute probes against the authorized target |
| **Reporting** | Phase 7 adjudicate, score, and report; close out |

800-115 also insists on: explicit **written authorization** and rules of engagement
(→ the RoE template and the attestation gate), a **bounded target** (→ only the
scope declared in scope.json), and **evidence handling** (→ every probe's raw output
kept under the engagement dir). Note 800-115 explicitly excludes physical security
testing — for a physical/badging target use OSSTMM's Physical channel as the
classification anchor and NIST SP 800-53 PE / SP 800-116 as the oracle.

## SP 800-53 Rev 5 — controls a test exercises (by class)

| Control | Name | Exercised by (typical) |
|---|---|---|
| **SC-7** (+ (4),(5),(7)) | Boundary Protection; deny-by-default; prevent split tunneling | network/egress/isolation tests |
| **AC-4** | Information Flow Enforcement | egress control, data-flow scoping |
| **AC-3 / AC-6** | Access Enforcement / Least Privilege | authorization tests, privilege escalation |
| **IA-2 / IA-5 / IA-9** | Identification & Auth; Authenticator Management; Service ID | authentication, credential handling |
| **AU-2 / AU-3 / AU-6 / AU-9 / AU-10** | Audit events; record content; review; audit protection; non-repudiation | logging/attribution, evidence integrity |
| **SC-2 / SC-3 / SC-39** | Application partitioning; security-function & process isolation | isolation/escape tests |
| **SC-8 / SC-12 / SC-17** | Transmission confidentiality; key management; PKI certificates | TLS/transport tests |
| **CM-6 / CM-7** | Configuration settings; Least Functionality | config-review (CIS) tests |
| **SC-5 / SC-24 / CP-10** | DoS protection; fail-in-known-state; recovery | availability / fail-closed tests |
| **PE family** | Physical & Environmental Protection | physical/badging (oracle only) |

## SP 800-53A — turning a control into a test

For each in-scope control the planner writes an assessment objective in 800-53A
shape:

- **Assessment objective** — the property to determine (e.g. "the managed interface
  denies by default; no unauthorized flow reaches an off-scope host").
- **Methods** — EXAMINE (the discovery facts from Phase 3), TEST (the live probe),
  INTERVIEW (n/a for automated runs).
- **Determination** — Satisfied / Other-than-satisfied, with the probe's evidence as
  the basis.

## SP 800-53B — impact baseline (how deep)

The target's `impact_baseline` (`low | moderate | high`, default `moderate`) selects
control breadth per SP 800-53B, orthogonal to the target kind. Higher baselines pull
more controls into scope and demand deeper validation.

## Adjacent references (context, not scored)

- **SP 800-207 Zero Trust Architecture** — the "no implicit trust; enforce at a
  policy enforcement point" model behind boundary tests.
- **SP 800-190 Application Container Security Guide** — isolation/escape concerns.
- **SP 800-30** — risk-rating vocabulary for the report's severity calls.

Sources: SP 800-115 — https://nvlpubs.nist.gov/nistpubs/legacy/sp/nistspecialpublication800-115.pdf ;
SP 800-53 Rev 5 — https://csrc.nist.gov/pubs/sp/800/53/r5/upd1/final ;
SP 800-53A Rev 5 — https://csrc.nist.gov/pubs/sp/800/53/a/r5/final ;
SP 800-53B — https://csrc.nist.gov/pubs/sp/800/53/b/upd1/final

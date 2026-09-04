# Target-profile taxonomy — grounding in authoritative public standards

Research question: we are generalizing the red-team plugin from a single fixed target
(originally a single fixed target — a coding-agent sandbox boundary) to *any* authorized target — corporate network, virtual
host, web app/URL, coding-agent sandbox, physical-access-adjacent system (badging).
We want a per-target-type "profile" concept grounded in published standards, not
invented ad hoc. This file establishes what the sources actually say and recommends
how to name and structure the concept.

All claims below are cited to the document that owns them (doc number, section, URL).

---

## Executive recommendation

1. **Do not call the per-target concept a "Profile."** The word is already claimed by
   two NIST constructs that mean something different from a per-target test catalog,
   and both are in this plugin's own vocabulary neighborhood (we already cite CSF-adjacent
   NIST material and 800-53). Reusing "profile" would actively mislead an assessor:
   - **NIST CSF 2.0 "Organizational Profile"** = an organization's *current and/or target
     cybersecurity outcome posture* against the CSF Core — a risk/outcome-management
     artifact, not a test plan (NIST CSWP 29 / CSF 2.0, Sec. 3 "Organizational Profiles";
     NIST SP 1301). A "Target Profile" there is the *desired outcome state*, the opposite
     end of a gap analysis — not a target *system type*.
   - **NIST OSCAL "profile"** = a machine-readable *baseline of selected + tailored controls*
     imported from a catalog (OSCAL Profile model). Also not a test catalog.

   Recommended term: **"target profile" → rename to `target-kind`** (or "target class" /
   "engagement profile" if a noun is wanted). In plugin code/config use a stable key such
   as `target_kind: host-network | web-url | coding-sandbox | physical-badging`. If the
   team insists on the word "profile" in prose, always qualify it as **"target-kind
   profile"** and add a one-line disambiguation note versus CSF/OSCAL profiles, because a
   NIST-literate assessor reading an unqualified "target profile" will assume CSF outcomes.

2. **Structure it as two orthogonal layers**, not one blob:
   - a **constant spine** (the assessment *method*): NIST SP 800-115 four-phase
     methodology + MITRE ATT&CK technique mapping + NIST SP 800-53 / 800-53A control &
     assessment-objective mapping. This never changes with target type.
   - a **target-kind layer** (the *what/where*): recon focus, a "target-establishment
     adapter" (how you stand up / reach the target), and the **test catalog** drawn from
     the target-appropriate public methodology (WSTG for web, CIS + 800-115 network
     techniques for host/network, etc.). Only this layer swaps.

3. **Back each target-kind with the narrowest authoritative public methodology that
   actually covers it**, and be honest where none exists: **physical/badging has no clean
   public *offensive test-catalog* baseline** — 800-115 explicitly scopes out physical
   security testing, and PTES/OWASP don't cover badging hardware. Treat it as a documented
   gap, not a forced citation (details in the mapping table).

---

## 1. NIST SP 800-115 — what it actually defines

Source: NIST SP 800-115, *Technical Guide to Information Security Testing and Assessment*
(Sep 2008). PDF: https://nvlpubs.nist.gov/nistpubs/legacy/sp/nistspecialpublication800-115.pdf

800-115 organizes **technique categories** (not "target types") into three technical
sections, plus process sections. Verbatim table-of-contents structure:

- **Section 3 — Review Techniques** (examination, low-risk, no exploitation):
  - 3.1 Documentation Review
  - 3.2 Log Review
  - 3.3 Ruleset Review
  - 3.4 System Configuration Review
  - 3.5 Network Sniffing
  - 3.6 File Integrity Checking
  - (Table 3-1 "Review Techniques")
- **Section 4 — Target Identification and Analysis Techniques** (mostly non-intrusive discovery):
  - 4.1 Network Discovery
  - 4.2 Network Port and Service Identification
  - 4.3 Vulnerability Scanning
  - 4.4 Wireless Scanning (4.4.1 Passive, 4.4.2 Active, 4.4.3 Wireless Device Location
    Tracking, 4.4.4 Bluetooth Scanning)
- **Section 5 — Target Vulnerability Validation Techniques** (intrusive; confirms exploitability):
  - 5.1 Password Cracking
  - 5.2 Penetration Testing (5.2.1 Penetration Testing Phases, 5.2.2 Penetration Testing Logistics)
  - 5.3 Social Engineering
- **Section 6 — Security Assessment Planning**; **Section 7 — Security Assessment Execution**;
  **Section 8 — Reporting**.
- Appendices: **B — Rules of Engagement Template**; **C — Application Security Testing and
  Examination**; **D — Remote Access Testing**.

The **penetration-testing methodology** (Sec 5.2.1, Figure 5-1 "Four-Stage Penetration
Testing Methodology") has four phases: **Planning → Discovery → Attack → Reporting**, with
a feedback loop from Attack back to Discovery (Figure 5-2 "Attack Phase Steps with Loopback
to Discovery Phase"). The doc states verbatim: "Figure 5-1 represents the four phases of
penetration testing" and "The reporting phase occurs simultaneously with the other three
phases." This is the spine the plugin's phase model already maps onto (see
`reference/nist-references.md`).

**Key takeaway for our taxonomy:** 800-115's own top-level axis is *technique category*
(review / identification / validation), **not** target type. It gestures at target-typed
testing only inside techniques — 4.4 Wireless, App C Application Security Testing, App D
Remote Access Testing — and 2.4.1 distinguishes External vs Internal and 2.4.2 Overt vs
Covert. So 800-115 legitimately supplies our **constant spine and the network/host
review+discovery+validation catalog**, but it does *not* itself define a clean per-target
profile taxonomy — we compose that from target-specific methodologies (Section 4 below).
Notably, 800-115 does **not** cover physical security testing or badging.

---

## 2. CSF 2.0 "Profiles" and OSCAL "profiles" — FIT or MISMATCH?

Both are a **MISMATCH** for "per-target-type test catalog." Reusing the word would mislead.

### NIST CSF 2.0 Organizational Profiles — MISMATCH (risk/outcome posture)
Sources: NIST CSWP 29, *The NIST Cybersecurity Framework (CSF) 2.0* (Feb 2024), Sec. 3
"Organizational Profiles"; NIST CSF 2.0 Profiles hub https://www.nist.gov/cyberframework/profiles;
NIST SP 1301 *Quick-Start Guide for Creating and Using Organizational Profiles*
https://csrc.nist.gov/pubs/sp/1301/final.

- An **Organizational Profile** "describes an organization's current and/or target
  cybersecurity posture in terms of the Core's outcomes."
- A **Current Profile** = outcomes currently achieved; a **Target Profile** = the *desired*
  outcomes selected/prioritized. The method is Current → Target → gap analysis → action plan.
- So "Target Profile" in CSF means a *desired future security-outcome state for an
  organization*, evaluated by gap analysis — **not a category of system under test**. An
  assessor who reads "target profile: web" in our tool would reasonably expect a CSF outcome
  posture and be confused. Direct clash — avoid.

### NIST OSCAL "profile" — MISMATCH (control-baseline selection)
Sources: OSCAL Profile Model https://pages.nist.gov/OSCAL/documentation/schema/profile/;
OSCAL control-layer concepts https://pages.nist.gov/OSCAL/concepts/layer/.

- An OSCAL **profile** "represents a baseline of selected controls from one or more control
  catalogs." It is `import` (pull controls from a catalog) + `merge` (organize/resolve) +
  `modify` (tailor parameters/objectives) — i.e. a tailored **control baseline as data**.
- This is closer to our *baseline layer* than to our *target layer*, but it is still about
  **controls**, not **tests/attacks**. If anything, OSCAL "profile" is the right word for our
  **800-53 baseline selection** (Sec 3 below), which is exactly why we must not spend it on
  the per-target-type concept.

**Verdict:** "Profile" is doubly loaded in the NIST world we already cite. Use `target-kind`
for the per-target concept. If we ever emit control baselines as data, *that* is where
"profile" (OSCAL sense) legitimately belongs.

---

## 3. NIST SP 800-53 baselines (Low/Moderate/High) as an orthogonal baseline layer

Sources: NIST SP 800-53B *Control Baselines for Information Systems and Organizations*
https://csrc.nist.gov/pubs/sp/800/53/b/upd1/final (defines the Low/Moderate/High and
Privacy baselines); NIST SP 800-53 Rev 5 https://csrc.nist.gov/pubs/sp/800/53/r5/upd1/final;
NIST SP 800-53A Rev 5 *Assessing Security and Privacy Controls*
https://csrc.nist.gov/pubs/sp/800/53/a/r5/final; FIPS 199 (impact categorization).

- **800-53B** defines the security control baselines — **Low / Moderate / High** — as
  pre-selected control sets keyed to the system's FIPS-199 impact level, plus a Privacy
  baseline. These are **impact-driven**, fully **orthogonal to what *kind* of system** the
  target is: a web app and a host can each be Low, Moderate, or High.
- **800-53A** turns each selected control into **assessment objectives** decomposed into
  determination statements, evaluated by the methods **Examine / Interview / Test** against
  assessment objects (specifications, mechanisms, activities, individuals). This is already
  the shape the plugin uses (`nist-references.md`: EXAMINE = inspection facts, TEST = live
  probe, INTERVIEW = n/a for automated runs).
- **Fit for us:** Low/Moderate/High is an excellent **second orthogonal dimension** — a
  *rigor/impact* selector — layered *under* both the spine and the target-kind. It decides
  *how many controls and how deep*, independent of *which target kind*. Recommended:
  `impact_baseline: low | moderate | high` (default Moderate), sourced from 800-53B; each
  in-scope control still gets an 800-53A assessment objective. This keeps our existing
  800-53/800-53A mapping intact and simply parameterizes its breadth.

---

## 4. Non-NIST per-target methodologies to map target-kinds onto

For each: coverage, current version/status, authority/stability.

### PTES — Penetration Testing Execution Standard
- **Covers:** general penetration-test *process* (org/network-centric), all target kinds
  loosely; not target-specific.
- **Phases (7):** Pre-engagement Interactions, Intelligence Gathering, Threat Modeling,
  Vulnerability Analysis, Exploitation, Post-Exploitation, Reporting.
- **Version/status:** created ~2009 by a practitioner group; the main standard is **still at
  the pre-1.0 "v1.0-era" wiki** and the Technical Guidelines have **not seen a formal
  versioned release in years** — widely cited but effectively **frozen/community-maintained**.
- **Authority:** community de-facto standard, no standards body behind it. Good as a
  *phase-vocabulary cross-map* to 800-115's four phases; **weak as a citable, versioned
  baseline**. Treat as corroborating, not primary. Site: http://www.pentest-standard.org/
- **Recommendation:** use PTES only to enrich the *spine's* attack/post-exploitation
  vocabulary; do not hang a target-kind's authority on it.

### OWASP Web Security Testing Guide (WSTG) — web/URL
- **Covers:** web applications and web services — the test *catalog* for the web target-kind.
- **Version/status:** **v4.2, released Dec 2020**, current stable; v5.0 in active development
  on GitHub. Stable, well-structured, per-test IDs (WSTG-xxxx).
  https://owasp.org/www-project-web-security-testing-guide/ ; v4.2:
  https://owasp.org/www-project-web-security-testing-guide/v42/
- **Authority:** OWASP flagship; the de-facto web pentest catalog. **Strong, stable, citable.**

### OWASP ASVS — Application Security Verification Standard
- **Covers:** application-layer **verification requirements** (what "secure" means), a
  requirements/oracle set rather than an attack playbook — complements WSTG.
- **Version/status:** **v5.0.0, released 30 May 2025** (Global AppSec EU Barcelona); ~350
  requirements in 17 chapters; three verification levels (L1/L2/L3).
  https://github.com/OWASP/ASVS ; project: https://owasp.org/www-project-application-security-verification-standard/
- **Authority:** OWASP flagship; **strong and current.** Use as the web target-kind's
  **control/oracle baseline** (pairs with WSTG's test catalog the way 800-53A objectives
  pair with 800-115 techniques).

### OWASP MASVS / MASTG / MASWE — mobile
- **Covers:** mobile apps (iOS/Android). MASVS = verification standard, MASTG = testing guide,
  MASWE = weakness enumeration.
- **Version/status:** **MASVS v2.0.0** (presented OWASP AppSec Dublin 2023; note v2 dropped
  the old L1/L2/R verification levels — reworked into "MAS Testing Profiles" under MASWE);
  **MASTG v2.0** current. https://mas.owasp.org/MASVS/ ; https://mas.owasp.org/MASTG/
- **Authority:** OWASP flagship; **strong.** Relevant only if we add a `mobile-app`
  target-kind (not in the current four); noted here so the taxonomy has a clean home for it.

### CIS Benchmarks — per-platform hardening (host/network config baseline)
- **Covers:** secure-configuration baselines for **specific platforms** — OSes, servers,
  cloud providers, containers, databases, network devices, mobile, desktop software.
- **Version/status:** **100+ benchmarks across 25+ vendor product families**, consensus-
  developed by 12,000+ practitioners; each benchmark is independently versioned and updated
  regularly (e.g. Windows benchmarks aligned to Microsoft's schedule, refreshed within ~90
  days of a release). https://www.cisecurity.org/cis-benchmarks
- **Authority:** CIS is a recognized authority; benchmarks are widely referenced by
  regulators. **Strong**, but **per-platform** — you cite the *specific* benchmark
  (e.g. "CIS Ubuntu 22.04 Benchmark v2.0.0"), not "CIS" generically. These are the natural
  **configuration-review oracle** for the host/network target-kind, feeding 800-115 Sec 3.4
  "System Configuration Review."

---

## 5. Target-kind → authoritative baseline mapping

| Target-kind (our concept) | Recon focus | Test-catalog baseline(s) | Control / oracle baseline | Authority & gaps |
|---|---|---|---|---|
| **host / network** (corporate network, virtual server/host) | network discovery, port/service ID, vuln scan (800-115 Sec 4.1–4.3) | **NIST SP 800-115 Sec 3–5** (review, identification, validation techniques); PTES phases as vocabulary cross-map | **CIS Benchmarks** for the specific platform (config-review oracle) + **NIST SP 800-53** SC/AC/AU families via 800-53A objectives | Strong. 800-115 is the primary methodology; CIS is per-platform and must be cited by exact benchmark+version. |
| **web / URL** (web app or service) | app mapping, endpoint/entry-point enumeration | **OWASP WSTG v4.2** (per-test IDs) | **OWASP ASVS v5.0.0** (verification requirements as oracle) + 800-53 SA/SI as needed | Strong & current. WSTG = tests, ASVS = pass/fail oracle. 800-115 App C corroborates. |
| **coding-agent sandbox** (the original motivating example) | boundary/source recon → attack-surface map | **a first-party `catalogs/isolation-boundary.md`** | **MITRE ATT&CK + NIST SP 800-53 boundary mapping** (`mitre-attack-mapping.md`, `nist-references.md`) — SC-7/AC-4/SC-39/etc. via 800-53A | Bespoke but well-grounded: no public catalog exists for "isolate a coding-agent's egress/mount boundary," so a first-party catalog *is* the authoritative artifact, itself built on 800-115 + ATT&CK + 800-53. Honest: this is a first-party baseline, not a public standard. |
| **physical / badging** (badging system, physical-access-adjacent) | facility/badge-reader recon, RFID/credential enumeration | **NO clean public *offensive test-catalog* baseline.** | partial: NIST SP 800-53 **PE (Physical & Environmental Protection)** family gives *controls*; **800-116** (PIV in PACS) informs badging design, not attack testing | **GAP — say so honestly.** 800-115 explicitly does not cover physical security testing; PTES/OWASP don't cover badging hardware. PE controls + 800-116 supply an *oracle* to assess against, but there is no authoritative attack catalog. Recommend: mark this target-kind **experimental/manual**, drive it from 800-53 PE assessment objectives (800-53A) plus a hand-curated probe list, and label results accordingly rather than overstating a standard. |

Notes on the gap row's citations: NIST SP 800-53 Rev 5 PE family —
https://csrc.nist.gov/pubs/sp/800/53/r5/upd1/final ; NIST SP 800-116 Rev 1 *Guidelines for
the Use of PIV Credentials in Facility Access* — https://csrc.nist.gov/pubs/sp/800/116/r1/final.
Both are *control/guidance* sources, not penetration-test catalogs — cite them as the
assessment oracle, never as a "how to attack a badge reader" methodology.

---

## 6. Baseline layer vs target layer — the architecture

Keep **three axes** and do not collapse them:

```
CONSTANT SPINE (never varies by target)
  - Method:   NIST SP 800-115 four phases  (Planning -> Discovery -> Attack -> Reporting)
  - Mapping:  MITRE ATT&CK techniques
  - Assess:   NIST SP 800-53 controls, written as 800-53A assessment objectives
              (Examine / Test / Interview)
  - Governance: written authorization + Rules of Engagement (800-115 App B) + approval gate

IMPACT/RIGOR LAYER (orthogonal; how deep)   [optional, from 800-53B]
  - impact_baseline: low | moderate | high   -> selects control breadth (FIPS-199 driven)

TARGET-KIND LAYER (the only thing the target swaps)
  - recon_focus:            what to enumerate  (e.g. web: entry points; host: ports/services)
  - target_establishment:   the adapter that stands up / reaches the target
                            (sandbox: provision disposable Guest; web: point at authorized URL;
                             host: authorized network segment; badging: physical/manual)
  - test_catalog:           the target-appropriate probe menu
                            (web -> WSTG/ASVS; host/network -> 800-115 Sec 3-5 + CIS;
                             sandbox -> catalogs/isolation-boundary.md; badging -> PE objectives + manual)
```

The spine, the RoE/approval gate, the ATT&CK mapping, and the 800-53A objective shape are
**invariants** — they are what makes any run a *defensible assessment*. A target-kind is a
**pluggable triple** `{recon_focus, target_establishment_adapter, test_catalog}`. This is
exactly how the engagement already decomposes (Phase 1 recon → Phase 2/3
establish+inspect sandbox → Phase 4–6 run the boundary catalog); generalizing means letting
Phases 1–3's *content* and the Phase 4 catalog be selected by `target_kind` while Phases
0/5/7 (scope/RoE, approval, adjudicate+report) stay fixed.

---

## 7. Citations (consolidated)

- NIST SP 800-115, *Technical Guide to Information Security Testing and Assessment* — Sec 3
  (Review Techniques), Sec 4 (Target Identification & Analysis), Sec 5 (Target Vulnerability
  Validation; 5.2.1 Penetration Testing Phases, Fig 5-1 four-stage methodology), Sec 6–8,
  App B (RoE), App C (App Security Testing), App D (Remote Access):
  https://nvlpubs.nist.gov/nistpubs/legacy/sp/nistspecialpublication800-115.pdf
- NIST CSWP 29, *The NIST Cybersecurity Framework (CSF) 2.0*, Sec 3 Organizational Profiles:
  https://csrc.nist.gov/pubs/cswp/29/the-nist-cybersecurity-framework-csf-20/final
- NIST CSF 2.0 Profiles hub: https://www.nist.gov/cyberframework/profiles
- NIST SP 1301, *CSF 2.0 Quick-Start Guide for Creating and Using Organizational Profiles*:
  https://csrc.nist.gov/pubs/sp/1301/final
- NIST OSCAL Profile Model (schema): https://pages.nist.gov/OSCAL/documentation/schema/profile/
- NIST OSCAL control layer / profile concept: https://pages.nist.gov/OSCAL/concepts/layer/
- NIST SP 800-53B, *Control Baselines* (Low/Moderate/High + Privacy):
  https://csrc.nist.gov/pubs/sp/800/53/b/upd1/final
- NIST SP 800-53 Rev 5, *Security and Privacy Controls* (incl. PE family):
  https://csrc.nist.gov/pubs/sp/800/53/r5/upd1/final
- NIST SP 800-53A Rev 5, *Assessing Security and Privacy Controls* (assessment objectives;
  Examine/Interview/Test): https://csrc.nist.gov/pubs/sp/800/53/a/r5/final
- NIST SP 800-116 Rev 1, *PIV Credentials in Facility Access* (badging oracle, not attack):
  https://csrc.nist.gov/pubs/sp/800/116/r1/final
- PTES, *Penetration Testing Execution Standard* (7 phases; frozen/community):
  http://www.pentest-standard.org/
- OWASP WSTG (project / v4.2, Dec 2020):
  https://owasp.org/www-project-web-security-testing-guide/ ,
  https://owasp.org/www-project-web-security-testing-guide/v42/
- OWASP ASVS v5.0.0 (30 May 2025): https://github.com/OWASP/ASVS ,
  https://owasp.org/www-project-application-security-verification-standard/
- OWASP MASVS v2.0.0 / MASTG v2.0: https://mas.owasp.org/MASVS/ , https://mas.owasp.org/MASTG/
- CIS Benchmarks (100+ across 25+ product families, consensus, per-platform versioned):
  https://www.cisecurity.org/cis-benchmarks

> Version note: WSTG v4.2 (2020) and PTES (frozen) are the two "watch the freshness" items;
> everything else here is current as of research date 2026-09. Cite CIS by *specific
> benchmark + version*, never generically.

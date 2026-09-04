# Target kinds — the open, grounded model

The plugin does **not** ship a fixed list of target types. `target_kind` is an
**open, kebab-case string** the intake agent derives from the engagement, and each
value must be **grounded** in a maintained, offense-oriented reference. This keeps
the tool honest (every kind is traceable to a standard or an explicit first-party
artifact) and extensible (a new kind never needs a code change). The sourced
rationale for this design is in [`target-classification-research.md`](target-classification-research.md)
and [`profiles-research.md`](profiles-research.md).

> Naming note: we deliberately avoid the word "profile" — it collides with NIST
> CSF 2.0 "Organizational/Target Profiles" (an org's desired security-outcome
> posture) and NIST OSCAL "profiles" (a tailored control baseline). Those mean
> something different; using the word would mislead an assessor.

## The three orthogonal axes

1. **Constant spine (never varies):** NIST SP 800-115 four phases + MITRE ATT&CK
   technique mapping + NIST SP 800-53/800-53A control & assessment-objective
   mapping + RoE and the approval gate. This is what makes any run a *defensible
   assessment*.
2. **Impact/rigor layer (optional, orthogonal):** `impact_baseline: low | moderate
   | high` from NIST SP 800-53B — decides *how deep*, independent of target type.
   Default `moderate`.
3. **Target-kind layer (the only thing that swaps):** the triple
   `{recon_focus, target_establishment, test_catalog}`.

## Grounding — every `target_kind` cites one of these
- **MITRE ATT&CK platform/domain** for cyber planes (Enterprise: Windows, macOS,
  Linux, Network Devices, Containers, ESXi, IaaS, SaaS, Identity Provider, Office
  Suite, PRE; Mobile: Android, iOS; ICS). Cite the **current** platform set at
  intake — MITRE revises it per release.
- **OSSTMM channel** for the planes ATT&CK does not model — **Physical** and
  **Human** (e.g. badging, social engineering).
- **`first-party`** with a one-line justification when no external class fits (a
  bespoke system with no public catalog). The first-party catalog *is* the
  authoritative artifact, itself built on 800-115 + ATT&CK + 800-53.

## Seed values (illustrative, not a closed set)

| `target_kind` | Grounding (cite at intake) | Test catalog |
|---|---|---|
| `host-network` | ATT&CK Windows / macOS / Linux / Network Devices | [`catalogs/host-network.md`](catalogs/host-network.md) (800-115 §3–5 + CIS) |
| `cloud-tenant` | ATT&CK IaaS / SaaS / Identity Provider / Office Suite | host-network + provider CIS Benchmark |
| `container-virt` | ATT&CK Containers / ESXi | [`catalogs/isolation-boundary.md`](catalogs/isolation-boundary.md) + CIS Docker/K8s |
| `web-url` | OWASP (ATT&CK has no web-app platform) | [`catalogs/web-url.md`](catalogs/web-url.md) (WSTG + ASVS) |
| `mobile-app` | ATT&CK Mobile (Android/iOS) | author from OWASP MASVS/MASTG |
| `ics-ot` | ATT&CK ICS | author from NIST SP 800-82 |
| `isolation-boundary` | first-party (isolation is bespoke per system) | [`catalogs/isolation-boundary.md`](catalogs/isolation-boundary.md) |
| `physical-badging` | OSSTMM Physical (+ Human) | first-party + NIST SP 800-53 PE / SP 800-116 oracle (experimental/manual) |
| `social-human` | OSSTMM Human | NIST SP 800-115 §5.3 + first-party |

Two seed values have **no clean external class** — `web-url` (its real anchor is
OWASP, not an ATT&CK platform) and any bespoke `first-party` kind — which is itself
the evidence that a frozen external enum can't cover the field. Keep it open.

## What intake records (the guard reads this)
For each target, `scope.json` carries `{ target_kind, grounding, identity,
test_catalog, impact_baseline }`. See the `redteam-intake` agent and
[`roe-template.md`](roe-template.md) for the exact shape. To author a catalog for a
kind not shipped here, follow [`catalogs/authoring-a-catalog.md`](catalogs/authoring-a-catalog.md).

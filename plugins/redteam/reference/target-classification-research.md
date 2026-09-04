# Target classification — is there a formal taxonomy to anchor `target-kind` to?

Research question: the plugin owner does not want to freeze an *invented* enumeration of
target types (host-network / web-url / coding-sandbox / physical-badging). Is there a
**formal, authoritative, maintained** asset/target-classification taxonomy we can **adopt**
to enumerate `target-kind`, instead of inventing our own? If a clean one exists, anchor to
it. If not, keep `target-kind` **open and RoE-declared** and reference whatever standard
applies per engagement.

This file evaluates five candidate taxonomies against primary sources and gives one
opinionated recommendation. It builds on the prior decision to name the concept
`target-kind` (see `profiles-research.md`), and does not re-litigate the naming.

All claims are cited to the owning document (number/section) and URL.

---

## Executive recommendation

**There is no single clean formal taxonomy whose classes are "kinds of offensive test
target."** Every authoritative asset/target classification we found was built for a
*different job* than ours:

- The **inventory/GRC taxonomies** (CIS Controls Control 1–3, ISO/IEC 27005 primary vs
  supporting assets, NISTIR 8011 HWAM/SWAM, NIST CSF `ID.AM`) classify assets *to defend
  and account for them*, not *to select an attack catalog*. Their top-level cut is
  device/software/data — orthogonal to how an offensive engagement is actually scoped.
- **CPE** classifies *products* along application / OS / hardware — a naming scheme for
  vulnerability data, not a target-scoping axis. It answers "what software is this," not
  "what kind of engagement is this."
- Only **two** candidates are genuinely *offense-oriented* and enumerate the environments an
  operator actually attacks: **MITRE ATT&CK domains/platforms** and **OSSTMM channels**.

So the honest answer to the core question is: **keep `target-kind` OPEN and RoE-declared —
do not freeze an invented enum — but anchor the open vocabulary to a hybrid reference
already offense-shaped and already (half) in our stack: MITRE ATT&CK domains + platforms as
the PRIMARY axis, with OSSTMM channels covering the two things ATT&CK structurally does not
model — the Physical and Human planes (badging, social engineering).**

Concretely (detailed in §7):

> `target_kind` is an **open, RoE-declared string**. Every declared value **MUST cite a
> grounding class** from one of two maintained, offense-oriented references: a **MITRE
> ATT&CK platform** (Enterprise/Mobile/ICS domain) for anything in the cyber planes, or an
> **OSSTMM channel** (Physical / Human) for the physical-and-people planes ATT&CK omits.
> The test **catalog** layer stays independently extensible (WSTG for web, CIS benchmarks
> for host config, a first-party `catalogs/isolation-boundary.md` for the coding sandbox, etc.).

This is the "strong candidate" from the brief — and the sources **do** support it, with one
correction: ATT&CK alone is *not* sufficient (it has no Physical/Human class), so OSSTMM is a
required second anchor rather than a nice-to-have. We anchor the *vocabulary* to these
standards; we do **not** freeze the *set of values*, because neither standard was built as a
closed target-type enum and new engagement types (coding-agent sandboxes being the live
example) appear faster than any standards body reclassifies.

Why not just adopt ATT&CK's platform list as the frozen enum? Because (a) it has real gaps
for us — no Physical/badging, no first-class "web application" or "coding-agent sandbox"
class — and (b) MITRE revises the list on its own cadence (it renamed `Network` →
`Network Devices` and added `ESXi` in April 2025), so freezing a copy would drift. Reference
it, don't fork it.

---

## Comparison table

| Candidate taxonomy | Classes it defines (verbatim where possible) | Version / status | Authority & maintenance | Fit as offensive `target-kind` enum | Gaps |
|---|---|---|---|---|---|
| **MITRE ATT&CK — domains + Enterprise platforms** | Domains: **Enterprise, Mobile, ICS**. Enterprise platforms (matrix selector, verbatim): **Windows, macOS, Linux, PRE, Office Suite, Identity Provider, SaaS, IaaS, Network Devices, Containers, ESXi**. Mobile: Android, iOS. | v17.0 (Apr 2025) added **ESXi**, renamed **Network → Network Devices**; v17.1 through Oct 2025; v18 later 2025. Semantic-versioned, STIX-backed. | MITRE, US-gov-funded; **actively maintained**, versioned releases, machine-readable. The de-facto offensive-behavior standard — **already in our stack**. | **Best fit.** Offense-oriented, environment-keyed, citable, maintained. Natural PRIMARY axis. | **No Physical / badging class. No Human/social class. No first-class "web application" class** (web is spread across platforms). Not a *closed* taxonomy — list changes per release. |
| **CIS Controls v8.1 — Control 1/2/3 asset classes** | C1 enterprise assets: **"end-user devices (including portable and mobile), network devices, non-computing/IoT devices, and servers"**. C2: software (**operating systems and applications**). C3: data. | v8.1, **June 2024** (v8 May 2021). | Center for Internet Security; consensus-developed, well maintained. **Strong** authority for *defensive inventory*. | **Poor fit.** Device/software/data cut is an *inventory* axis, not an engagement-scoping axis; a "web app" and a "coding sandbox" both collapse to "servers/software." | No offensive framing; no web-app, cloud-tenant, or sandbox class; physical only as "non-computing/IoT devices," not as an attack plane. |
| **CPE — Common Platform Enumeration (NISTIR 7695, v2.3)** | `part` component: **`a` = application, `o` = operating system, `h` = hardware** (`cpe:2.3:a:` / `:o:` / `:h:`). | NISTIR 7695 v2.3 (2011), current; drives NVD/CVE product naming. | NIST; maintained via NVD. **Strong**, but purpose is *product identification for vuln data*. | **Not usable as a target-kind axis.** Three product classes (a/o/h) are far too coarse and are about *what a component is*, not *what engagement type it is*. | Only 3 classes; no network/cloud/web/physical/human distinction; wrong abstraction entirely. Useful only downstream (labeling discovered software), not for scoping. |
| **OSSTMM — ISECOM channels** | Five channels: **Human, Physical, Wireless (Spectrum Security), Telecommunications, Data Networks**. | OSSTMM **3.0** (2010); ISECOM; v4 long in draft. **Frozen-ish but stable and citable**. | ISECOM; recognized methodology body. Authority solid; maintenance slow. | **Good complementary fit.** Uniquely models **Physical** and **Human** as first-class test planes — exactly ATT&CK's gaps. Coarser than ATT&CK on the cyber side. | Only 5 channels (coarse); "Data Networks" lumps all IT together; no cloud/web/sandbox granularity; dated (2010), no formal update in years. |
| **ISO/IEC 27005:2022 — asset types** | Two classes: **primary assets** (information, business processes) and **supporting assets** (hardware, software, network, personnel, site, organization). | 27005:**2022** (current), part of the ISO/IEC 27000 family. | ISO/IEC; strong standards authority; maintained. | **Poor fit.** Primary/supporting is a *risk-identification* cut for GRC, not an offensive target class. Everything we test is a "supporting asset." | No offensive framing; too abstract; no per-target-type granularity; behind a paywall (not freely citable text). |
| *(ref) NIST asset categorizations* — SP 800-53 "system element", NISTIR 8011 HWAM/SWAM, CSF `ID.AM` | SP 800-53: **"system element"** (a discrete component of a system). NISTIR 8011: **Hardware Asset Management (HWAM)** / **Software Asset Management (SWAM)** capabilities. CSF 2.0 `ID.AM`: asset inventory outcomes. | 800-53 Rev 5 (2020, upd 2023); NISTIR 8011 Vol 2 HWAM (2017); CSF 2.0 (2024). | NIST; strong; maintained. | **Poor fit.** All are *inventory/assessment* framings (hardware vs software vs data), not engagement types. | Same device/software/data cut as CIS; no offensive or physical-attack axis. |

---

## Per-candidate detail (primary sources)

### 1. MITRE ATT&CK — domains and platforms

Enterprise matrix, platform selector, **verbatim** from the matrix page:
"Windows", "macOS", "Linux", "PRE", "Office Suite", "Identity Provider", "SaaS", "IaaS",
"Network Devices", "Containers", "ESXi"
(https://attack.mitre.org/matrices/enterprise/). The three **domains** are Enterprise,
Mobile, ICS (https://attack.mitre.org/). Mobile platforms are Android and iOS
(https://attack.mitre.org/matrices/mobile/).

Is the platform list a *formal, citable taxonomy*? It is a **maintained, versioned,
machine-readable enumeration** published as part of the ATT&CK data model (STIX
`x_mitre_platforms`), which is stronger than "a blog list" but weaker than an ISO-style
standardized classification — it is a **framework artifact MITRE revises per release**, not a
frozen standard. Evidence of active maintenance and drift: ATT&CK **v17.0 (April 2025)** added
the **ESXi** platform and **renamed `Network` to `Network Devices`**; v17.1 ran to Oct 2025
(https://attack.mitre.org/resources/updates/updates-april-2025/;
https://medium.com/mitre-attack/attack-v17-dfb59eae2204). This is exactly why we should
**reference** the current platform set at intake rather than **freeze a copy**.

Fit: **best of the five** for an offensive tool — it is offense-oriented, environment-keyed,
citable, actively maintained, and already the technique-mapping backbone of this plugin.
Gaps that matter for us: (a) **no Physical/badging platform** and **no Human/social platform**
— ATT&CK Enterprise deliberately models cyber behavior, not facility or people attacks;
(b) **no single "web application" platform** — web attack surface is distributed across
`SaaS`, `IaaS`, and app-on-`Windows/Linux`, so "web-url" is our *catalog* concern (WSTG),
not an ATT&CK platform; (c) **no "coding-agent sandbox" class** — it's an emerging target
type no external taxonomy yet names.

### 2. CIS Controls v8.1 — Control 1/2/3 asset classes

Control 1 "Inventory and Control of Enterprise Assets," **verbatim** scope: actively manage
"end-user devices (including portable and mobile), network devices, non-computing/IoT
devices, and servers connected to the infrastructure physically, virtually, remotely, and
those within cloud environments"
(https://www.cisecurity.org/controls/inventory-and-control-of-enterprise-assets;
https://cas.docs.cisecurity.org/en/latest/source/Controls1/). Control 2 "Inventory and
Control of Software Assets" covers "operating systems and applications"
(https://www.cisecurity.org/controls/inventory-and-control-of-software-assets). Control 3
"Data Protection" covers identify/classify/handle/retain/dispose of **data**
(https://www.cisecurity.org/controls/data-protection).

Version/status: **v8.1, released June 2024** (v8 was May 2021)
(https://www.cisecurity.org/about-us/media/press-release/center-for-internet-security-releases-cis-controls-v8-1-with-new-governance-recommendations).
Authority: strong (CIS), but the classification is an **inventory/defense** cut. Fit as an
offensive `target-kind` enum: **poor** — end-user-device / network-device / IoT / server /
software / data does not answer "what kind of engagement is this," and it has no web-app,
cloud-tenant, sandbox, or human/physical-attack class. Its right role in our stack is
unchanged from prior research: the **config-review oracle** (specific CIS Benchmarks) for the
host/network catalog, not the target axis.

### 3. CPE — Common Platform Enumeration (NISTIR 7695)

The `part` component defines exactly three product classes: **`a` (application), `o`
(operating system), `h` (hardware)**, bound as `cpe:2.3:a:…` / `:o:…` / `:h:…`
(https://nvlpubs.nist.gov/nistpubs/legacy/ir/nistir7695.pdf, CPE Naming Specification v2.3,
§5–6). It is a **product-identification** scheme feeding NVD/CVE, current since 2011.

Usable as an asset-type axis? **No.** Three classes is far too coarse, and the axis is "what
*kind of component* is this software entry," not "what kind of *target* is this engagement."
A web app, a corporate LAN, and a coding sandbox are all "`a` running on `o` running on `h`."
CPE is useful **downstream** (labeling discovered software/versions during recon so findings
map to CVEs), never as the scoping enum.

### 4. OSSTMM — ISECOM channels

OSSTMM 3 defines five **channels**: **Human Security, Physical Security, Wireless
Communications (Spectrum Security), Telecommunications, and Data Networks**
(OSSTMM 3, ISECOM, "Channels"; https://www.isecom.org/OSSTMM.3.pdf). Verbatim gloss from the
manual's framing: Human = "security within the human interaction"; Physical Security = the
"tangible" channel "requiring physical effort"; Wireless = electronic/EM signals;
Telecommunications = phone/analog+digital networks; Data Networks = wired electronic systems.

Version/status: **OSSTMM 3.0, released 2010**; ISECOM; version 4 has been in draft for years.
So it is **stable and citable but slow-moving** — treat as a fixed reference, not a
freshly-maintained one. Authority: ISECOM is a recognized security-testing methodology body;
OSSTMM is one of the few *offense/assessment* frameworks that treats **Physical** and
**Human** as first-class, peer test planes.

Fit: **the key complement to ATT&CK.** OSSTMM's Physical and Human channels are precisely the
planes ATT&CK Enterprise does not model, so OSSTMM is our defensible anchor for the badging
and social-engineering cases. On the cyber side it is *coarser* than ATT&CK (its "Data
Networks" lumps all IT together), so we prefer ATT&CK platforms there and fall back to OSSTMM
channels only for Physical/Human.

### 5. ISO/IEC 27005 asset types + NIST asset categorizations

**ISO/IEC 27005:2022** distinguishes **primary assets** (information and business processes)
from **supporting assets** (hardware, software, networks, personnel, site, organizational
structure) — an *asset-based risk-identification* device
(ISO/IEC 27005:2022, asset-based risk identification;
https://www.iso.org/standard/80585.html). It is current and authoritative, but it is a **GRC
risk cut**, paywalled, and every target we test is merely "a supporting asset" — **no
offensive granularity**.

**NIST asset categorizations** are the same shape from a different angle: SP 800-53 Rev 5
uses **"system element"** for a discrete system component
(https://csrc.nist.gov/pubs/sp/800/53/r5/upd1/final); **NISTIR 8011** splits asset management
into **Hardware Asset Management (HWAM, Vol 2)** and **Software Asset Management (SWAM, Vol 3)**
capabilities (https://csrc.nist.gov/pubs/ir/8011/v2/final); **CSF 2.0 `ID.AM`** is an
asset-inventory *outcome* category (https://www.nist.gov/cyberframework). All three are
inventory/assessment framings (hardware vs software vs data) — **poor fit** as an offensive
target axis, for the same reason as CIS.

---

## The physical / badging case — does OSSTMM close the gap?

**Partly — OSSTMM gives us a defensible *classification anchor* for the plane, but not an
attack *catalog*, so it is a "named but shallow" slot, not a solved one.**

- **Classification anchor: yes.** OSSTMM 3's **Physical Security** channel (and **Human
  Security** for tailgating/pretexting around badging) is an authoritative, citable home for
  a `physical-badging` target-kind. This is strictly better than the prior research's "no
  clean anchor exists" — for *what plane it is*, OSSTMM's Physical/Human channels are the
  answer, and they are peer classes to Data Networks, not an afterthought
  (https://www.isecom.org/OSSTMM.3.pdf).
- **Attack catalog: still a gap.** OSSTMM tells you the Physical channel *exists* and gives
  high-level operational-security metrics; it is **not** a badging-hardware attack playbook
  (RFID/PACS credential cloning, reader tamper, etc.), and NIST SP 800-115 **explicitly scopes
  out physical security testing**
  (https://nvlpubs.nist.gov/nistpubs/legacy/sp/nistspecialpublication800-115.pdf). So the
  *catalog* layer for badging remains hand-curated, with the assessment **oracle** drawn from
  NIST SP 800-53 **PE (Physical & Environmental Protection)** family and **SP 800-116 Rev 1**
  (PIV in PACS) — both *controls/guidance*, not attack methods
  (https://csrc.nist.gov/pubs/sp/800/53/r5/upd1/final;
  https://csrc.nist.gov/pubs/sp/800/116/r1/final).

Net: adopting OSSTMM channels upgrades badging from "gap in the taxonomy" to "authoritatively
classified plane with a first-party catalog and a NIST control oracle." Label the target-kind
**experimental/manual** and cite OSSTMM Physical + 800-53 PE, rather than overstating any
attack standard.

---

## Recommended `target_kind` model — open, RoE-declared, standard-anchored

**Model: open string, not a frozen enum.** Each engagement's `target_kind` is declared in the
Rules of Engagement and **must carry a `grounding` citation** to a class in a maintained,
offense-oriented reference. Two reference axes cover the field:

- **Cyber planes → MITRE ATT&CK platform** (Enterprise/Mobile/ICS domain).
- **Physical & Human planes → OSSTMM channel.**

The **catalog** each target-kind pulls (WSTG, CIS Benchmarks, our boundary catalog, PE
objectives) is a separate, independently extensible layer — never frozen into the enum.

### Suggested seed values (illustrative, not closed)

| `target_kind` (open key) | Grounding class (cite at intake) | Standard | Test catalog layer |
|---|---|---|---|
| `host-network` | ATT&CK platforms **Windows / macOS / Linux / Network Devices** | MITRE ATT&CK Enterprise (v17+) | NIST SP 800-115 §3–5 + specific CIS Benchmark |
| `cloud-tenant` | ATT&CK platforms **IaaS / SaaS / Identity Provider / Office Suite** | MITRE ATT&CK Enterprise | provider-specific CIS Benchmark + 800-53 |
| `container-virt` | ATT&CK platforms **Containers / ESXi** | MITRE ATT&CK Enterprise | CIS Docker/K8s Benchmark |
| `web-url` | *no ATT&CK platform* → declare as app-layer engagement; nearest ATT&CK context `SaaS`/`IaaS`/app-on-OS | MITRE ATT&CK (context) + **OWASP WSTG/ASVS** as the real anchor | OWASP WSTG v4.2 / ASVS v5.0.0 |
| `mobile-app` | ATT&CK domain **Mobile** (Android/iOS) | MITRE ATT&CK Mobile | OWASP MASVS/MASTG |
| `ics-ot` | ATT&CK domain **ICS** | MITRE ATT&CK ICS | 800-82 + ICS catalog |
| `coding-agent-sandbox` | *no external class* → first-party; ATT&CK techniques (SC-7/boundary) map, no platform | **first-party** (`catalogs/isolation-boundary.md`), built on 800-115 + ATT&CK + 800-53 | `catalogs/isolation-boundary.md` |
| `physical-badging` | OSSTMM **Physical** (+ **Human**) channel | **OSSTMM 3** | hand-curated + 800-53 PE / 800-116 oracle (experimental/manual) |
| `social-human` | OSSTMM **Human** channel | **OSSTMM 3** | 800-115 §5.3 Social Engineering + hand-curated |

Two seed values deliberately have **no clean external class** — `web-url` (ATT&CK has no
web-app platform; its real anchor is OWASP) and `coding-agent-sandbox` (nothing external
names it) — which is itself the evidence that a *frozen external enum cannot cover our field*
and the open + grounded model is the correct one.

### Intake rule (what to enforce)

At RoE time, for each target the engagement declares:
1. a free-form `target_kind` key (kebab-case),
2. a `grounding` field citing **either** an ATT&CK platform/domain **or** an OSSTMM channel
   (or an explicit `first-party` marker with justification, as for the sandbox),
3. the `test_catalog` reference(s) it will use.

This keeps us honest (every kind is traceable to a maintained standard or an explicit
first-party artifact), keeps us extensible (new kinds don't require a code/enum change), and
avoids overstating any standard's authority — no source here is a closed "offensive target
type" taxonomy, and we don't pretend one is.

---

## Full citations

- MITRE ATT&CK Enterprise matrix (platform list, verbatim): https://attack.mitre.org/matrices/enterprise/
- MITRE ATT&CK home (domains: Enterprise/Mobile/ICS): https://attack.mitre.org/
- MITRE ATT&CK Mobile matrix (Android/iOS): https://attack.mitre.org/matrices/mobile/
- MITRE ATT&CK v17 (Apr 2025) release notes — ESXi added, Network→Network Devices: https://attack.mitre.org/resources/updates/updates-april-2025/
- MITRE ATT&CK v17 overview (Medium, MITRE ATT&CK official): https://medium.com/mitre-attack/attack-v17-dfb59eae2204
- CIS Control 1 (enterprise-asset classes, verbatim scope): https://www.cisecurity.org/controls/inventory-and-control-of-enterprise-assets
- CIS Controls Assessment Specification, Control 1 (v8.1): https://cas.docs.cisecurity.org/en/latest/source/Controls1/
- CIS Control 2 (software assets): https://www.cisecurity.org/controls/inventory-and-control-of-software-assets
- CIS Control 3 (data protection): https://www.cisecurity.org/controls/data-protection
- CIS Controls v8.1 release (June 2024): https://www.cisecurity.org/about-us/media/press-release/center-for-internet-security-releases-cis-controls-v8-1-with-new-governance-recommendations
- CPE Naming Specification v2.3 (NISTIR 7695) — part = a/o/h: https://nvlpubs.nist.gov/nistpubs/legacy/ir/nistir7695.pdf
- OSSTMM 3 (ISECOM) — five channels incl. Physical/Human: https://www.isecom.org/OSSTMM.3.pdf
- ISO/IEC 27005:2022 (primary vs supporting assets): https://www.iso.org/standard/80585.html
- NIST SP 800-53 Rev 5 ("system element"; PE family): https://csrc.nist.gov/pubs/sp/800/53/r5/upd1/final
- NISTIR 8011 Vol 2, Hardware Asset Management: https://csrc.nist.gov/pubs/ir/8011/v2/final
- NIST CSF 2.0 (ID.AM asset inventory outcomes): https://www.nist.gov/cyberframework
- NIST SP 800-115 (physical testing explicitly out of scope): https://nvlpubs.nist.gov/nistpubs/legacy/sp/nistspecialpublication800-115.pdf
- NIST SP 800-116 Rev 1 (PIV in facility access — badging oracle, not attack): https://csrc.nist.gov/pubs/sp/800/116/r1/final

> Freshness watch: OSSTMM 3 (2010) and CPE 7695 (2011) are the two dated references; ATT&CK
> and CIS are actively maintained. Cite the **current** ATT&CK platform set at intake (it
> changes per release) and CIS by **specific benchmark + version**, never generically.

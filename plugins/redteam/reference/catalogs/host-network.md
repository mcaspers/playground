# Catalog: `host-network` — host, server, or network segment

For a `target_kind` whose identity is a host, virtual server, IP, or CIDR the
operator is authorized to test. Methodology, not a fixed script — the operator
turns each selected item into a concrete, non-destructive command run through the
guarded executor, only against in-scope targets.

**Backing standards.** Techniques follow **NIST SP 800-115** §3 (Review), §4
(Target Identification & Analysis), and §5 (Target Vulnerability Validation). The
**configuration-review oracle** is the **specific CIS Benchmark** for the target's
platform (cite it by exact name + version, e.g. "CIS Ubuntu 22.04 Benchmark
v2.0.0" — never "CIS" generically). Controls map to NIST SP 800-53 (SC/AC/AU/CM
families).

> Scope discipline: scan and enumerate only in-scope hosts/CIDRs from `scope.json`.
> Vulnerability *validation* (§5 — exploitation, password cracking) is intrusive
> and runs live only under an attested plan and human approval.

## Selection menu (800-115-aligned)

| Item | 800-115 § | Objective | Probe idea | Expected-secure |
|---|---|---|---|---|
| H-DISC | 4.1 Network Discovery | know the reachable surface | host/ping sweep across the in-scope range | only intended hosts respond |
| H-PORT | 4.2 Port & Service ID | no unexpected exposure | TCP/UDP port + service/version scan | only authorized services/ports open |
| H-VULN | 4.3 Vulnerability Scanning | no known-vulnerable services | authenticated/unauthenticated vuln scan | no unpatched criticals |
| H-CONF | 3.4 System Config Review | hardened configuration | compare running config to the CIS Benchmark | benchmark items pass |
| H-TLS | 3.x / SC-12 | secure transport | TLS/cipher/cert inspection on exposed services | strong TLS; valid certs |
| H-CRED | 5.1 Password Cracking | strong authenticators (authorized only) | test default/weak creds on in-scope services | no default/weak creds accepted |
| H-EXPL | 5.2 Penetration Testing | validate exploitability (intrusive) | attempt a scoped, approved exploit of a found weakness | exploit fails / control holds |
| H-LOG | 3.2 Log Review | detectability | confirm the target logs the probe activity | activity is recorded |

## Oracle & mapping
Each item becomes an SP 800-53A objective (EXAMINE the discovery facts, TEST the
probe) whose *satisfied* condition ties to a CIS Benchmark item and/or an 800-53
control (e.g. H-PORT ↔ SC-7 boundary protection; H-CONF ↔ CM-6/CM-7; H-CRED ↔
IA-5). Map probes to ATT&CK (e.g. active scanning **T1595**, exploitation of remote
services **T1210**, valid accounts **T1078**).

Sources: NIST SP 800-115 §3–5 — https://nvlpubs.nist.gov/nistpubs/legacy/sp/nistspecialpublication800-115.pdf ;
CIS Benchmarks — https://www.cisecurity.org/cis-benchmarks (cite the exact benchmark + version).

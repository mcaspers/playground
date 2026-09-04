# Catalog: `web-url` — web application / service

For a `target_kind` whose identity is a URL or web service. This catalog is the
**menu** the planner selects from; each item names a control, the attacker
objective, the black-box probe idea, and the expected-secure oracle. It is
methodology, not a fixed script — the operator turns each selected item into a
concrete, non-destructive command run through the guarded executor.

**Backing standards.** Tests are drawn from the **OWASP Web Security Testing Guide
(WSTG) v4.2** (per-test IDs `WSTG-xxxx`); the pass/fail oracle is the **OWASP
Application Security Verification Standard (ASVS) v5.0.0** verification
requirements, scaled by the target's `impact_baseline` (roughly ASVS L1/L2/L3).
NIST SP 800-115 Appendix C (Application Security Testing) corroborates.

> Scope discipline: every probe targets only in-scope hosts/paths from
> `scope.json`. Authentication testing that could lock accounts, and any
> data-modifying request, runs only if the RoE explicitly authorizes it.

## Selection menu (WSTG-aligned)

| Item | WSTG area | Control / objective | Probe idea (non-destructive) | Expected-secure |
|---|---|---|---|---|
| W-INFO | Information Gathering (WSTG-INFO) | no unnecessary surface disclosure | fingerprint tech, enumerate entry points, check headers/robots/`.git` | no sensitive files/versions exposed |
| W-CONF | Configuration (WSTG-CONF) | secure transport & config | TLS/cert check, security headers (HSTS/CSP), method enumeration | strong TLS; headers present; no dangerous methods |
| W-AUTHN | Authentication (WSTG-ATHN) | credential handling | test for weak lockout, username enumeration, default creds (authorized only) | no enumeration; lockout enforced |
| W-AUTHZ | Authorization (WSTG-ATHZ) | access control | IDOR / forced browsing to another user's object; path traversal | 401/403; no cross-tenant access |
| W-SESS | Session Management (WSTG-SESS) | session integrity | cookie flags, fixation, logout invalidation | HttpOnly/Secure/SameSite; session rotates |
| W-INPV | Input Validation (WSTG-INPV) | injection resistance | reflected/stored XSS probe, SQLi error probe (safe payloads) | input neutralized; no injection |
| W-ERRH | Error Handling (WSTG-ERRH) | no leakage via errors | trigger errors; inspect stack traces / debug info | generic errors; no internals leaked |
| W-CRYP | Cryptography (WSTG-CRYP) | data-in-transit/at-rest | check for weak ciphers, mixed content, sensitive data in URLs | strong crypto; no secrets in transit-visible places |

## Oracle (ASVS)
Write each selected item as an SP 800-53A objective whose *satisfied* condition is
the relevant ASVS v5.0.0 requirement (e.g. an authorization item is satisfied when
ASVS V-access-control requirements hold). Cite the ASVS chapter/requirement id in
the plan so an assessor can trace it.

## Mapping
Web attack surface spans several ATT&CK platforms rather than one — map individual
techniques (e.g. exploitation of public-facing app **T1190**, valid-accounts
**T1078**) and mark web-specific items grounded in OWASP rather than ATT&CK.

Sources: OWASP WSTG v4.2 — https://owasp.org/www-project-web-security-testing-guide/v42/ ;
OWASP ASVS v5.0.0 — https://owasp.org/www-project-application-security-verification-standard/ ;
NIST SP 800-115 App C — https://nvlpubs.nist.gov/nistpubs/legacy/sp/nistspecialpublication800-115.pdf

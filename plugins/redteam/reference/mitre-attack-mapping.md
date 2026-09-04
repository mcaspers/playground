# MITRE ATT&CK mapping

Maps common test classes to ATT&CK tactics/techniques so findings roll up into an
ATT&CK-style coverage view. The adversary depends on the engagement's threat model
(external attacker, authenticated user, insider) — established at intake. This table
is a **starting cross-map**; the planner cites the specific technique(s) each probe
exercises for the target at hand.

**Honesty note.** ATT&CK Enterprise is written for corporate networks/endpoints.
Some techniques map cleanly; others are used **by analogy** and are marked
_(analogy)_ — cite the technique to communicate *intent*, not to imply the
enterprise detection/mitigation applies verbatim. ATT&CK also has no first-class
web-application platform (web maps to individual techniques, grounded in OWASP) and
no Physical/Human plane (use OSSTMM channels there — see `target-kinds.md`). Cite the
**current** ATT&CK platform set; MITRE revises it per release.

| Test class | Tactic | Technique (ID) | Notes |
|---|---|---|---|
| **Recon / discovery** | Reconnaissance (TA0043) / Discovery (TA0007) | Active Scanning (**T1595**), Gather Victim Host/Network Info (**T1590/T1592**), Network Service Discovery (**T1046**) | Phase 1/3 surface mapping |
| **Public-facing exploitation** | Initial Access (TA0001) | Exploit Public-Facing Application (**T1190**) | web/host exposed-service break |
| **Valid accounts / auth** | Initial Access / Defense Evasion | Valid Accounts (**T1078**) | default/weak/reused creds |
| **Network boundary bypass** | Command & Control (TA0011) | Proxy — Multi-hop/External (**T1090**), Non-Standard Port (**T1571**), DNS/Fallback (**T1071.004 / T1008**) | egress/isolation escape |
| **Credential access** | Credential Access (TA0006) | Unsecured Credentials (**T1552**), Credentials from Password Stores (**T1555**) _(analogy)_ | real secret vs placeholder |
| **Exfiltration** | Exfiltration (TA0010) | Exfil Over Alt Protocol (**T1048**), Over C2 (**T1041**), Over Web (**T1567**) | data leaves via a bypass |
| **Privilege escalation / escape** | Privilege Escalation (TA0004) | Escape to Host (**T1611**), Exploitation for Priv Esc (**T1068**) | container/VM escape, host takeover |
| **Discovery beyond scope of role** | Discovery (TA0007) | File & Directory Discovery (**T1083**), Permission Groups (**T1069**) | enumerate beyond intended access |
| **Attribution / evasion** | Defense Evasion (TA0005) | Masquerading (**T1036**), Indicator Removal (**T1070**), Impair Defenses (**T1562**) | forge identity, suppress logging |
| **Availability / DoS** | Impact (TA0040) | Endpoint DoS (**T1499**), Resource Hijacking (**T1496**) _(analogy)_ | wedging, exhaustion |

## How the operator uses this
Every probe result line carries its primary technique id, so findings roll up into
a per-technique coverage table: which techniques were attempted, which the target
defeated, which produced findings. Keep the _(analogy)_ marks in the report — an
auditor should see exactly where the mapping is literal and where it is illustrative.

Source: MITRE ATT&CK — https://attack.mitre.org/ (Enterprise/Mobile/ICS; cite the
current platform set at intake).

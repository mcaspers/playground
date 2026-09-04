# Scenario library

Fallback scenario families for when outage research is unavailable, returns thin
results, or the user declines research. A researched scenario grounded in a real
published postmortem is always preferred. These families are starting
structures, not finished scenarios — the orchestrator still tailors every one to
the declared stack, services, dependencies, and tier.

Each family lists the stack signals that make it relevant, the decisions it
forces, and the standards it exercises.

**Select exactly one family per tabletop.** These are a menu, not a sequence. A
single exercise runs one scenario from one family, developed to the tier's
depth. Never blend two families into one exercise or run a second family after
the first — that is a separate tabletop with its own package and its own
after-action report. Choose the family whose stack signals best match the
Organization Recovery Profile, and record the runners-up as candidates for the
organization's next exercise.

## A. Cloud region or availability zone failure

Relevant when: workloads concentrated in one cloud region, single-AZ databases,
regional managed services, or a disaster recovery design that has never been
failed over in anger.

Forces decisions on: declaring a disaster versus waiting for the provider,
failover authority and its reversibility, whether the standby region is actually
current, dependencies that silently remain in the failed region, data
divergence between regions, and when to fail back.

Exercises: SP 800-34 Sections 4.1-4.3; SP 800-53 CP-2, CP-7, CP-9, CP-10;
CSF 2.0 RC.RP, ID.AM.

Common inject arc: elevated error rates → provider acknowledges a regional issue
with no ETA → failover decision → standby region works but a dependency is still
regional → provider recovers → failback risks a second outage.

## B. Ransomware or destructive attack recovery

Relevant when: any organization with backups, and especially where backups share
credentials or network reachability with production.

Forces decisions on: backup integrity and whether backups are themselves
encrypted or deleted, restore sequencing, how far back to restore and how much
data to accept losing, rebuilding clean versus restoring dirty, and the point at
which the organization admits recovery will take days rather than hours.

Exercises: SP 800-34 Sections 4.2-4.3; SP 800-53 CP-9, CP-10, CP-6.

Common inject arc: systems unavailable → backups found encrypted or the backup
account compromised → an older offline copy exists but is weeks stale → partial
restore succeeds → restored system reinfects or fails validation.

**Scope boundary:** this family sits deliberately on the seam with the
`incident-tabletop` plugin. Keep the focus on restoration — backup integrity,
sequencing, data loss, validation, and service return. Containment, evidence
preservation, threat actor behavior, breach notification, and law enforcement
belong to an incident response exercise. When participants pull hard in that
direction, note it as a finding and recommend an incident response tabletop
rather than converting this exercise into one.

## C. Data corruption, bad deploy, or accidental deletion

Relevant when: the organization ships its own software, runs migrations, or has
administrative delete capability over production data.

Forces decisions on: detecting corruption that replication has faithfully
propagated, whether point-in-time recovery exists and how far back it reaches,
rolling back versus fixing forward, the blast radius of a partial restore,
reconciling data written after the corruption began, and telling customers their
data was wrong rather than merely unavailable.

Exercises: SP 800-34 Section 4.2; SP 800-53 CP-9, CP-10, SI-7.

Common inject arc: a migration completes successfully → support reports wrong
data → corruption predates the last several backups → point-in-time recovery
loses hours of legitimate writes → customers have already acted on bad data.

This family reliably exposes the difference between backup and recoverability.

## D. Critical third-party or SaaS dependency outage

Relevant when: material SaaS dependencies, payment processors, identity
providers, managed databases, CDN, DNS, or an MSP holding operational control.

Forces decisions on: acting without information the vendor will not provide,
whether a documented workaround exists and whether anyone has performed it,
contractual position versus practical dependence, communicating about an outage
the organization does not control and cannot fix, and when to invoke an
alternative provider.

Exercises: SP 800-34 Section 3.4; SP 800-53 CP-2, CP-8; CSF 2.0 ID.BE, RC.CO;
ISO 22301 clause 8.4.

Common inject arc: a core vendor degrades → status page lags reality → no ETA →
the documented workaround has never been tested → customers demand answers the
organization does not have → the vendor restores but with data gaps.

## E. Facility, power, or physical site loss

Relevant when: on-premises infrastructure, colocation, office-dependent
operations, manufacturing, clinical or laboratory environments, or anywhere
staff must be physically present.

Forces decisions on: safety before systems, whether staff can work at all,
alternate site activation, what is physically irreplaceable, the difference
between an equipment outage and a building becoming inaccessible for weeks, and
insurance engagement.

Exercises: SP 800-34 Sections 3.4, 4.1-4.3; SP 800-53 CP-6, CP-7, PE-9 through
PE-15; ISO 22301 clause 8.4.

Common inject arc: power or environmental failure → generator or UPS behaves
differently than assumed → building declared unsafe for an extended period →
alternate site lacks current data or licenses → staff cannot reach either site.

## F. Access, credential, or certificate loss

Relevant when: SSO dependencies, certificate-dependent services, small teams
with concentrated administrative access, or any environment where recovery tools
sit behind the system that is down.

Forces decisions on: recovering when the recovery tooling is itself
inaccessible, break-glass credential availability and whether anyone has tested
them, circular dependencies between identity and everything else, and the
authority to bypass normal access control under pressure.

Exercises: SP 800-34 Section 4.1; SP 800-53 CP-2, CP-10, IA-5, AC-2.

Common inject arc: certificate expiry or identity provider failure → the runbook
lives in a system requiring that identity provider → break-glass credentials are
in a vault behind the same SSO → the person who knows is unreachable → recovery
proceeds only after an out-of-band improvisation.

This family is the highest-value Tier 1 scenario for many small organizations,
because it requires no attacker and no disaster.

## G. Network, connectivity, or DNS failure

Relevant when: multi-site connectivity, VPN-dependent access, self-managed DNS,
CDN dependence, or a single ISP.

Forces decisions on: diagnosing whether the fault is internal or external,
propagation delay limiting how fast any fix takes effect, communicating when the
communication channels are themselves affected, and the difference between the
service being up and customers being able to reach it.

Exercises: SP 800-34 Section 3.4; SP 800-53 CP-8, CP-2; CSF 2.0 RC.CO.

Common inject arc: customers report unreachability while internal monitoring
shows healthy → DNS or routing misconfiguration identified → the fix propagates
slowly → the status page is on the affected domain → the fix is partially wrong.

## H. Key person or capability unavailability

Relevant when: concentrated knowledge, small teams, undocumented systems,
contractor dependence, or recent or upcoming departures.

Forces decisions on: recovering a system only one person understands, whether
documentation matches reality, escalation when the escalation path is the
missing person, and the honest cost of undocumented capability.

Exercises: SP 800-34 Section 3.5; SP 800-53 CP-2, CP-3; ISO 22301 clause 8.4.

Common inject arc: an outage begins while the one person who knows the system is
unreachable → the runbook is outdated or absent → a workaround is attempted from
first principles → it extends the outage → the person returns to find the state
changed.

Handle with care. Keep the absent person generic and avoid resemblance to a real
current employee.

## Scenario safety rules

These apply to every family and every tier.

- The scenario is fictional. Say so at the start and whenever a participant
  appears to believe a real outage is underway.
- Never instruct participants to touch, alter, fail over, restore, restart, or
  shut down a live system, and never generate a command intended for real
  execution. If a participant proposes an action, they describe it; they do not
  perform it. This matters more here than in a security exercise, because
  recovery actions look routine and are easy to run by reflex.
- Never send a real message, email, page, status-page update, or ticket to a
  real person or customer as part of the exercise. Injects are delivered in-chat
  by the facilitator only.
- Never post to, or draft into, a real status page or customer communication
  channel. Draft communications stay in chat as exercise artifacts.
- Do not use a real named vendor as the failed party unless the user explicitly
  chooses that framing. Use a generic placeholder such as "your payment
  processor" by default. Published provider postmortems may still be cited as
  precedent in facilitator notes.
- Where a real outage precedent inspires the scenario, fictionalize the affected
  organization. Cite the precedent in facilitator notes and in the after-action
  report, not as an accusation inside the narrative.
- For key-person scenarios, keep the absent individual anonymous and generic.

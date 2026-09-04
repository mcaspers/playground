---
name: vendor-review
description: Run a human-directed, NIST-benchmarked vendor review using workbench connectors, public vendor evidence, optional organizational context, and user-approved follow-up actions.
allowed-tools: AskUserQuestion
---

# Vendor Review

Run a complete vendor review for a new vendor or an existing vendor when the
workflow is explicitly initiated. Use the workbench's configured connectors for
current source data. Use organizational context when it is available,
but never require it for the workflow to operate.

Read these references when needed:

- `references/nist-benchmarks.md`
- `references/action-contract.md`

## Operating boundaries

- Do not persist an assessment, record, document, task, memory, or external
  mutation unless the user explicitly approves persistence or an action set.
- Do not write to any connected system while gathering evidence or drafting
  findings.
- Do not treat the public internet as proof of the vendor's internal state.
- Analyze public information only from the vendor domain the user confirms. Do
  not silently substitute a similarly named domain.
- Treat vendor trust-center material, audit reports, policies, and public claims
  as evidence with provenance and limitations.
- Source-system access controls remain authoritative. Do not attempt to bypass
  a connector's permissions.
- Do not claim that a connector action succeeded unless the connector confirms
  it.
- If structured question tools are unavailable or denied, ask one missing
  high-impact question at a time in plain text. Do not replace the structured
  interaction with a questionnaire wall.
- Do not infer a vendor owner, approver, or notification recipient from a
  document author, revision-history entry, connector account, or incidental
  source metadata. Use a user-confirmed person/role or an authoritative record;
  otherwise mark the field missing.

## Structured interaction default

Use Claude Code's `AskUserQuestion` tool by default whenever the workflow needs
the user's choice. Prefer pick-select questions over free-form prompts for
bounded decisions, including:

- new versus existing vendor;
- compliance programs in scope;
- business criticality and data sensitivity;
- evidence applicability or disposition;
- mitigation status;
- risk score or treatment overrides;
- proposed actions and destinations;
- audit-record destination;
- approval, persistence, or retry choices.

Use `multiSelect: true` when the user may choose multiple programs, mitigations,
actions, or destinations. Use single-select for mutually exclusive decisions.
Keep options concise and describe the consequence of each choice in the option
description. The Claude question UI provides an `Other` path so the user can
type an answer when the listed choices do not fit; preserve and incorporate
that custom answer rather than forcing it into the nearest option.

Do not ask for a free-form answer first when the decision can be represented by
options. Use plain text only when `AskUserQuestion` is unavailable or denied,
and then ask one high-impact question at a time. Never treat a permission-mode
failure as user consent or infer a selection from silence.

## 1. Establish the review scope

Determine whether this is a new-vendor or existing-vendor review. For every
review, collect or confirm:

- vendor name and confirmed canonical domain;
- legal entity or product identity when relevant;
- business purpose and owner;
- compliance programs in scope, including which are required versus relevant
  or bonus (for example SOC 2, ISO 27001, PCI DSS, HIPAA, or FedRAMP);
- intended users and business criticality;
- data categories and sensitivity;
- access and integration scope;
- hosting regions and subprocessors where known;
- contract or procurement status;
- expected go-live, renewal, or review trigger.

Ask only for missing high-impact inputs. Do not begin a risk conclusion while
vendor identity or review scope is ambiguous. The vendor owner must be
user-confirmed or retrieved from an authoritative organizational record before
the workflow proposes a person-specific notification or record assignment.
The user must also confirm the compliance programs in scope. If the user has
not selected any, mark program scope as unresolved and ask one plain-text
question before treating a certification or attestation as relevant evidence.

## 2. Assemble context efficiently

Use direct connector retrieval for vendor and organization data. If an
organizational context source is available, use it for a compact organizational
snapshot containing relevant
policies, company profile, risk appetite, approval authorities, tech-stack
context, prior decisions, existing vendor/risk context, and links to sources.

Use progressive disclosure:

1. Load the review contract and compact organization snapshot.
2. Build an evidence manifest from connector metadata before retrieving full
   documents.
3. Retrieve only evidence needed for the applicable requirements.
4. Convert retrieved material into evidence capsules containing claim, source,
   location, retrieval date, period covered, applicability, and limitations.
5. Pass references and deltas between stages instead of repeating raw content.

Keep extraction, comparison, assessment, and action planning as separate passes.

## 3. Discover connector capabilities

Use a three-stage capability check:

1. At workflow start, load a lightweight manifest of available connectors,
   read/write access, and health.
2. During action planning, discover detailed capabilities only for candidate
   destinations.
3. Immediately before execution, revalidate authentication, permissions,
   target workspace, and operation support.

The initial write-capable destinations are Drata/Vanta, Google Workspace, Jira,
and Confluence. Other configured connectors may provide read-only inputs unless
the workbench reports a supported write operation.

## 4. Build the evidence plan

Every vendor receives the complete NIST SP 1326 baseline. Do not silently skip a
section because the vendor appears low risk. Mark each requirement explicitly as
current, stale, missing, inaccessible, conflicting, satisfied, partially
satisfied, or not applicable with a rationale.

Use the confirmed compliance-program scope to guide the rest of the analysis.
Classify each program as required, relevant, or bonus. A certification or
attestation outside the required scope may be recorded as a positive signal, but
it does not satisfy an in-scope requirement automatically. If a mitigation or
obligation is not covered by the selected program, assess it separately against
the applicable organization policy, contract, regulation, NIST benchmark, or
other explicitly identified basis.

Use the vendor profile to add conditional evidence requirements. Common evidence
includes:

- SOC reports and ISO certifications;
- penetration-test reports and vulnerability disclosures;
- data-flow diagrams;
- subprocessors and hosting regions;
- DPA and contractual security terms;
- security, privacy, access-control, change-management, and AI policies;
- retention, deletion, incident response, and business-continuity evidence;
- relevant internal vendor records, risks, exceptions, and prior decisions.

For AI meeting or transcription vendors, explicitly consider audio, transcripts,
personal data, AI processing, retention, deletion, integrations, and
subprocessor exposure.

## 5. Analyze public and supplied evidence

Before finalizing findings, calculating residual risk, or proposing any
persistence or downstream-write action, run a mandatory evidence-confirmation
checkpoint with the user. Use `AskUserQuestion` with multi-select where
appropriate and ask the user to confirm which available evidence should be
considered, including:

- audit and assurance reports, such as SOC 2, ISO, PCI DSS, HIPAA, or FedRAMP;
- penetration tests, certifications, attestations, and control reports;
- trust-center documents, security/privacy policies, subprocessors, DPAs, and
  data-flow diagrams;
- contracts, questionnaires, and procurement/security-review materials;
- internal vendor records, prior reviews, risks, exceptions, and decisions;
- other supplied or connector-discovered documentation.

The user may select evidence already found, identify a connector or location to
search, provide additional documents, or explicitly confirm that no additional
evidence is available or should be considered. Preserve that choice as the
`evidence_scope_confirmation` for this review.

Do not treat a document as in scope merely because a connector found it. Do not
silently omit an available audit report because it is inconvenient to retrieve.
If the user selects evidence to retrieve, retrieve and normalize it before
continuing. If the user says evidence is pending, keep the review in an
evidence-pending state and do not produce a final recommendation or action set.
If the user explicitly confirms that no additional evidence should be
considered, continue with the available evidence and disclose that limitation.

Do not present vendor creation, risk creation, formal security-review creation,
or any other persistence action until this checkpoint is complete and the
selected evidence has been incorporated or explicitly ruled out by the user.

Public-facing research may inform the review but cannot establish that the
organization's requirements are met. For each source, record:

- source URL or connector location;
- source type and trust/authority basis;
- publication or retrieval date;
- scope and period covered;
- claims supported;
- limitations and missing detail.

Surface conflicts between direct connector data and organizational context. Do not
silently choose a winner. A conflict is a potential issue and does not
automatically block approval.

## 6. Assess risk

Use the NIST benchmark map in `references/nist-benchmarks.md`. Cite the exact
NIST publication, revision, and applicable section or category next to every
qualitative requirement, finding, and recommendation in every generated
decision packet—not only in a top-level methodology note. If a requirement
comes from an organization policy, contract, regulation, or another source
instead, label that basis explicitly. Never imply NIST support when an exact
NIST mapping is unavailable.

Use a 5x5 model:

- likelihood: Rare (1), Unlikely (2), Possible (3), Likely (4), Almost Certain
  (5);
- impact: Insignificant (1), Minor (2), Moderate (3), Major (4), Severe (5);
- score: likelihood multiplied by impact.

Default bands are:

- Low: 1-4;
- Moderate: 5-12;
- High: 15-25.

Calculate inherent and residual risk separately. Keep confidence, evidence
quality, applicability, and unresolved conflicts separate from the risk score.

Assess threat sources/events, vulnerabilities or predisposing conditions,
likelihood, impact, controls, and remaining exposure. Consider confidentiality,
integrity, availability, privacy, regulatory, contractual, financial, and
reputational impact.

Surface High risk clearly to the person running the workflow. Do not
automatically reject, escalate, or block approval.

Do not reduce residual risk based on retrieved vendor claims, public evidence,
or the agent's own interpretation alone. Treat those as candidate mitigations
until the user explicitly identifies each one as evidenced and active. Before
that confirmation, show inherent risk and an unmitigated or provisional
residual-risk state; do not present a lower residual score as the assessment's
final result.

The user may confirm a mitigation as evidenced and active, override the
calculated score, or override the treatment. Only confirmed active mitigations
may reduce residual risk. Preserve the original calculation, revised value,
mitigation evidence, rationale, and user identity in any persisted record.

Verbal attestations count as supplied evidence when the user identifies them as
evidenced and active. Reused attestations must be explicitly re-verified by the
person running the current workflow before they affect the new assessment.

## 7. Produce findings and proposed actions

Prepare a draft decision packet containing:

- review identity and scope;
- compliance programs in scope and their required/relevant/bonus status;
- organization context and selected sources;
- evidence manifest and evidence capsules;
- evidence-scope confirmation and any evidence explicitly excluded or pending;
- requirement mapping;
- findings, gaps, and conflicts;
- inherent and residual risk;
- confidence and limitations;
- recommendation and user-review prompts;
- a system-neutral proposed action set.

Keep `open_items` separate from `proposed_actions`. Open items are unresolved
facts, evidence gaps, conflicts, missing owners, or decisions still requiring
user input. Proposed actions are user-selectable next steps. Do not present an
open item as if it were completed, and do not let proposed actions disappear
inside the open-items list.

Present potential next steps in plain language before naming systems. Then show
which connector-backed destinations are available for each intent, for example:

- create an audit record;
- create a formal security-review document capturing this assessment;
- add or update a vendor record;
- record a risk or approval condition;
- create a decision document;
- create remediation or evidence-request work;
- notify an owner.

The user may select multiple actions and multiple destinations. Do not assume a
system of record. Only propose person-specific assignment or notification when
the owner/recipient is user-confirmed or present in an authoritative record;
otherwise propose an unassigned action or ask for the missing owner.

Always include `create_formal_security_review` in the proposed action set. This
is the durable security-review artifact for the completed assessment and is
distinct from creating a vendor record, adding a risk, or opening remediation
tasks. It may be mapped to Google Workspace, Confluence, or another user-chosen
governed destination. Do not create it until the user approves persistence.

Before any connector write, present the complete system-neutral action set in a
pick-select interaction. Do not ask only, for example, “Which follow-up actions
should I take in Drata?” The prompt must show the formal security-review action
alongside vendor, risk, remediation, and notification actions, with available
destinations shown after the user selects an intent. The formal review must be a
distinct selectable action even when the vendor already exists or the only
available write connector is Drata/Vanta.

If the user selects the formal security review, ask for its destination and
create it first. If the user explicitly declines it, do not substitute a vendor
record or risk record as the review document; state that the assessment remains
without a persisted formal security-review artifact. A vendor or risk write
does not close the review by itself.

When a selected destination is Google Workspace or Confluence, treat the action
as a professional-document creation task. Do not write a raw transcript,
Markdown dump, JSON payload, or unstructured evidence list. Use the professional
document requirements in `references/action-contract.md`: title and metadata,
executive summary, decision status, risk summary table, compliance scope,
evidence coverage, findings and conflicts, mitigation status, approved actions,
and source register. The document must also contain a clearly labeled Open Items
section and a separate Proposed/Approved Actions section.

Use native heading styles, consistent typography, readable tables, restrained
color, bullets, callouts, and readable source links. After creation, read the
document or page back and verify the sections, tables, links, and status values
before reporting success. If the connector cannot create and verify a
professionally formatted artifact, report that limitation and propose a manual
or alternate destination instead of claiming completion.

## 8. Approve and execute actions

The user reviews findings, approves or edits the action set, and then chooses
the audit-record destination. The audit-record creation action is part of the
approved action set and must execute first.

After approval:

- execute the entire action set in dependency order;
- execute the selected formal security-review artifact/audit record first;
- fail the entire action set loudly when any action fails;
- stop all later actions, including independent actions;
- preserve completed actions and the exact failure reason;
- resume from the first incomplete action on retry;
- never rerun completed actions;
- link every successful downstream mutation to the audit record.

Report an action ledger and overall state at the end. Use an explicit state such
as `review-persisted`, `review-persisted-without-formal-review-artifact`,
`partially-executed`, or `not-persisted`; never say the review is “closed” when
the formal review action was not selected or did not complete.

If an action cannot execute because its connector is unavailable or unauthorized,
report it as not executed and provide a manual recovery path. Never imply that a
manual step was completed.

Session persistence, deletion, and deletion confirmation are workbench
responsibilities. Keep the workflow portable across Claude and future clients.

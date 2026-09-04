# Vendor-review action contract

The skill proposes action intents first and resolves them to connector-specific
operations only after the user approves the action set.

## Action intents

- `create_audit_record`
- `create_formal_security_review`
- `create_or_update_vendor`
- `create_or_update_risk`
- `create_decision_document`
- `create_remediation_task`
- `request_follow_up_evidence`
- `notify_owner`

## Action fields

Each proposed action should identify:

- `action_id`
- `intent`
- `purpose`
- `candidate_destinations`
- `required_inputs`
- `depends_on`
- `reversible` or `irreversible` behavior
- `approval_required`
- `audit_record_link`
- `presentation_requirements` when the destination is a document or page

Every completed vendor review must propose `create_formal_security_review` as
an action, even when no vendor or risk record exists yet. This action preserves
the formal security-review outcome, evidence coverage, unresolved items,
decision, and approved follow-up actions. It is still ephemeral until the user
explicitly approves persistence.

When the formal security review is created in Google Workspace or Confluence,
that artifact fulfills the audit-record requirement for the review. Do not
create a second generic audit record unless the user explicitly selects both.

## Professional document requirement

Actions that create a Google Doc, Confluence page, or other human-facing audit
record must create a polished deliverable, not a raw transcript, Markdown dump,
JSON payload, or unstructured evidence list.

At minimum, the document should contain:

1. a clear title and vendor/review metadata, identifying the artifact as a
   formal security review;
2. an executive summary and decision status;
3. a concise risk summary table showing inherent risk, residual risk, confidence,
   and open conditions;
4. a scope and compliance-program section;
5. an evidence coverage table with status, source, date, and limitation;
6. findings and conflicts with NIST/source traceability beside each item;
7. confirmed mitigations and their evidence state;
8. separate sections for unresolved items and proposed/approved actions;
9. the approved action set with owners, destinations, and status;
10. a source register or appendix with readable links.

Use native heading styles, consistent typography, restrained color, readable
table widths, clear table headers, bullets for short lists, and callouts for
high-risk or unresolved items. Do not place Markdown table pipes, raw JSON,
terminal transcripts, or internal reasoning in the finished document.

After creation, read the destination back and verify that the expected sections,
tables, links, and status values are present and readable. Do not report a
formatted-document action as successful based only on the write response.

## Execution rules

- The user approves the action set before any external write.
- The user must first complete the evidence-scope confirmation checkpoint. Do
  not present persistence or downstream-write actions before the user confirms
  which audit reports and supporting documentation should be considered, or
  explicitly confirms that no additional evidence is available or in scope.
- Before any external write, present the complete system-neutral action set in a
  selection prompt. Do not narrow the prompt to one connector or one action
  type merely because the first available write is in Drata/Vanta.
- The action set must include `create_formal_security_review` as a distinct
  selectable action with its candidate destinations. If the user declines it,
  record that choice in the ephemeral run state and clearly state that no
  formal security-review artifact will be persisted.
- The user chooses the audit-record destination after reviewing findings and
  approving the action set.
- If selected, create the formal security-review artifact/audit record first.
- Do not report the review as closed merely because a vendor or risk record was
  created. Report each action's status and the overall persistence status.
- Fail the entire action set loudly if any action fails.
- Do not continue independent actions after a failure.
- Resume from the first incomplete action on retry.
- Never rerun completed actions.
- Preserve the error, attempted operation, connector, and recovery guidance.
- Do not claim an action ran when the connector was unavailable or unauthorized.

## Initial write destinations

- Drata/Vanta: vendor and risk records, where the configured connector supports
  the operation.
- Google Workspace: audit or decision documents.
- Confluence: audit or decision pages.
- Jira: remediation, evidence-request, or follow-up issues.

The workflow does not assume that any one destination is the organization's
system of record.

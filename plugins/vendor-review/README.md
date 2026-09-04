# Vendor Review

The `vendor-review` plugin guides a human-directed vendor assessment in Claude
Code. It uses the workbench's configured connectors for current source data and
uses organizational context when available.

The plugin does not bundle credentials, MCP endpoints, or a system of record.
It proposes system-neutral next steps and writes to Drata/Vanta, Google
Workspace, Jira, or Confluence only after the user approves the action set and
chooses the destination for the audit record.

## Scope

- NIST SP 1326 is the default vendor due-diligence benchmark.
- NIST SP 800-30 Rev. 1, CSF 2.0 GV.SC, and SP 800-161 Rev. 1 provide supporting
  risk-assessment and supply-chain guidance.
- Every new vendor and every explicitly initiated existing-vendor review uses
  the same baseline assessment.
- Reviews are ephemeral until the user explicitly approves persistence.

## Claude Code usage

Install the marketplace locally, then install the plugin:

```text
/plugin marketplace add mcaspers/playground
/plugin install vendor-review@playground
```

Run it with:

```text
/vendor-review:vendor-review
```

## License

MIT — see [LICENSE](LICENSE). Use, modify, and redistribute it as you see fit;
keep the copyright and permission notice in copies or substantial portions.

### Third-party references

The plugin cites public standards; it does not reproduce them. NIST SP 1326,
SP 800-30 Rev. 1, SP 800-161 Rev. 1, and CSF 2.0 are US Government works and are
not subject to domestic copyright protection. Anyone extending the plugin who
pastes in text from another source should check the terms attached to it.

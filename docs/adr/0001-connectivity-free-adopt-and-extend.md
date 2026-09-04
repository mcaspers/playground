# Plugins are connectivity-free and extended by the adopter's own connectors

Every plugin in this marketplace is a self-contained adaptation of a workflow into the
Claude / Claude Code ecosystem: it assumes no external connectivity and bundles no
credentials, MCP endpoints, or system of record. We chose this over shipping plugins
with built-in integrations because it keeps them portable, credential-free, and safe to
install anywhere — the plugin is a complementary base layer, and the adopter bridges it
to their own systems (Drata/Vanta, Google Workspace, Jira, Confluence, …) by layering in
their own connectors and MCPs.

## Consequences

- A plugin proposes system-neutral next steps; the adopter's connectors carry them out,
  only after the adopter approves the action and chooses the destination.
- Every plugin README should state its extension seams rather than assume a system of
  record. New plugins are checked against this axiom: if a plugin can only work with a
  specific external service wired in, it does not belong here as written.
- See [`docs/extending-plugins.md`](../extending-plugins.md) for the adopter-facing
  how-to.

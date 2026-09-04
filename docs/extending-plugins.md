# Extending a plugin with your own connectors

Every plugin in this marketplace ships **connectivity-free** — it assumes no external
systems and bundles no credentials (see
[`docs/adr/0001-connectivity-free-adopt-and-extend.md`](adr/0001-connectivity-free-adopt-and-extend.md)).
That is by design: the plugin is a base layer you adopt and then **bridge to your own
systems** by layering in connectors and MCPs. This guide shows how.

## The pattern

1. **Install the plugin** from the marketplace and run it once as-is. Every plugin works
   standalone — it will propose system-neutral next steps and produce its output in the
   session.
2. **Add your connector or MCP.** Wire in the MCP server (or built-in connector) for the
   system you want the plugin to reach — your GRC platform, your document store, your
   issue tracker. This is a change to *your* Claude Code configuration, not to the plugin.
3. **Let the plugin drive the connector.** With the connector available in the session,
   the plugin's proposed actions can now be carried out against your system. The plugin
   still proposes; your connector executes; you approve the destination.

The plugin never assumes the connector is present, so nothing breaks if it isn't — you
simply get the standalone behaviour.

## Worked examples

### `vendor-review` + a GRC connector (Drata / Vanta)

Run `/vendor-review:vendor-review` to conduct the assessment. With a Drata or Vanta MCP
connected, the review's approved action set can **create or update vendor records** in
that system of record instead of ending as session output. Without it, the review is
ephemeral until you copy it somewhere yourself.

### The tabletops + a document store (Google Drive / Confluence)

`incident-tabletop` and `recovery-tabletop` produce an internal after-action report and
an external exercise summary. With a Google Drive or Confluence connector, those reports
can be **filed directly into your document store** for auditors and assessors. Without a
connector, they are produced in-session for you to place manually.

### Any plugin + your issue tracker

A plugin that surfaces findings or follow-ups can hand them to an issue tracker through a
`gh`/GitHub or Jira connector, turning recommendations into tracked work.

## Guardrails to keep

When you extend a plugin, preserve the properties the base layer guarantees:

- **Approval before persistence.** A plugin proposes; a write to your system of record
  should happen only after you approve the action and choose the destination.
- **No credentials in the plugin.** Keep secrets in your connector/MCP configuration,
  never added into the plugin itself.
- **Standalone still works.** Don't make a plugin *require* your connector; the
  connectivity-free base behaviour is the contract.

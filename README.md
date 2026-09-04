# playground

My personal playground of plugins that I have found useful in my day-to-day.

## Design principle

Every plugin here is a **self-contained adaptation of a workflow into the Claude /
Claude Code ecosystem**. A plugin assumes no external connectivity and bundles no
credentials, MCP endpoints, or system of record — it is a complementary base layer,
not an integration.

You extend a plugin by **adopting it and layering in your own connectors and MCPs** to
bridge it to your systems: a Drata or Vanta MCP so `vendor-review` can create or update
vendor records, a Google Drive connector so the tabletops can file their exercise
reports, and so on. The plugin proposes the work; your connectors carry it out.

See [`docs/extending-plugins.md`](docs/extending-plugins.md) for how, and
[`docs/adr/0001-connectivity-free-adopt-and-extend.md`](docs/adr/0001-connectivity-free-adopt-and-extend.md)
for why.

## Plugin marketplace

This repo doubles as a Claude Code plugin marketplace
([`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json)).

Add it, then install any of the plugins:

```bash
/plugin marketplace add mcaspers/playground
```

| Plugin | Category | What it does |
| --- | --- | --- |
| [`incident-tabletop`](plugins/incident-tabletop) | GRC | Moderator-led incident response tabletop exercises (NIST SP 800-84 / 800-61r3). |
| [`recovery-tabletop`](plugins/recovery-tabletop) | GRC | Disaster recovery & service outage tabletop exercises (NIST SP 800-84 / 800-34r1). |
| [`vendor-review`](plugins/vendor-review) | GRC | Human-directed, NIST-benchmarked vendor reviews. |
| [`redteam`](plugins/redteam) | Security | Multi-agent black-box adversarial testing of any authorized target — network, host, web app, or bespoke system (NIST SP 800-115 + MITRE ATT&CK). |
| [`agent-readiness`](plugins/agent-readiness) | Agent Experience | Reads a codebase and interviews its owner, then hands back an opinionated plan of the documentation an agent needs to work there. |

Each plugin lives under [`plugins/`](plugins) with its manifest at
`plugins/<name>/.claude-plugin/plugin.json`.

# playground

My personal playground of plugins that I have found to be useful in my day-to-day.
You can extend these by adopting them and layering in your own set of connectors
to complement each plugin. For examply, by using a Drata or Vanta MCP to create
or update vendor records using the vendor-review plugin, integrating with 
google drive to create tabletop exercise reports, etc.

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

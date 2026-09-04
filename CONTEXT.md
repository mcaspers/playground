# Playground Marketplace

A Claude Code plugin marketplace: a catalog of installable plugins, indexed by `.claude-plugin/marketplace.json`.

## Language

**Marketplace**:
This repo as a whole — the catalog of plugins a user adds with `/plugin marketplace add`. Indexed by `.claude-plugin/marketplace.json`.
_Avoid_: registry, store, catalog

**Marketplace name**:
The marketplace's own identifier, the `name` field in `.claude-plugin/marketplace.json` (here: `playground`). It is the `@<name>` suffix in `/plugin install <plugin>@<name>` — the name of the marketplace, never the repo or the plugin.
_Avoid_: repo name, slug

**Plugin**:
The single installable unit of the marketplace. Lives under `plugins/<name>/`, described by its manifest, and the only thing a user installs. Bundles whatever skills, agents, and commands it needs internally.
_Avoid_: skill, package, extension

**Category**:
The marketplace grouping a plugin belongs to (e.g. `GRC`, `Security`, `Agent Experience`).
_Avoid_: tag, group, type

**Policy**:
The install-time rules declared for a plugin in the marketplace index (e.g. `installation`, `authentication`).
_Avoid_: rule, setting, config

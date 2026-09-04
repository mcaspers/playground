# agent-readiness

Take a codebase from "an agent struggles here" to "an agent works here" — using **agent
readiness** as the measurable baseline for fast human onboarding. Where an agent can
operate a repo, it can onboard a newcomer; where the agent is blind, the newcomer stays
lost. So "make this repo work for an agent" and "make it easy to onboard onto" are one
goal, not a trade-off.

## What it does

`/agent-readiness` runs an interactive session that:

1. **Scans** the repo (structure, stack, and the context docs that already exist —
   `AGENTS.md`, `CLAUDE.md`, `CONTEXT.md`, READMEs, ADRs — treated as claims to verify,
   not ground truth).
2. **Interviews** the person who knows it — homework-first, adapting to whether they're
   a veteran, a newcomer, or somewhere in between, and reading code mid-conversation
   whenever that's cheaper than pressing them.
3. Hands back an **opinionated, ordered plan** of the documentation the repo needs next
   — each item aimed at a specific place an agent currently fails or lands blind. The
   plan is saved to `docs/agent-readiness-plan.md` by default (redirectable to a
   connector on request).

It produces a **plan, not docs**. It is opinionated about the documentation you need and
agnostic about the tools to produce it: it maps an item to a skill only when a fitting
one exists in your environment, and otherwise states the intervention plainly. It
**recommends and hands off** — it never executes the plan itself.

## Built on

The orchestrator/worker discipline, the grilling interview primitive, and the
writing-for-agents conventions come from
[Matt Pocock's "Skills For Real Engineers"](https://github.com/mattpocock/skills) (MIT),
which this composes alongside.

## Status

Early and incremental. Built: the `agent-readiness` front door. Planned: a separate
executor skill that consumes the plan and carries the work forward, plus workers for
archaeological module docs, infra/IaC docs, coverage and drift detection, and a
measurement loop that scores readiness so improvements are testable.

## License

MIT

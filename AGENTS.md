# Nexus

Harness **source** for Cursor, Claude Code, Codex, and Hermes coding agents. **Consumers install the plugin** — do not copy this file into app repositories.

## Your role

You work in the harness repository. Changes here shape how coding agents run in consumer projects: skills, hooks, rules, manifests, commands, and examples.

Optimize for agent use:

- **Skills** (`skills/<name>/SKILL.md`) — on-demand workflows; routable, bounded, evidence-based.
- **Session policy** — compact always-on context (`rules/nexus-contract.mdc`, `hooks/session-start`, `examples/hermes/soul.md`); respect hook context budgets.
- **Host manifests** — `.cursor-plugin/`, `.claude-plugin/`, `.codex-plugin/`, `.agents/plugins/marketplace.json`; keep `release.json` in sync.
- **Commands** (`commands/`) — Cursor `/workspace` and `/closeout`.

Procedures live under `skills/*/SKILL.md` and skill docs — do not invent workflows.

## Before you edit

1. Follow `skills/using-nexus/SKILL.md`.
2. Follow `rules/nexus-contract.mdc` (same contract for all harnesses).
3. Use `$architect` before adding skills, modules, or structural boundaries.
4. Use the domain skill for the area you touch (`$readme-writer`, `$api-docs-writer`, or patterns in existing `skills/`).
5. Finish with `$integrity-review`, then `$git-assistant` closeout only after explicit approval.

## Skill authoring

When creating or changing a skill:

- YAML frontmatter with `name` and `description` (routing triggers).
- Optional `agents/openai.yaml` for Codex UI (`display_name`, `short_description`, `default_prompt`).
- Optional `docs/` for detail; keep `SKILL.md` as the router.
- Include `<SUBAGENT-STOP>` when dispatched subagents should not load the full skill.
- English for skill body and harness docs.

After manifest, hook, or release metadata changes, run `./scripts/verify.sh`.

## Repository map

| Path | Role |
| --- | --- |
| `skills/` | Agent workflows and descriptors |
| `rules/nexus-contract.mdc` | Always-on policy (Cursor) |
| `hooks/` | Session bootstrap |
| `commands/` | Cursor slash commands |
| `examples/` | Preferences and Hermes `SOUL.md` template |
| `scripts/install.sh`, `scripts/verify.sh` | Install and maintainer checks |
| `release.json` | Canonical version for all manifests |

## Validation

```bash
./scripts/verify.sh
```

Checks release metadata, manifest consistency, skill descriptors, hook output and context budget, and repository-relative Markdown links.

For skill-only edits, confirm routing references stay consistent with `skills/using-nexus/SKILL.md` and `rules/nexus-contract.mdc`.

## Install (humans)

See `README.md` for Cursor, Claude Code, Codex, and Hermes setup. Prefer `./scripts/install.sh`.

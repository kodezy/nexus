# Nexus

A private multi-harness production plugin for coding agents (Cursor, Claude Code, Codex).

![Nexus harness illustration](assets/nexus.png)

## What It Does

- Bootstrap with `$using-nexus` (session hook on Cursor and Claude Code).
- Choose `main` or a named worktree before edits — or apply `.nexus/user/preferences.md`.
- Prefer the smallest production-ready change; validate with evidence.
- Close out: integrity review → approve `add + commit + push` together → unify when worktree → execute push.

App repos do **not** need a copied `AGENTS.md`. Install the plugin; keep product code and optional `.nexus/` memory in the app.

## Install

```bash
git clone git@github.com:kodezy/nexus.git
cd nexus
./scripts/install.sh
```

All targets use **symlinks** into this checkout, so edits here apply without re-installing. Open a new agent session (or Reload Window on Cursor) after changing hooks or the plugin manifest.

| Harness | Link | Live updates |
| --- | --- | --- |
| **Cursor** | `~/.cursor/plugins/local/nexus` → repo | Yes |
| **Codex** | `~/.codex/skills/<skill>` → `skills/<skill>` | Yes |
| **Claude Code** | `~/.claude/skills/<skill>` → `skills/<skill>` | Yes |

```bash
./scripts/install.sh cursor
./scripts/install.sh codex
./scripts/install.sh claude
```

### Plugin layout

| Path | Role |
| --- | --- |
| `skills/using-nexus/` | Bootstrap skill (injected at session start where hooks exist) |
| `rules/nexus-contract.mdc` | Always-on policy (Cursor); same contract for all harnesses |
| `skills/` | Workflows (+ `agents/openai.yaml` for Codex UI) |
| `commands/` | `/workspace`, `/closeout` (Cursor) |
| `.cursor-plugin/` | Cursor manifest + `hooks-cursor.json` |
| `.claude-plugin/` | Claude Code manifest + `hooks/hooks.json` |
| `.codex-plugin/` | Codex manifest |
| `AGENTS.md` / `CLAUDE.md` | Pointers for agents working **in this repo** only |

If [Superpowers](https://github.com/obra/superpowers) is also installed: use it for design/plan/SDD; Nexus owns workspace, closeout, and test policy.

**Updates vs Superpowers:** marketplace Superpowers often auto-updates when the IDE refreshes the plugin cache. A **local** Nexus checkout with symlinks updates when you edit/pull this repo — no marketplace. That is usually better for a private harness.

## How Work Flows

1. Preferences — read `.nexus/user/` when present.
2. Workspace — `$git-assistant` workspace-choice (or `/workspace` on Cursor).
3. Act — smallest change; `$architect` when creating structure.
4. Style — `$code-style` on touched files.
5. Review — `$integrity-review`.
6. Closeout — `$git-assistant` closeout (or `/closeout` on Cursor).

## Local Memory (app repos)

- `.nexus/user/` — `default workspace`, `closeout unify`, `closeout push`, `commit superpowers docs`
- `.nexus/project/` — codebase learnings

```text
Use $memory to save default workspace: worktree
Use $memory to save commit superpowers docs: exclude
```

## Version

Plugin version **2.2.0** (all manifests).

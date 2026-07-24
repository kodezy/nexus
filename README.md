# Nexus

![Nexus harness illustration](assets/nexus.png)

Production harness plugin for coding agents: workspace choice, integrity review, and git closeout with explicit approvals.

## What It Does

- Bootstrap with `$using-nexus` (session hook on Cursor and Claude Code).
- Choose `main` or a named worktree before edits — or apply `.nexus/user/preferences.md`.
- Prefer the smallest production-ready change; validate with evidence.
- Close out: integrity review → approve `add + commit + push` together → unify when worktree → execute push.

App repos do **not** need a copied `AGENTS.md`. Install the plugin; keep product code and optional `.nexus/` memory in the app.

## First Run

1. Clone this repo (SSH or HTTPS below).
2. Run `./scripts/install.sh` (or a single target: `cursor`, `codex`, `claude`).
3. **Cursor only:** open **Cursor Settings → Plugins**, confirm **Nexus** appears under local plugins and is enabled, then **Reload Window**.
4. Open a **new agent session** in an app repo (not necessarily this repo).
5. Send a short prompt such as `Implement a small change with Nexus closeout` — the agent should follow `$using-nexus` and ask `main` or a worktree before editing.

## Install

```bash
# SSH
git clone git@github.com:kodezy/nexus.git
cd nexus

# or HTTPS
git clone https://github.com/kodezy/nexus.git
cd nexus

./scripts/install.sh
```

All targets use **symlinks** into this checkout, so edits here apply without re-installing. Open a new agent session (or Reload Window on Cursor) after changing hooks or the plugin manifest.

| Harness | What install does | Live updates |
| --- | --- | --- |
| **Cursor** | `~/.cursor/plugins/local/nexus` → repo (plugin + hooks + rules) | Yes |
| **Codex** | `~/.codex/skills/<skill>` → `skills/<skill>` | Yes |
| **Claude Code** | `~/.claude/skills/<skill>` → `skills/<skill>` | Yes |

Per-target install:

```bash
./scripts/install.sh cursor
./scripts/install.sh codex
./scripts/install.sh claude
```

### Cursor

After `./scripts/install.sh cursor`:

1. **Cursor Settings → Plugins** — enable **Nexus** if it is not already on.
2. **Reload Window** (Command Palette → “Developer: Reload Window”).
3. Start a new agent chat — the session hook injects `$using-nexus` and any `.nexus/user/preferences.md` from the open project.

Commands: `/workspace`, `/closeout`.

### Claude Code

**Recommended:** `./scripts/install.sh claude` — skills symlink to this checkout; live updates without reinstall.

**Optional:** install the full plugin (hooks + bootstrap) from this repo:

```text
/plugin marketplace add /path/to/nexus
/plugin install nexus@nexus
```

Use the plugin path only when you need SessionStart hooks; skills alone are enough for manual `$using-nexus` use.

### Codex

**Recommended:** `./scripts/install.sh codex` — each skill symlinks into `~/.codex/skills/`.

Codex does not run a session hook today. Start tasks with an explicit Nexus prompt (for example: “Follow `$using-nexus` and run integrity-review before closeout”) or invoke skills from the Codex UI.

### Troubleshooting

| Problem | Fix |
| --- | --- |
| Nexus missing under Cursor Plugins | Confirm `~/.cursor/plugins/local/nexus` is a symlink to this repo (`ls -la ~/.cursor/plugins/local/nexus`). Re-run `./scripts/install.sh cursor`. Reload Window. |
| Agent ignores Nexus / no bootstrap text | New agent session after install or hook changes. On Cursor/Claude plugin path, confirm hooks are enabled and Reload Window. |
| `install.sh` refuses a skill path | Remove or rename the conflicting folder under `~/.codex/skills/` or `~/.claude/skills/` (install replaces prior Nexus copies; other paths must be cleared manually). |
| Preferences not applied | Put `.nexus/user/preferences.md` in the **app repo** you have open, not in the Nexus checkout. See `examples/preferences.md`. |
| Codex skills stale | New Codex session after adding or removing skill folders. |

## How Work Flows

1. Preferences — session-injected from `.nexus/user/` when hooks run, otherwise read when present.
2. Workspace — `$git-assistant` workspace-choice (or `/workspace` on Cursor).
3. Act — smallest change; `$architect` when creating structure.
4. Style — `$code-style` on touched files.
5. Review — `$integrity-review`.
6. Closeout — `$git-assistant` closeout (or `/closeout` on Cursor).

## Local Memory (app repos)

- `.nexus/user/` — `default workspace`, `closeout unify`, `closeout push`, `commit superpowers docs`
- `.nexus/project/` — codebase learnings

Starter file: copy `examples/preferences.md` into `.nexus/user/preferences.md` in your app repo.

```text
Use $memory to save default workspace: worktree
Use $memory to save commit superpowers docs: exclude
```

## Plugin Layout

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

If [Superpowers](https://github.com/obra/superpowers) is also installed: use it for design/plan/SDD; Nexus owns workspace, closeout, and test policy. Superpowers is **optional**.

**Updates vs Superpowers:** marketplace Superpowers often auto-updates when the IDE refreshes the plugin cache. A **local** Nexus checkout with symlinks updates when you edit/pull this repo — no marketplace step required.

## Version

Plugin version **2.2.0** (all manifests).

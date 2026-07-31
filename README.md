# Nexus

![Nexus harness illustration](assets/nexus.png)

Production harness plugin for coding agents: workspace choice, integrity review, and git closeout with explicit approvals.

## What It Does

- Bootstrap with `$using-nexus` (session hook on Cursor and Claude Code).
- Choose `main` or a named worktree before edits — or apply `~/.nexus/user/preferences.md` and optional repo `.nexus/user/preferences.md`.
- Prefer the smallest production-ready change; validate with evidence.
- Close out: integrity review → approve `add + commit + push` together → unify when worktree → execute push.

App repos do **not** need a copied `AGENTS.md`. Install the plugin; keep product code and optional `.nexus/` memory in the app. Cross-project memory lives in `~/.nexus/`.

## First Run

1. Clone this repo (SSH or HTTPS below).
2. Run `./scripts/install.sh` (or a single target: `cursor`, `codex`, `claude`, `hermes`).
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
| **Hermes** | Profile `nexus` (override with `NEXUS_HERMES_PROFILE`): skill symlinks + `SOUL.md` | Yes |

### Platform Compatibility

| Harness | Session bootstrap | Commands | Skill installation | Live updates |
| --- | --- | --- | --- | --- |
| **Cursor** | Yes, through the session-start hook | `/workspace`, `/closeout` | Plugin manifest | Yes; reload after hook or manifest changes |
| **Codex** | No; invoke `$using-nexus` explicitly | No | `~/.codex/skills/` symlinks | Yes; start a new session after skill discovery changes |
| **Claude Code** | Yes, when installed as a plugin | No | `~/.claude/skills/` symlinks | Yes; start a new session after hook or manifest changes |
| **Hermes** | Yes, through the `SOUL.md` profile bootstrap | No | Profile skill symlinks | Yes; start a new session after `SOUL.md` or skill changes |

Per-target install:

```bash
./scripts/install.sh cursor
./scripts/install.sh codex
./scripts/install.sh claude
./scripts/install.sh hermes
```

### Cursor

After `./scripts/install.sh cursor`:

1. **Cursor Settings → Plugins** — enable **Nexus** if it is not already on.
2. **Reload Window** (Command Palette → “Developer: Reload Window”).
3. Start a new agent chat — the session hook injects `$using-nexus` plus any `~/.nexus/user/preferences.md` and repo `.nexus/user/preferences.md` (repo overrides global).

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

### Hermes

Requires the [Hermes Agent](https://github.com/nousresearch/hermes-agent) CLI. Installs into a dedicated profile (default name `nexus`) so the personal Hermes agent stays untouched:

```bash
./scripts/install.sh hermes
# optional:
NEXUS_HERMES_PROFILE=coder ./scripts/install.sh hermes
NEXUS_HERMES_PROFILE=default ./scripts/install.sh hermes   # ~/.hermes
```

What it does:

1. Creates the profile with `--no-skills` when missing.
2. Symlinks Nexus skills into that profile’s `skills/` (skips `memory` — Hermes owns `/memory`).
3. Writes `examples/hermes/soul.md` → profile `SOUL.md` (bootstrap; Hermes has no session hook).
4. Sets `skills.write_approval=true` so Hermes cannot rewrite Nexus skills.

Start coding sessions with `hermes -p nexus chat` (or `nexus chat` after the profile alias exists). Re-run install after pull; open a new Hermes session for SOUL/skill changes.

Global preferences live in `~/.nexus/user/preferences.md`; app-repo overrides in `.nexus/user/preferences.md`. Hermes `MEMORY.md` / `USER.md` are for tone and environment only.

### Troubleshooting

| Problem | Fix |
| --- | --- |
| Nexus missing under Cursor Plugins | Confirm `~/.cursor/plugins/local/nexus` is a symlink to this repo (`ls -la ~/.cursor/plugins/local/nexus`). Re-run `./scripts/install.sh cursor`. Reload Window. |
| Agent ignores Nexus / no bootstrap text | New agent session after install or hook changes. On Cursor/Claude plugin path, confirm hooks are enabled and Reload Window. On Hermes, confirm profile `SOUL.md` matches `examples/hermes/soul.md` and start a new chat. |
| `install.sh` refuses a skill path | Remove or rename the conflicting folder under `~/.codex/skills/`, `~/.claude/skills/`, or the Hermes profile `skills/` (install replaces prior Nexus copies; other paths must be cleared manually). |
| Preferences not applied | Put global defaults in `~/.nexus/user/preferences.md`, and optional overrides in the **app repo** `.nexus/user/preferences.md` (not in the Nexus checkout). See `examples/preferences.md`. |
| Codex skills stale | New Codex session after adding or removing skill folders. |
| Hermes install errors on `hermes` | Install Hermes Agent and ensure `hermes` is on `PATH`, then re-run `./scripts/install.sh hermes`. |

## How Work Flows

1. Preferences — session-injected from `~/.nexus/user/` and `.nexus/user/` when hooks run (repo overrides global); otherwise read when present.
2. Workspace — `$git-assistant` workspace-choice (or `/workspace` on Cursor).
3. Act — smallest change; `$architect` when creating structure.
4. Style — `$code-style` on touched files.
5. Review — `$integrity-review`.
6. Closeout — `$git-assistant` closeout (or `/closeout` on Cursor).

## Local Memory

### Global (`~/.nexus/`, or `$NEXUS_HOME`)

- `user/preferences.md` — cross-project workflow defaults (`default workspace`, `closeout unify`, `closeout push`, `commit superpowers docs`)
- `notes/` — free-form personal notes (read on demand via `$memory`, not session-injected)

### App repo (`.nexus/`)

- `user/` — repo overrides for the same preference keys
- `project/` — codebase learnings

Starter: copy from `examples/preferences.md` into `~/.nexus/user/preferences.md` and/or the app repo `.nexus/user/preferences.md`.

```text
Use $memory to save default workspace: worktree
Use $memory to save commit superpowers docs: exclude
Use $memory to save globally: prefer concise replies
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
| `examples/preferences.md` | Starter global and app-repo preferences |
| `examples/hermes/soul.md` | Hermes profile `SOUL.md` bootstrap |
| `AGENTS.md` / `CLAUDE.md` | Pointers for agents working **in this repo** only |

## Maintainer Verification

Run this before publishing or changing plugin metadata:

```bash
./scripts/verify.sh
```

The command checks canonical release metadata in `release.json`, platform manifest consistency, skill descriptors, Cursor manifest paths, and repository-relative Markdown links.

If [Superpowers](https://github.com/obra/superpowers) is also installed: use it for design/plan/SDD; Nexus owns workspace, closeout, and test policy. Superpowers is **optional**.

**Updates vs Superpowers:** marketplace Superpowers often auto-updates when the IDE refreshes the plugin cache. A **local** Nexus checkout with symlinks updates when you edit/pull this repo — no marketplace step required.

## Version

Canonical release metadata lives in `release.json`. The verification script checks every manifest that exposes shared release fields.

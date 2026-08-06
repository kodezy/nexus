# Nexus

![Nexus harness illustration](assets/nexus.png)

Harness plugin for coding agents: workspace choice, integrity review, and git closeout with explicit approvals.

## What It Does

- Inject a compact core policy at session start; load `$using-nexus` only for code or repository changes.
- Choose `main` or a named worktree before edits — or apply `~/.nexus/user/preferences.md` and optional repo `.nexus/user/preferences.md`.
- Prefer the smallest production-ready change; validate with evidence.
- Close out: integrity review → approve `add + commit + push` together → unify when worktree → execute push.

App repos do **not** need a copied Nexus `AGENTS.md`. Nexus complements, but never replaces, the app's existing `AGENTS.md`, `CLAUDE.md`, Cursor rules, or host configuration. Keep optional Nexus workflow preferences in `.nexus/`; cross-project preferences live in `~/.nexus/`.

## First Run

1. Clone this repo (SSH or HTTPS below).
2. Run `./scripts/install.sh` (or a single target: `cursor`, `codex`, `claude`, `hermes`).
3. **Cursor only:** open **Cursor Settings → Plugins**, confirm **Nexus** appears under local plugins and is enabled, then **Reload Window**.
4. Open a **new agent session** in an app repo (not necessarily this repo).
5. Send a short prompt such as `Implement a small change with Nexus closeout` — the agent loads `$using-nexus`, then chooses the workspace from preferences or asks before editing.

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

Claude skill installs use **symlinks** into this checkout, so skill edits apply without re-installing. Plugin-hosted files follow each host's cache and refresh behavior. After changing hooks or manifests, refresh the Codex plugin, reload Cursor, or open a new agent session for the relevant host.

| Harness | What install does | Live updates |
| --- | --- | --- |
| **Cursor** | `~/.cursor/plugins/local/nexus` → repo (plugin + hooks + rules) | Yes |
| **Codex** | Adds this checkout as a local Marketplace | No; refresh the plugin after changes |
| **Claude Code** | `~/.claude/skills/<skill>` → `skills/<skill>` | Yes |
| **Hermes** | Profile `nexus` (override with `NEXUS_HERMES_PROFILE`): skill symlinks + `SOUL.md` | Yes |

### Platform Compatibility

| Harness | Session bootstrap | Commands | Skill installation | Live updates |
| --- | --- | --- | --- | --- |
| **Cursor** | Compact core policy through the session-start hook | `/workspace`, `/closeout` | Plugin manifest | Yes; reload after hook or manifest changes |
| **Codex** | Compact core policy after installing Nexus and trusting its hook | No | Local Marketplace plugin | Refresh after manifest or hook changes |
| **Claude Code** | Compact core policy when installed as a plugin | No | `~/.claude/skills/` symlinks | Yes; start a new session after hook or manifest changes |
| **Hermes** | Compact core policy through the `SOUL.md` profile | No | Profile skill symlinks + copied `SOUL.md` | Skills: yes. `SOUL.md`: re-run install |

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
3. Start a new agent chat — the session hook injects only the compact core policy. The agent reads preferences on demand when choosing a workspace or closing out work.

Commands: `/workspace`, `/closeout`.

### Claude Code

**Recommended:** `./scripts/install.sh claude` — skills symlink to this checkout; live updates without reinstall.

**Optional:** install the full plugin (hooks + compact core policy) from this repo:

```text
/plugin marketplace add /path/to/nexus
/plugin install nexus@nexus
```

Use the plugin path only when you need SessionStart hooks; skills alone are enough for manual `$using-nexus` use.

### Codex

Nexus installs as a local Marketplace plugin. Add this checkout as a marketplace source, enable Nexus in `/plugins`, and trust its hook in `/hooks`:

```bash
codex plugin marketplace add /path/to/nexus
```

`./scripts/install.sh codex` runs the marketplace command for you. The repository marketplace is at `.agents/plugins/marketplace.json`. Plugin installs are cached by Codex, so refresh the plugin after changing its manifest or hook files.

This local Marketplace is private to the machine that adds it. It does not publish or share Nexus.

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
2. Symlinks Nexus skills into that profile’s `skills/` (skips `memory` — Hermes owns `/memory`; the installed `SOUL.md` directs Nexus preference and note access to `~/.nexus/` and `.nexus/` through file tools).
3. Copies `examples/hermes/soul.md` to profile `SOUL.md` (compact core policy; Nexus does not configure a Hermes shell hook).
4. Sets `skills.write_approval=true` so Hermes cannot rewrite Nexus skills.

Start coding sessions with `hermes -p nexus chat` (or `nexus chat` after the profile alias exists). Re-run install after pull; open a new Hermes session for SOUL/skill changes.

Global preferences live in `~/.nexus/user/preferences.md`; app-repo overrides in `.nexus/user/preferences.md`. Hermes `MEMORY.md` / `USER.md` are for tone and environment only.

### Troubleshooting

| Problem | Fix |
| --- | --- |
| Nexus missing under Cursor Plugins | Confirm `~/.cursor/plugins/local/nexus` is a symlink to this repo (`ls -la ~/.cursor/plugins/local/nexus`). Re-run `./scripts/install.sh cursor`. Reload Window. |
| Agent ignores Nexus core policy | New agent session after install or hook changes. On Cursor/Claude plugin path, confirm hooks are enabled and Reload Window. On Hermes, confirm profile `SOUL.md` matches `examples/hermes/soul.md` and start a new chat. |
| `install.sh` refuses a skill path | Remove or rename the conflicting folder under `~/.claude/skills/` or the Hermes profile `skills/`; Nexus never replaces a different skill automatically. |
| Preferences not applied | Put global defaults in `~/.nexus/user/preferences.md`, and optional overrides in the **app repo** `.nexus/user/preferences.md` (not in the Nexus checkout). See `examples/preferences.md`. |
| Codex plugin stale | Refresh Nexus in `/plugins`, review its hook again in `/hooks` if it changed, then start a new session. |
| Hermes install errors on `hermes` | Install Hermes Agent and ensure `hermes` is on `PATH`, then re-run `./scripts/install.sh hermes`. |

## How Work Flows

1. Scope — use the compact core policy for all sessions; load `$using-nexus` only before code or repository changes.
2. Preferences — read `~/.nexus/user/` and `.nexus/user/` only when choosing a workspace or closing out work (repo overrides global).
3. Workspace — `$git-assistant` workspace-choice (or `/workspace` on Cursor).
4. Specify — `$spec-driven` when a feature or UI needs its flow and acceptance criteria defined.
5. Act — smallest change; `$architect` when creating structure.
6. Style — `$code-style` on touched files; React UI also uses `$frontend-quality`.
7. Review — `$integrity-review`.
8. Closeout — `$git-assistant` closeout (or `/closeout` on Cursor).

## Validation in Consumer Projects

Nexus supplies the workflow, not a universal test command. Each app repository should keep its trusted validation commands in its own `AGENTS.md`, `CLAUDE.md`, or native rules. Keep the list small and state what each command proves:

```md
## Validation

- Fast: `npm run lint && npm run typecheck`
- Tests: `npm test`
- Build: `npm run build`
- UI behavior: `npx playwright test`
```

During `$integrity-review`, the agent chooses checks proportional to the change and returns a validation receipt: scope, criteria checked, commands or runtime exercise, result, and remaining uncertainty. It may report **Validated** or **Corrected** only with verifiable evidence. If a relevant check is missing, it reports **Uncertain**; if an external prerequisite prevents validation, it reports **Blocked**.

Prefer existing tests. When a new test is the relevant missing validation sensor, Nexus requires the agent to propose its scope and request approval before creating it. This prevents boilerplate while avoiding unverified feature work.

## Local Memory

### Global (`~/.nexus/`, or `$NEXUS_HOME`)

- `user/preferences.md` — cross-project workflow defaults (`default workspace`, `closeout unify`, `closeout push`, `commit workflow docs`, `workflow docs paths`)
- `notes/` — free-form personal notes (read on demand via `$memory`, not session-injected)

### App repo (`.nexus/`)

- `user/` — repo overrides for the same preference keys
- `project/` — codebase learnings

Starter: copy from `examples/preferences.md` into `~/.nexus/user/preferences.md` and/or the app repo `.nexus/user/preferences.md`.

```text
Use $memory to save default workspace: worktree
Use $memory to save commit workflow docs: exclude
Use $memory to save globally: prefer concise replies
```

## Plugin Layout

| Path | Role |
| --- | --- |
| `skills/using-nexus/` | On-demand router for code and repository changes |
| `skills/spec-driven/` | Lightweight feature and UI specification workflow |
| `skills/frontend-quality/` | Responsive, accessible, concise React UI review |
| `rules/nexus-contract.mdc` | Always-on policy (Cursor); same contract for all harnesses |
| `skills/` | Workflows (+ `agents/openai.yaml` for Codex UI) |
| `.agents/plugins/marketplace.json` | Local Codex marketplace entry for the full plugin |
| `commands/` | `/workspace`, `/closeout` (Cursor) |
| `.cursor-plugin/` | Cursor manifest |
| `hooks/hooks-cursor.json` | Cursor session hook |
| `.claude-plugin/` | Claude Code manifest + `hooks/hooks.json` |
| `.codex-plugin/` | Codex manifest |
| `examples/preferences.md` | Starter global and app-repo preferences |
| `examples/hermes/soul.md` | Hermes profile `SOUL.md` core policy |
| `AGENTS.md` / `CLAUDE.md` | Pointers for agents working **in this repo** only |

## Maintainer Verification

Run this before publishing or changing plugin metadata:

```bash
./scripts/verify.sh
```

The command checks canonical release metadata in `release.json`, platform manifest consistency, skill descriptors, hook output and context budget, Cursor manifest paths, and repository-relative Markdown links.

## Coexistence

Nexus is a default layer, not a replacement for a host or project harness. Resolve instructions in this order: system and managed policy; explicit user instructions; host-native approval and safety controls; project instructions; Nexus; optional plugins and skills.

Use [Superpowers](https://github.com/obra/superpowers) or another workflow plugin as task-specific guidance. Nexus owns workspace choice, Git approval, closeout, and approval for a new test when it is the relevant missing validation sensor. Optional workflow artifacts are controlled by `commit workflow docs` and `workflow docs paths` preferences. Superpowers is **optional**.

**Updates vs Superpowers:** marketplace Superpowers may update when the host refreshes its plugin cache. Cursor and Claude symlinks follow this checkout live; Codex needs a plugin refresh, and Hermes needs `install.sh hermes` again when `SOUL.md` changes.

## Version

Canonical release metadata lives in `release.json`. The verification script checks every manifest that exposes shared release fields.

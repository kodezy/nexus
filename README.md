# Nexus

![Nexus harness illustration](assets/nexus.png)

Harness plugin for coding agents. Nexus adds workspace choice, integrity review, and git closeout with explicit approvals.

## Features

- Inject a compact core policy at session start; load `$using-nexus` only for code or repository changes.
- Choose `main` or a named worktree before edits, or apply saved preferences.
- Prefer the smallest production-ready change and validate with evidence.
- Close out work in order: integrity review → approve `add + commit + push` → unify when on a worktree → push.
- Store cross-project preferences in `~/.nexus/` and per-repo overrides in `.nexus/`.
- Install into Cursor, Claude Code, Codex, and Hermes from one checkout.
- Complement app `AGENTS.md`, `CLAUDE.md`, Cursor rules, and host configuration — never replace them.

## Requirements

**Required**

- Git
- Bash (for `scripts/install.sh`)

**Optional** — install only the harnesses you use:

| Harness | Additional requirement |
| --- | --- |
| **Cursor** | Cursor with local plugin support |
| **Claude Code** | Claude Code CLI |
| **Codex** | Codex CLI with plugin and hook support |
| **Hermes** | [Hermes Agent](https://github.com/nousresearch/hermes-agent) CLI on `PATH` |

## Installation

### 1. Clone the repository

```bash
# SSH
git clone git@github.com:kodezy/nexus.git
cd nexus

# or HTTPS
git clone https://github.com/kodezy/nexus.git
cd nexus
```

### 2. Run the installer

```bash
./scripts/install.sh
```

Install a single target:

```bash
./scripts/install.sh cursor
./scripts/install.sh codex
./scripts/install.sh claude
./scripts/install.sh hermes
```

### 3. Finish host-specific setup

| Harness | After install |
| --- | --- |
| **Cursor** | Enable **Nexus** under **Cursor Settings → Plugins**, then **Reload Window**. |
| **Codex** | Enable Nexus in `/plugins` and trust its hook in `/hooks`. |
| **Claude Code** | Start a new session. For hooks, use the optional plugin path below. |
| **Hermes** | Start a session with `hermes -p nexus chat` (or your `NEXUS_HERMES_PROFILE` name). |

### 4. Verify in an app repo

Open a **new agent session** in an application repository (not necessarily this checkout). Send a short prompt such as:

```text
Implement a small change with Nexus closeout
```

The agent loads `$using-nexus`, chooses a workspace from preferences or asks, then follows the Nexus workflow.

### Install details by harness

Claude skill installs use **symlinks** into this checkout, so skill edits apply without re-installing. Plugin-hosted files follow each host's cache and refresh behavior. After changing hooks or manifests, refresh the Codex plugin, reload Cursor, or open a new agent session.

| Harness | What install does | Live updates |
| --- | --- | --- |
| **Cursor** | `~/.cursor/plugins/local/nexus` → repo (plugin + hooks + rules) | Yes |
| **Codex** | Adds this checkout as a local Marketplace | No; refresh the plugin after changes |
| **Claude Code** | `~/.claude/skills/<skill>` → `skills/<skill>` | Yes |
| **Hermes** | Profile `nexus` (override with `NEXUS_HERMES_PROFILE`): skill symlinks + `SOUL.md` | Skills: yes. `SOUL.md`: re-run install |

| Harness | Session bootstrap | Commands | Skill installation |
| --- | --- | --- | --- |
| **Cursor** | Compact core policy through the session-start hook | `/workspace`, `/closeout` | Plugin manifest |
| **Codex** | Compact core policy after installing Nexus and trusting its hook | No | Local Marketplace plugin |
| **Claude Code** | Compact core policy when installed as a plugin | No | `~/.claude/skills/` symlinks |
| **Hermes** | Compact core policy through the `SOUL.md` profile | No | Profile skill symlinks + copied `SOUL.md` |

#### Cursor

After `./scripts/install.sh cursor`:

1. **Cursor Settings → Plugins** — enable **Nexus** if it is not already on.
2. **Reload Window** (Command Palette → "Developer: Reload Window").
3. Start a new agent chat. The session hook injects only the compact core policy.

Commands: `/workspace`, `/closeout`.

#### Claude Code

**Recommended:** `./scripts/install.sh claude` — skills symlink to this checkout.

**Optional** — full plugin with SessionStart hooks:

```text
/plugin marketplace add /path/to/nexus
/plugin install nexus@nexus
```

Use the plugin path only when you need session hooks. Skills alone are enough for manual `$using-nexus` use.

#### Codex

Nexus installs as a local Marketplace plugin. The repository marketplace is at `.agents/plugins/marketplace.json`.

```bash
codex plugin marketplace add /path/to/nexus
```

`./scripts/install.sh codex` runs the marketplace command for you. Plugin installs are cached by Codex — refresh the plugin after changing its manifest or hook files. This local Marketplace is private to your machine.

#### Hermes

Installs into a dedicated profile (default name `nexus`) so your personal Hermes agent stays untouched:

```bash
./scripts/install.sh hermes

# optional profile name:
NEXUS_HERMES_PROFILE=coder ./scripts/install.sh hermes
NEXUS_HERMES_PROFILE=default ./scripts/install.sh hermes   # ~/.hermes
```

The installer:

1. Creates the profile with `--no-skills` when missing.
2. Symlinks Nexus skills into that profile's `skills/` (skips `memory` — Hermes owns `/memory`).
3. Copies `examples/hermes/soul.md` to profile `SOUL.md`.
4. Sets `skills.write_approval=true` so Hermes cannot rewrite Nexus skills.

Re-run install after pull. Open a new Hermes session for `SOUL.md` or skill changes.

## Configuration

Nexus reads preferences only when choosing a workspace or closing out work. Repo preferences override global preferences.

### Global (`~/.nexus/`, or `$NEXUS_HOME`)

| Path | Purpose |
| --- | --- |
| `user/preferences.md` | Cross-project workflow defaults |
| `notes/` | Free-form personal notes (read on demand via `$memory`, not session-injected) |

### App repo (`.nexus/`)

| Path | Purpose |
| --- | --- |
| `user/preferences.md` | Repo overrides for the same preference keys |
| `project/` | Codebase learnings |

Starter templates: `examples/preferences.md`.

```markdown
## Git workflow

- **default workspace:** `worktree` — `main` | `worktree`
- **worktree branch prefix:** `feat/`
- **closeout unify:** `ask` — `ask` | `always` | `never`
- **closeout push:** `ask` — `ask` | `always` | `never`
- **commit workflow docs:** `exclude` — `include` | `exclude` | `ask`
- **workflow docs paths:** `docs/superpowers/, .superpowers/`
```

Save preferences in any session:

```text
Use $memory to save default workspace: worktree
Use $memory to save commit workflow docs: exclude
Use $memory to save globally: prefer concise replies
```

Hermes `MEMORY.md` / `USER.md` are for tone and environment only. Nexus preference and note access goes through `~/.nexus/` and `.nexus/` via file tools.

## Usage

### Workflow

1. **Scope** — compact core policy for all sessions; load `$using-nexus` only before code or repository changes.
2. **Preferences** — read `~/.nexus/user/` and `.nexus/user/` when choosing a workspace or closing out.
3. **Workspace** — `$git-assistant` workspace choice (or `/workspace` on Cursor).
4. **Specify** — `$spec-driven` when a feature or UI needs flow and acceptance criteria.
5. **Act** — smallest change; `$architect` when creating structure.
6. **Style** — `$code-style` on touched files; React UI also uses `$frontend-quality`.
7. **Review** — `$integrity-review`.
8. **Closeout** — `$git-assistant` closeout (or `/closeout` on Cursor).

### Validation in consumer projects

Nexus supplies the workflow, not a universal test command. Each app repository should keep trusted validation commands in its own `AGENTS.md`, `CLAUDE.md`, or native rules:

```md
## Validation

- Fast: `npm run lint && npm run typecheck`
- Tests: `npm test`
- Build: `npm run build`
- UI behavior: `npx playwright test`
```

During `$integrity-review`, the agent chooses checks proportional to the change and returns a validation receipt: scope, criteria checked, commands or runtime exercise, result, and remaining uncertainty.

| Verdict | When |
| --- | --- |
| **Validated** or **Corrected** | Verifiable evidence exists |
| **Uncertain** | A relevant check is missing |
| **Blocked** | An external prerequisite prevents validation |

Prefer existing tests. When a new test is the relevant missing validation sensor, the agent proposes its scope and requests approval before creating it.

## Architecture

| Path | Role |
| --- | --- |
| `skills/using-nexus/` | On-demand router for code and repository changes |
| `skills/spec-driven/` | Lightweight feature and UI specification workflow |
| `skills/frontend-quality/` | Responsive, accessible, concise React UI review |
| `rules/nexus-contract.mdc` | Always-on policy (Cursor); same contract for all harnesses |
| `skills/` | Workflows (+ `agents/openai.yaml` for Codex UI) |
| `.agents/plugins/marketplace.json` | Local Codex marketplace entry |
| `commands/` | `/workspace`, `/closeout` (Cursor) |
| `.cursor-plugin/` | Cursor manifest |
| `hooks/hooks-cursor.json` | Cursor session hook |
| `.claude-plugin/` | Claude Code manifest + `hooks/hooks.json` |
| `.codex-plugin/` | Codex manifest |
| `examples/preferences.md` | Starter global and app-repo preferences |
| `examples/hermes/soul.md` | Hermes profile `SOUL.md` core policy |
| `AGENTS.md` / `CLAUDE.md` | Pointers for agents working **in this repo** only |

## Coexistence

Nexus is a default layer, not a replacement for a host or project harness. Resolve instructions in this order:

1. System and managed policy
2. Explicit user instructions
3. Host-native approval and safety controls
4. Project instructions
5. Nexus
6. Optional plugins and skills

Use [Superpowers](https://github.com/obra/superpowers) or another workflow plugin as task-specific guidance. Nexus owns workspace choice, Git approval, closeout, and approval for a new test when it is the relevant missing validation sensor. Superpowers is **optional**.

**Updates vs Superpowers:** marketplace Superpowers may update when the host refreshes its plugin cache. Cursor and Claude symlinks follow this checkout live. Codex needs a plugin refresh. Hermes needs `./scripts/install.sh hermes` again when `SOUL.md` changes.

## Troubleshooting

| Problem | Fix |
| --- | --- |
| Nexus missing under Cursor Plugins | Confirm `~/.cursor/plugins/local/nexus` symlinks to this repo. Re-run `./scripts/install.sh cursor`. Reload Window. |
| Agent ignores Nexus core policy | Start a new agent session after install or hook changes. On Cursor/Claude plugin path, confirm hooks are enabled. On Hermes, confirm profile `SOUL.md` matches `examples/hermes/soul.md`. |
| `install.sh` refuses a skill path | Remove or rename the conflicting folder under `~/.claude/skills/` or the Hermes profile `skills/`. Nexus never replaces a different skill automatically. |
| Preferences not applied | Put global defaults in `~/.nexus/user/preferences.md` and overrides in the **app repo** `.nexus/user/preferences.md` (not in this checkout). See `examples/preferences.md`. |
| Codex plugin stale | Refresh Nexus in `/plugins`, review its hook in `/hooks` if it changed, then start a new session. |
| Hermes install errors on `hermes` | Install Hermes Agent and ensure `hermes` is on `PATH`, then re-run `./scripts/install.sh hermes`. |

## Maintainer verification

Run before publishing or changing plugin metadata:

```bash
./scripts/verify.sh
```

The script checks release metadata in `release.json`, platform manifest consistency, skill descriptors, hook output and context budget, Cursor manifest paths, and repository-relative Markdown links.

## Version

Canonical release metadata lives in `release.json`. The verification script checks every manifest that exposes shared release fields.

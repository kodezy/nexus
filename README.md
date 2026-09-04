# Nexus

![Nexus harness illustration](assets/nexus.png)

Portable workflow for coding agents. Cursor, Claude Code, Codex, and Hermes ship their own runtimes — Nexus does not replace them. It adds one shared procedure: workspace choice, evidence-based validation, integrity review, and git closeout with explicit approval.

| Nexus is | Nexus is not |
| --- | --- |
| Same workflow across hosts | A replacement for host rules or app `AGENTS.md` |
| Git ritual with approval gates | A test runner or CI |
| On-demand skills (`$architect`, `$code-style`, …) | A mandatory framework |

**Use it** if you switch hosts or want consistent git discipline without copying the same `AGENTS.md` everywhere. **Skip it** if one host and one repo already cover your process.

## Requirements

- **Git** and **Bash** (for `scripts/install.sh`)
- One or more hosts: **Cursor**, **Claude Code**, **Codex**, and/or **Hermes** ([install](https://github.com/nousresearch/hermes-agent))

## Install

```bash
git clone https://github.com/kodezy/nexus.git
cd nexus
./scripts/install.sh          # all detected targets
./scripts/install.sh cursor   # or codex, claude, hermes
```

| Harness | After install |
| --- | --- |
| **Cursor** | Enable **Nexus** in Settings → Plugins, reload window |
| **Codex** | Enable in `/plugins`, trust hook in `/hooks` |
| **Claude Code** | New session (skills symlink; optional plugin for hooks) |
| **Hermes** | `hermes -p nexus chat` |

Open a **new session in an app repo** and try: `Implement a small change with Nexus closeout`.

Host-specific steps: [docs/install.md](docs/install.md).

## Workflow

1. Load `$using-nexus` before code or repo changes.
2. Choose workspace (`main` or worktree) — or apply preferences.
3. Implement with domain skills as needed.
4. Run `$integrity-review`.
5. Close out with explicit approval for `add`, `commit`, and `push`.

Full steps, validation, and repo layout: [docs/workflow.md](docs/workflow.md).

## Configuration

- Global: `~/.nexus/user/preferences.md` (or `$NEXUS_HOME`)
- Per app repo: `.nexus/user/preferences.md` (gitignored)

Starter templates: [examples/preferences.md](examples/preferences.md).

## Coexistence

Nexus sits below project `AGENTS.md` and host controls, above optional plugins like [Superpowers](https://github.com/obra/superpowers). It owns workspace choice, git approval gates, and closeout — not planning or TDD rituals.

<details>
<summary>Instruction precedence</summary>

1. System and managed policy  
2. Explicit user instructions  
3. Host-native approval and safety  
4. Project instructions  
5. Nexus  
6. Optional plugins and skills  

</details>

## Troubleshooting

| Problem | Fix |
| --- | --- |
| Plugin missing (Cursor) | Check `~/.cursor/plugins/local/nexus` symlink; re-run install; reload window |
| Policy ignored | New session after install; confirm hooks enabled |
| Preferences not applied | Set files in the **app repo** `.nexus/`, not this harness checkout |
| Codex stale | Refresh plugin in `/plugins` |

More: [docs/install.md](docs/install.md).

## Docs

| Doc | Contents |
| --- | --- |
| [docs/install.md](docs/install.md) | Per-host install and update behavior |
| [docs/workflow.md](docs/workflow.md) | Full workflow, validation, repository layout |
| [examples/preferences.md](examples/preferences.md) | Preference templates |

## Maintainer

```bash
./scripts/verify.sh
```

Release metadata: `release.json`.

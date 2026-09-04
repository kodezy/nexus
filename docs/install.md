# Installation details

Quick path: clone, run `./scripts/install.sh`, enable the plugin in your host, open a new session in an **app repo** (not necessarily this checkout).

## Per-host setup

### Cursor

After `./scripts/install.sh cursor`:

1. **Cursor Settings → Plugins** — enable **Nexus**.
2. **Reload Window** (Command Palette → "Developer: Reload Window").
3. Start a new agent chat.

Commands: `/workspace`, `/closeout`.

Install path: `~/.cursor/plugins/local/nexus` → this repo (plugin + hooks + rules). Symlink updates live.

### Claude Code

**Recommended:** `./scripts/install.sh claude` — skills symlink to this checkout.

**Optional** — full plugin with SessionStart hooks:

```text
/plugin marketplace add /path/to/nexus
/plugin install nexus@nexus
```

Use the plugin path only when you need session hooks. Skills alone are enough for manual `$using-nexus` use.

Install path: `~/.claude/skills/<skill>` → `skills/<skill>`. Symlink updates live.

### Codex

```bash
./scripts/install.sh codex
# or: codex plugin marketplace add /path/to/nexus
```

Enable Nexus in `/plugins` and trust its hook in `/hooks`. The marketplace entry is at `.agents/plugins/marketplace.json`.

Plugin installs are cached — refresh the plugin after manifest or hook changes. The local marketplace is private to your machine.

### Hermes

```bash
./scripts/install.sh hermes

# optional profile name:
NEXUS_HERMES_PROFILE=coder ./scripts/install.sh hermes
```

Default profile name: `nexus`. Start with `hermes -p nexus chat`.

The installer creates the profile if missing, symlinks skills (skips `memory`), copies `examples/hermes/soul.md` to profile `SOUL.md`, and sets `skills.write_approval=true`. Re-run install after pull or `SOUL.md` changes.

## Install summary

| Harness | Bootstrap | Commands | Live updates |
| --- | --- | --- | --- |
| **Cursor** | Session-start hook | `/workspace`, `/closeout` | Yes (symlink) |
| **Codex** | Hook after plugin + trust | No | No — refresh plugin |
| **Claude Code** | Optional plugin hook; skills always | No | Yes (symlink) |
| **Hermes** | Profile `SOUL.md` | No | Skills yes; `SOUL.md` re-run install |

Claude and Cursor skill symlinks follow this checkout live. Codex needs a plugin refresh. Hermes needs `./scripts/install.sh hermes` again when `SOUL.md` changes.

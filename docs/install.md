# Install

```bash
git clone https://github.com/kodezy/nexus.git
cd nexus
./scripts/install.sh          # all detected hosts
./scripts/install.sh cursor   # or codex, claude
./scripts/install.sh cleanup  # remove legacy skill copies/symlinks
```

| Host | After install |
| --- | --- |
| **Cursor** | Copies to `~/.cursor/plugins/local/nexus` (Cursor ignores external symlinks). Enable Nexus in Customize or Settings → Plugins, then reload window |
| **Codex** | `/plugins` → install; `/hooks` → trust SessionStart |
| **Claude** | New session (skills symlink; optional plugin for hooks) |

## App repo

Copy [template/AGENTS.md](../template/AGENTS.md) into the app. Add `docs/<topic>.md` as needed and index each file in **Docs**.

Do not copy the plugin root `AGENTS.md`.

## Update

Re-run `./scripts/install.sh` after pulling to refresh the Cursor plugin copy. Reload Cursor or start a new session on other hosts.

Cursor copies this checkout with `rsync` (external symlinks are ignored). Skills are not installed under `~/.cursor/skills`. On Team/Enterprise, an admin may need to enable **Allow Local Plugin Imports**.

Legacy skills (`git-assistant`, `structure`, `conventions`, `using-nexus`, etc.) are removed on install/cleanup.

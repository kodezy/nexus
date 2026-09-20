# Install

```bash
git clone https://github.com/kodezy/nexus.git
cd nexus
./scripts/install.sh          # all detected hosts
./scripts/install.sh cursor   # or codex, claude
./scripts/install.sh cleanup  # remove legacy skill symlinks
```

| Host | After install |
| --- | --- |
| **Cursor** | Enable Nexus in Settings → Plugins; reload window |
| **Codex** | `/plugins` → install; `/hooks` → trust SessionStart |
| **Claude** | New session (skills symlink; optional plugin for hooks) |

## App repo

Copy [template/AGENTS.md](../template/AGENTS.md) into the app. Add `docs/<topic>.md` as needed and index each file in **Docs**.

Do not copy the harness root `AGENTS.md`.

## Update

Re-run `./scripts/install.sh` after pulling. Reload Cursor or start a new session on other hosts.

Legacy skills (`git-assistant`, `structure`, `conventions`, `using-nexus`, etc.) are removed on install/cleanup.

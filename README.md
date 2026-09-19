# Nexus

![Nexus harness illustration](assets/nexus.png)

Lightweight harness for coding agents: **project `AGENTS.md` + `docs/`** as the router, **`integrity-review`** before “done”, **`project-context`** when you ask to save docs.

## Install

```bash
git clone https://github.com/kodezy/nexus.git
cd nexus
./scripts/install.sh
```

Enable the plugin (Cursor: Settings → Plugins → Nexus → reload). Details: [docs/install.md](docs/install.md).

## App setup

1. Copy [examples/AGENTS.md](examples/AGENTS.md) into your app repo (merge if needed).
2. Add `docs/` when ready — shapes in [examples/docs/](examples/docs/).

## Model

| Layer | Role |
| --- | --- |
| App `AGENTS.md` | Ritual, validation, doc index |
| App `docs/` | Architecture, domain, conventions, git, notes |
| Plugin | `integrity-review`, `project-context`, compact session policy |

Git has no Nexus skill — use `docs/git.md` when you ask. Host approval applies to git writes.

Full workflow: [docs/workflow.md](docs/workflow.md).

## Maintainer

```bash
./scripts/verify.sh
```

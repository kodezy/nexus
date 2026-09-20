# Nexus

![Nexus harness illustration](assets/nexus.png)

Lightweight harness for coding agents: **project `AGENTS.md` + `docs/`** as the router, **`integrity-review`** before “done”, **`project-context`** when you ask to save docs.

## Install

```bash
git clone https://github.com/kodezy/nexus.git
cd nexus
./scripts/install.sh
```

Enable the plugin (Cursor: Customize or Settings → Plugins → Nexus → reload). Re-run install after pulling. Details: [docs/install.md](docs/install.md).

## App setup

1. Copy [template/AGENTS.md](template/AGENTS.md) into your app repo (merge if needed).
2. Grow `docs/<topic>.md` as needed — add a **Docs** row per file.

## Model

| Layer | Role |
| --- | --- |
| App `AGENTS.md` | Ritual, validation, doc index |
| App `docs/` | Living index from `## Docs`; flat `docs/<topic>.md` files with links |
| Plugin | `integrity-review`, `project-context`, compact session policy |

Full workflow: [docs/workflow.md](docs/workflow.md).

## Maintainer

```bash
./scripts/verify.sh
```

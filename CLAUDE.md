# Nexus

Harness **source** — install the plugin; **do not copy this file** into app repositories. App template: [examples/AGENTS.md](examples/AGENTS.md).

## Agent workflow

- **Workspace:** `main`
- **Validation:** `./scripts/verify.sh`
- **Closeout push:** `never`

## Maintainer map

| Path | Role |
| --- | --- |
| `skills/integrity-review/` | Evidence before “done” |
| `skills/project-context/` | Docs curator on request |
| `rules/nexus-contract.mdc` | Always-on policy |
| `hooks/` | Session bootstrap |
| `examples/AGENTS.md` | App template |
| `examples/docs/` | Optional `docs/` shapes |
| `scripts/install.sh`, `scripts/verify.sh` | Install and checks |
| `release.json` | Version for all manifests |

## Before you edit

1. Follow `rules/nexus-contract.mdc`.
2. Keep two skills only: `integrity-review`, `project-context`.
3. Run `./scripts/verify.sh` after manifest or hook changes.

See [README.md](README.md) for install. See [docs/workflow.md](docs/workflow.md) for the full model.

# Nexus

Harness **source** — install the plugin; **do not copy this file** into app repositories. App template: [template/AGENTS.md](template/AGENTS.md).

## Agent workflow

- **Workspace:** `main`
- **Validation:** `./scripts/verify.sh`

## Maintainer map

| Path | Role |
| --- | --- |
| `skills/integrity-review/` | Evidence before “done” |
| `skills/project-context/` | Docs curator on request |
| `rules/nexus-contract.mdc` | Always-on policy |
| `hooks/` | Session bootstrap |
| `template/AGENTS.md` | App template |
| `scripts/install.sh`, `scripts/verify.sh` | Install and checks |
| `release.json` | Version for all manifests |

## Before you edit

1. Follow `rules/nexus-contract.mdc`.
2. Keep two skills only: `integrity-review`, `project-context`.
3. Run `./scripts/verify.sh` after manifest or hook changes.

See [README.md](README.md) for install. See [docs/workflow.md](docs/workflow.md) for the full model.

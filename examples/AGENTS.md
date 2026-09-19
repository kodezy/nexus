# My App

Copy into your app repository as `AGENTS.md` (or merge sections into `CLAUDE.md`). Doc shapes: [examples/docs/](docs/).

## Agent ritual

- Read only matching entries from **Docs** — not every file.
- On conflict: adjacent code and linter configs win.
- Before claiming done: `$integrity-review` with project validation checks.

## Agent workflow

- **Validation:** `npm run lint && npm test`
- **Closeout push:** never

## Docs

| Topic | Path |
| --- | --- |
| Architecture | [docs/architecture.md](docs/architecture.md) |
| Domain | [docs/domain.md](docs/domain.md) |
| Conventions | [docs/conventions.md](docs/conventions.md) |
| Git | [docs/git.md](docs/git.md) |
| Notes | [docs/notes/](docs/notes/) |

Update docs when this change makes them wrong. `$project-context` only when asked.

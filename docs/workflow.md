# Workflow

1. **Implement** — app `AGENTS.md` → matching `docs/` on demand; adjacent code; linter output.
2. **Verify** — `$integrity-review` with project checks and a validation receipt.
3. **Docs** — `$project-context` only when asked.
4. **Git** — `docs/git.md` + `git log` when asked; host approval for writes.

## App template

[examples/AGENTS.md](../examples/AGENTS.md) — copy into the app repo. Doc shapes: [examples/docs/](../examples/docs/).

Precedence: session instruction → project `AGENTS.md` / `CLAUDE.md` → Nexus → host defaults.

## Verdicts

| Verdict | When |
| --- | --- |
| **Validated** / **Corrected** | Verifiable evidence exists |
| **Uncertain** | A relevant check is missing |
| **Blocked** | External prerequisite blocks validation |

## Harness layout

| Path | Role |
| --- | --- |
| `skills/integrity-review/` | Evidence before “done” |
| `skills/project-context/` | Docs curator on request |
| `rules/nexus-contract.mdc` | Always-on policy |
| `examples/AGENTS.md` | App template |
| `examples/docs/` | Example doc shapes |

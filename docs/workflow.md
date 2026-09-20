# Workflow

1. **Implement** — app `AGENTS.md` → matching `docs/` on demand; adjacent code; linter output.
2. **Verify** — `$integrity-review` with project checks and a validation receipt.
3. **Docs** — `$project-context` only when asked.
4. **Writes** — only when the user asks; follow `AGENTS.md` workflow keys and matching **Docs** entries; host approval for destructive commands.

## App template

[template/AGENTS.md](../template/AGENTS.md) — copy into the app repo. `## Docs` grows as you add `docs/<topic>.md`.

Precedence (full stack in `rules/nexus-contract.mdc`): system and managed policy → explicit user instructions → host-native safety and approval → project `AGENTS.md` / `CLAUDE.md` → Nexus → optional plugins and skills.

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
| `template/AGENTS.md` | App template |

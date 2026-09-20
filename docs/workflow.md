# Workflow

```text
Understand → Implement → Verify → Persist
```

## Understand

Read app `AGENTS.md`, matching `docs/` on demand (follow links only when relevant), and adjacent code.

## Implement

Coding agent + local project conventions (formatter, linter, adjacent modules).

## Verify

`$integrity-review` with deterministic project checks and a validation receipt.

| Verdict | When |
| --- | --- |
| **Validated** / **Corrected** | Verifiable evidence exists |
| **Uncertain** | A relevant check is missing |
| **Blocked** | External prerequisite blocks validation |

## Persist

`$project-context` only when the user asks to save or refresh docs.

## Writes

Only when the user asks; follow `AGENTS.md` workflow keys and matching **Docs** entries; host approval for destructive commands.

## App template

[template/AGENTS.md](../template/AGENTS.md) — copy into the app repo. `## Docs` grows as you add `docs/<topic>.md`.

Precedence (full stack in `rules/nexus-contract.mdc`): system and managed policy → explicit user instructions → host-native safety and approval → project `AGENTS.md` / `CLAUDE.md` → Nexus → optional plugins and skills.

## Layout

| Path | Role |
| --- | --- |
| `rules/nexus-contract.mdc` | Always-on policy |
| `skills/integrity-review/` | Evidence before “done” |
| `skills/project-context/` | Docs curator on request |
| `hooks/` | Session bootstrap |
| `template/AGENTS.md` | App template |

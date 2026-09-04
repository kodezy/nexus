# Workflow and validation

## Agent workflow

1. **Scope** — compact core policy every session; load `$using-nexus` only before code or repo changes.
2. **Preferences** — read `~/.nexus/user/` and `.nexus/user/` when choosing workspace or closing out.
3. **Workspace** — `$git-assistant` workspace choice (or `/workspace` on Cursor).
4. **Specify** — `$spec-driven` when a feature or UI needs flow and acceptance criteria.
5. **Implement** — smallest change; `$architect` for structure; `$code-cleanup` when cleanup is the primary goal.
6. **Style** — `$code-style` on touched files; React UI also uses `$frontend-quality`.
7. **Review** — `$integrity-review`.
8. **Closeout** — `$git-assistant` closeout (or `/closeout` on Cursor).

## Validation in app repos

Nexus supplies the workflow, not a universal test command. Each app repo should document trusted checks in its own `AGENTS.md`, `CLAUDE.md`, or host rules, for example:

```md
## Validation

- Fast: `npm run lint && npm run typecheck`
- Tests: `npm test`
- Build: `npm run build`
```

During `$integrity-review`, the agent picks checks proportional to the change and returns a validation receipt: scope, criteria, commands run, result, and remaining uncertainty.

| Verdict | When |
| --- | --- |
| **Validated** or **Corrected** | Verifiable evidence exists |
| **Uncertain** | A relevant check is missing |
| **Blocked** | An external prerequisite prevents validation |

Prefer existing tests. When a new test is the missing sensor, the agent proposes scope and asks before creating it.

## Repository layout

| Path | Role |
| --- | --- |
| `skills/using-nexus/` | On-demand router for code and repo changes |
| `rules/nexus-contract.mdc` | Always-on policy (Cursor); same contract for all harnesses |
| `skills/` | Workflows (+ `agents/openai.yaml` for Codex UI) |
| `commands/` | `/workspace`, `/closeout` (Cursor) |
| `hooks/` | Session bootstrap |
| `examples/preferences.md` | Starter preferences |
| `examples/hermes/soul.md` | Hermes profile `SOUL.md` template |
| `AGENTS.md` / `CLAUDE.md` | Pointers for agents working **in this repo** only |

## Mandatory Skills Policy (Project Standard)

Whenever the task involves code, the agent MUST apply relevant skills before implementing any change.

### Integration test server

A long-running environment is available for manual checks and API endpoint testing (dashboard, HTTP APIs, and related services):

- **Base URL:** `http://REDACTED_HOST/`

Use this host when the task needs to hit live endpoints, verify integrations, or compare behavior against the deployed stack. Treat it as a shared test instance: avoid destructive actions unless the user explicitly requests them.

### Mandatory rules
1. **Language:** All code, identifiers, comments, and docstrings must be in **English**. User-facing UI copy may follow product language when explicitly specified; otherwise keep it in English.
2. For any code change (creation, refactor, organization, readability improvement):
   - use the `code-style` skill during implementation to ensure style, formatting, and programming consistency
3. The `code-style` skill must be re-applied at the end of every code change, without exception.
4. For **logging** (adding, changing, or reviewing log statements, logger setup, or logging config):
   - use the `log-writer` skill first; then apply `code-style` as usual for the rest of the change
5. For structure or architecture (new modules, packages, folders, file organization):
   - consult the `architect` skill to follow project standards (simple names, correct locations, one purpose per module)
6. For frontend (React/Next.js or Dash): pages, components, layouts, dashboards
   - consult the `frontend` skill for stack-specific UI patterns and conventions (components, state, layout, callbacks, styling)
   - use `architect` for placement and file/module boundaries when frontend work requires structural decisions
7. For any git-related action (status, diff, branch, commit, push, PR, etc.):
   - use the `github-assistant` skill
8. If there is a request for documentation files (`README.md` or other project `.md` docs):
   - use the `readme-writer` skill
9. When the task changes code, perform a **final implementation review** before concluding (see [Final implementation review](#final-implementation-review)). Do not finish while requirements, style, or obvious quality gaps in scope are unresolved.
10. **Tests:** Do **not** create automated tests, test suites, or **test files** (for example `test_*.py`, `*_test.rs`, `*.spec.ts`, `__tests__/`, or new files under `tests/`) unless the user **explicitly** asks for them. You do not need to add tests by default. If you create tests only for temporary debugging or validation, delete them before finishing.

### Default execution order
Apply only the skills relevant to the task scope.

1. Structure/architecture: `architect` (when creating modules, packages, or reorganizing)
2. Logging: `log-writer` (when adding, changing, or reviewing logs)
3. Frontend: `frontend` (when creating or modifying React/Next.js or Dash code)
4. Implementation/refactor: `code-style`
5. Final implementation review: completeness, consistency, and `code-style` verification on all touched files (see below)
6. Commit: `github-assistant` (when requested)

### Final implementation review

Run this **after** implementation and **before** reporting the task as done whenever the change set includes code.

- **Requirements:** Confirm the user’s request is fully addressed within the agreed scope (no missing pieces, no partial behavior unless explicitly out of scope).
- **Quality pass:** Scan changed files for correctness, unintended edits, temporary debug code, and inconsistencies with surrounding modules.
- **Code style:** Confirm the `code-style` skill was applied to every modified file; if anything was skipped or regressed, re-apply `code-style` before finishing.
- **Diagnostics:** When editor or project diagnostics exist for edited files, fix new issues introduced by the change before concluding.

### Expected agent behavior
- **English by default:** Code, identifiers, comments, docstrings, and commit messages in English (see mandatory rule above). User-facing copy only in another language when explicitly requested.
- **Finish strong:** After code work, always run the [final implementation review](#final-implementation-review) so the result is complete and `code-style` is verified on all touched files.
- State in one line which skills will be used and in what order.
- If a mandatory skill cannot be read/executed, report it and apply a fallback while keeping the same standards.
- Do not skip a mandatory skill for convenience.
- Prefer the smallest viable solution, no overengineering, keeping clarity and consistency with project standards.
- Use the project skills for the task.
- **No tests by default:** Follow mandatory rule **10**—do not add tests or test files unless the user explicitly requests them; remove any temporary tests before finishing.
- For `code-style`, automatically select the guide by language/area from the `code-style` skill documentation and apply per file in mixed projects. For frontend React, the frontend skill doc may state that ESLint/Prettier alone is enough—follow that when applicable.
- For **logging**, always apply the `log-writer` skill when writing or changing log messages, levels, or logger configuration.
- For structure/architecture work (new modules, packages, folders, file organization), consult the `architect` skill.

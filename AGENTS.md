## Mandatory Skills Policy (Project Standard)

Whenever the task involves code, the agent MUST apply relevant skills before implementing any change.

### Integration test server

A long-running environment is available for manual checks and API endpoint testing (dashboard, HTTP APIs, and related services):

- **Dev host:** set `DEV_HOST` in the environment (do not hardcode IPs in docs or code; use the variable as the single source of truth).

Use `DEV_HOST` as the source of truth for the integration target. Build endpoint URLs from this host only when needed (for example `http://<DEV_HOST>/...`). Treat it as a shared test instance: avoid destructive actions unless the user explicitly requests them.

When work depends on that host, confirm `DEV_HOST` is set, verify connectivity and relevant ports or services, and review `docker compose` (or equivalent) for the stack before state-changing or destructive steps.

### Mandatory rules
1. **Language:** All code, identifiers, comments, and docstrings must be in **English**. User-facing UI copy may follow product language when explicitly specified; otherwise keep it in English.
2. For any code change (creation, refactor, organization, readability improvement):
   - use the `code-style` skill during implementation to ensure style, formatting, and programming consistency
   - if `code-style` is unavailable in the current runtime, apply equivalent project conventions explicitly as fallback
3. The `code-style` skill must be re-applied at the end of every code change, without exception; if unavailable, run the same final style pass manually.
4. For **logging** (adding, changing, or reviewing log statements, logger setup, or logging config):
   - use the `log-writer` skill first; then apply `code-style` as usual for the rest of the change
5. For structure or architecture (new modules, packages, folders, file organization):
   - consult the `architect` skill to follow project standards (simple names, correct locations, one purpose per module)
6. For frontend (React/Next.js): pages, components, layouts, and UI flows
   - consult the `frontend` skill for stack-specific UI patterns and conventions (components, state, layout, callbacks, styling)
   - use `architect` for placement and file/module boundaries when frontend work requires structural decisions
   - keep `code-style` as the final style pass for naming, formatting, imports, file order, and readability; do not use it as a substitute for frontend architecture decisions
7. For any task related to Git or GitHub:
   - use the `github-assistant` skill
   - for commit subjects from diffs, use `skills/github-assistant/docs/commit-messages.md`
   - follow repository commit style (English, no Conventional Commits prefixes such as `feat:` / `fix:`, imperative or descriptive subjects consistent with existing history)
8. If there is a request for documentation files (`README.md` or other project `.md` docs):
   - use the `readme-writer` skill
9. When the task changes code, perform a **final implementation review** before concluding (see [Final implementation review](#final-implementation-review)). Do not finish while requirements, style, or obvious quality gaps in scope are unresolved.
10. **Tests:** Do **not** create automated tests, test suites, or **test files** (for example `test_*.py`, `*_test.rs`, `*.spec.ts`, `__tests__/`, or new files under `tests/`) unless the user **explicitly** asks for them. You do not need to add tests by default. If you create tests only for temporary debugging or validation, delete them before finishing.
11. Optional skills (use when the task matches):
   - **`playwright`**: automating a real browser from the terminal (navigation, forms, snapshots, UI debugging)
   - **`feature-overview`**: short internal feature overviews (behavior, impact, constraints, next steps)

### Default execution order
Apply only the skills relevant to the task scope.

1. Structure/architecture: `architect` (when creating modules, packages, or reorganizing)
2. Logging: `log-writer` (when adding, changing, or reviewing logs)
3. Frontend: `frontend` (when creating or modifying React/Next.js code)
4. Browser automation: `playwright` (when the task requires driving a real browser from the CLI)
5. Internal product summary: `feature-overview` (when the deliverable is a team-facing feature overview)
6. Implementation/refactor: `code-style`
7. Final pass: [Final implementation review](#final-implementation-review), then `code-style` on all touched files
8. Git helper behaviors: `github-assistant` (when requested)

### Final implementation review

Run this checklist **after** implementation and **before** reporting the task as done whenever the change set includes code (no separate skill—do it in the session).

- **Requirements:** Confirm the user’s request is fully addressed within the agreed scope (no missing pieces, no partial behavior unless explicitly out of scope).
- **Quality pass:** Scan changed files for correctness, unintended edits, temporary debug code, and inconsistencies with surrounding modules.
- **Code style:** Confirm the `code-style` skill was applied to every modified file; if anything was skipped or regressed, re-apply `code-style` before finishing.
- **Diagnostics:** When editor or project diagnostics exist for edited files, fix new issues introduced by the change before concluding.

### Expected agent behavior
- **English:** Same as rule 1 for code and commits. Keep `AGENTS.md` and skill text in English.
- **Names:** Prefer short, clear names for folders and files under `skills/` (match existing skill folder style).
- **Before you finish:** Follow rule 9 and the [Final implementation review](#final-implementation-review) section for any code change—no skipping the review or final `code-style` pass.
- Say in one line which skills you will use, in order.
- If a required skill is missing in the runtime, say so and match its standards by hand.
- Prefer the smallest change that meets the request; use the skills that fit the task.
- **Tests:** Same as rule 10—no new test files unless the user asked; delete scratch tests before done.
- **Style guides:** In mixed repos, use the `code-style` skill docs per language (`docs/typescript.md`, `docs/python.md`, `docs/rust.md`, etc.). For React UI, follow the `frontend` skill doc plus `code-style/docs/typescript.md`.

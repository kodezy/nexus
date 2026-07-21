# AGENT CONTRACT (Production Standard)

## 1) Identity
- Role: coding agent operating inside Cursor IDE for this repository.
- Mode: pragmatic execution with minimal complexity and clear outcomes.
- Scope: code, docs, and automation tasks requested by the user.

## 2) Mission
- Deliver correct, simple, production-ready changes.
- Prefer the smallest solution that solves the request.
- Keep behavior predictable and easy to review.

## 3) Capabilities
- Read, edit, and organize project files.
- Run shell commands, validations, and Git workflows.
- Use skills and tools to improve consistency and reliability.
- Delegate only when parallelism or broader exploration is needed.

## 4) Inputs
- User request and repository context.
- Existing project rules and available skills.
- Current workspace state (files, diagnostics, terminal context).
- Optional environment settings (for example `DEV_HOST`).

## 5) Outputs (Strict Contract)
- Primary output: concrete repository changes that match the request.
- Response output:
  - what changed
  - why it changed
  - how to verify (when relevant)
- For agent-to-agent handoff, prefer structured payloads:
  - `task`
  - `actions_taken`
  - `files_changed`
  - `results`
  - `blockers`
  - `next_step`

## 6) Decision Rules
- One agent, one clear responsibility per task.
- Prefer direct execution for small and clear tasks.
- Use subagents only for broad exploration, long multi-step work, or independent parallel streams.
- Avoid overengineering: choose the lowest complexity that satisfies quality and scope.
- Before execution, state in one line which skills will be used, in order.
- Before creating a new file, folder, or module: apply `architect`.
- Before concluding a change: apply `code-style` to all touched files.

## 7) Execution Loop
1. Plan: understand request, constraints, and success criteria.
2. Act: implement the smallest valid change.
3. Observe: inspect diffs, outputs, and diagnostics.
4. Validate: verify requirements and obvious regressions.
5. Store: keep artifacts and messages concise and traceable.
6. Feedback: refine when evidence shows gaps.

## 8) Constraints and Guardrails
- Language:
  - code, identifiers, comments, docstrings, commits, and `AGENTS.md` content must be in English
  - UI copy can follow product language only when explicitly requested
- Safety:
  - do not invent facts
  - do not perform destructive actions without explicit user intent
  - do not hardcode infrastructure hosts when `DEV_HOST` is the contract
- Test policy:
  - do not create automated test files unless the user explicitly asks
  - remove temporary scratch tests before finishing
- Git policy:
  - follow repository commit style
  - do not use Conventional Commit prefixes unless the repository explicitly adopts them
  - never commit Superpowers implementation docs or plans (`docs/superpowers/`, including `plans/` and `specs/`) unless the user explicitly asks to include them
  - when staging commits, exclude those paths by default even if they appear in `git status` or plan checklists
  - never create a git worktree without asking the user first; if a worktree seems useful, ask whether to create one and wait for an explicit yes before running any worktree create command
- Python tooling:
  - use **uv** for Python dependencies and execution (`uv add`, `uv remove`, `uv sync`, `uv run`)
  - treat `pyproject.toml` (and the lockfile uv manages) as the source of truth
  - do not use bare `pip install` or hand-edit `requirements.txt` unless the user explicitly asks, or the repository has no uv/`pyproject.toml` workflow and local convention is pip-only
  - detailed placement and commands: `architect` → `docs/python.md`
- Naming & structure:
  - prefer single-word names for new files, modules, folders, and packages (use the project's existing casing; Python/Rust usually `snake_case`; new TypeScript/React two-word files prefer kebab-case unless the folder already uses `_`; skill folders may stay kebab-case when that is the local pattern)
  - if one word is not enough, use at most two words with one separator; avoid longer compounds
  - prefer extending an existing module over creating a new file when responsibility matches
  - match existing project patterns for placement, casing, and layout before inventing a new structure
  - tests are exempt from the single-word file rule; follow project test naming
  - identifiers (methods, parameters, constants, variables): use clear, pragmatic, intent-revealing names; avoid obscure abbreviations; follow language casing in `code-style`
  - class / `impl` member order: constructor or essential dunders first, then other public methods, then private methods last; never place private members above remaining public members for grouping
  - module-level order: public or exported API first, private helpers last; in TypeScript, default export is last among publics and still before private helpers
  - when editing a file, normalize that file's member/module order and fix obviously unclear names only; do not sweep untouched files for style
  - keep detailed guidance in `architect` and `code-style`; this contract states the hard defaults only

## 9) Failure Handling
- On failure, follow this order:
  1. retry with corrected input/context
  2. apply a safer fallback path
  3. escalate with a clear blocker report
- Blocker reports must include:
  - attempted action
  - observed error
  - likely cause
  - next best action

## 10) Observability (Logs and Metrics)
- Every substantial task should leave clear traceability:
  - commands executed (when relevant)
  - files changed
  - validation performed
  - unresolved risks or follow-ups
- Keep logs concise and useful for debugging and review.

## 11) Integration (Skills, Tools, and APIs)
- Mandatory skill policy for code changes:
  - apply relevant skills before implementation
  - always run `code-style` during implementation and as a mandatory final pass on every touched file before concluding
  - if a required skill is unavailable, explicitly state fallback behavior and apply equivalent standards manually
- Required skill routing:
  - Git/GitHub tasks (status, diff, log, commit messages, commits, branch/remote advice, and related in-repo git hygiene): always `git-assistant`
  - Logging changes: `log-writer` then `code-style`
  - Architecture (elaborate, plan, or create modules, folders, packages, boundaries, or new-file placement): always `architect`
  - React frontend work (Vite SPA, React Router, or Next.js): `frontend` (+ `architect` when structural decisions are involved)
  - Documentation (`README.md`): `readme-writer`
- Optional skills:
  - `playwright` for browser automation
- Integration test server contract:
  - use `DEV_HOST` as the single source of truth for target host
  - build URLs from `DEV_HOST` only when needed
  - treat the shared environment as non-destructive by default
  - before state-changing operations, confirm `DEV_HOST`, connectivity, and relevant service stack state

## Final Implementation Review (Required for Code Changes)
- Confirm requirements are fully addressed in scope.
- Review diffs for unintended edits and temporary debug residue.
- Delimit the affected feature area (modules, callers, and paths in the flow — not the whole repository).
- Remove obvious dead code in that area (unreferenced symbols, unreachable branches, orphaned helpers/exports left by the change).
- Remove obvious legacy fallback / shim / compat paths when the new path is the only live path.
- Remove obvious residues (temporary debug, dead flags, completed-migration TODOs, precautionary adapters).
- If doubt or risk remains (external compat, still-active feature flag, uncertain callers): do not delete; report in `blockers` / `next_step` and do not conclude as clean.
- Keep the diff focused: cleanup only within the affected area; no mass refactor.
- Fix diagnostics introduced by the change.
- Confirm naming and placement match this contract and local project patterns.
- Confirm touched files follow public-before-private member/module order and clear identifier naming per this contract and `code-style`.
- Confirm `architect` was used if any structure or architecture decision was made.
- Re-apply `code-style` to all touched files before concluding.

## Version
- Agent Contract Version: `v1.3.0`

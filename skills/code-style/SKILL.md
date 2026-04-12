---
name: code-style
description: Apply coding style standards for readability, consistency, and formatting without changing business behavior. Use when implementing code, adjusting style, standardizing patterns, formatting modules/files, or finalizing a change set with consistent code conventions.
---

# Code Style Standards

## Objective

Apply a clear, pragmatic, and consistent coding style to the codebase. This skill is not limited to refactoring requests: it defines formatting, naming, organization, and style conventions to be used as the default finalization step in code changes.

## Language/Area Selection (Auto)

Choose style rules based on project signals and target area, then apply only the relevant subset:

1. React/TypeScript UI or frontend areas:
   - Signals: `tsx`, `jsx`, `ts`, React components/hooks, frontend folders (`src/components`, `src/features`, `app`, `pages`).
   - Use: `docs/react.md`.
2. Python backend/scripts/data areas:
   - Signals: `py`, `pyproject.toml`, `requirements.txt`, Python package/module layout.
   - Use: `docs/python.md`.
3. Rust backend/systems/CLI areas:
   - Signals: `rs`, `Cargo.toml`, modules under `src/` in Rust projects.
   - Use: `docs/rust.md`.
4. Logging (add, change, or standardize log calls):
   - Signals: log statements, `logger.*`, `logging`, `setup_logger`, logging configuration.
   - **Use the `log` skill** for all logging decisions and implementation. Do not handle logging inside code-style.
5. Mixed repositories:
   - Apply language-specific docs per file/module.
   - Apply Canonical Rules from this `SKILL.md` as shared baseline.

If repository style conflicts with generic guidance, local project conventions win.

## Canonical Rules (Embedded In Skill)

1. **English:** All code, identifiers, comments, and docstrings in English (per project AGENTS.md).
2. Preserve behavior: style changes must not alter business logic, return values, side effects, or data flow.
3. Prefer clarity over cleverness: use the simplest structure that remains easy to maintain.
4. Keep local consistency: match dominant style from the target file and adjacent modules.
5. Enforce readable naming: names should communicate intent with minimal ambiguity.
6. Keep formatting uniform: spacing, blank lines, and wrapping should be predictable and stable.
7. Apply minimal viable changes: avoid broad rewrites when a focused style update solves the task.
8. Minimal docs and comments: add docstrings/doc comments only when necessary (e.g. public API, non-obvious logic); prefer self-explanatory code.

## Style Scope

- Standardize formatting and layout.
- Enforce naming consistency.
- Organize code blocks and method ordering.
- Improve structural readability when the change is small and safe.
- Finalize code with a coherent programming style baseline.

## Naming Conventions

- Functions/methods: use verb-oriented names that describe behavior (`calculate_total`, `validate_token`).
- Types/classes/components: use singular noun-based names (`User`, `PaymentService`, `OrderCard`).
- Variables: prefer explicit names over abbreviations (`customer_id` over `cid`).
- Booleans: use intent-revealing prefixes (`is_`, `has_`, `can_`, `should_`).
- Rename only when clarity gain is clear, and always update all references.

## Organization Rules

- Keep public APIs before private helpers when language conventions support this.
- Group related methods/functions by responsibility.
- Keep imports/includes ordered according to the dominant local style.
- Avoid deep nesting when a guard clause or early return improves readability.

## Formatting

- Follow the project’s formatter and linter (e.g. Black, Ruff, Prettier, rustfmt) when present; otherwise match the style of the file and adjacent modules.
- Keep indentation and spacing consistent; avoid unnecessary blank lines.

### Python: mandatory blank-line block separation

When touching Python code, enforce **exactly one** blank line between logical blocks. This is mandatory even if the surrounding file is inconsistent.

Use **one blank line** (never two) to separate:

- **Variable collection / normalization** (parsing, conversions, primary locals)
- **Guard clauses / validations** (early `continue`/`return`/`raise` checks)
- **Main effect** (core loop body, IO, mutations, writes)
- **Post-processing** (sorting, dedupe, aggregation)
- **Final return** (the “real” output / terminal return)

Also enforce:

- Do not “stick” assignments directly to a control block. If an `if`/`for`/`try` begins a new logical phase, there must be **one blank line** before it.
- Do not insert extra blank lines inside a single logical block.
- Avoid stacked `if` blocks with no separation when they represent different phases (e.g., validations vs main effect).

## Workflow

1. Inspect target file and nearby files to learn existing style conventions.
2. Detect language/area and load the matching internal doc.
3. Apply code-style rules with minimal, behavior-safe changes.
4. Normalize naming, formatting, and organization where there is clear value.
5. Run project formatter/linter if available and aligned with the repository.
6. Review diff to confirm style gains without logic changes.

## Checklist Before Finishing

- Behavior is unchanged.
- Formatting is consistent and clean.
- Naming is clear and coherent.
- Organization improves readability.
- Diff stays focused and pragmatic.

## Internal Skill Docs

Use this skill as the source of truth for code style decisions. For a compact operational reference, see:

- `docs/react.md`
- `docs/python.md`
- `docs/rust.md`

For any logging (messages, levels, structure), use the **log** skill.

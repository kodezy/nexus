---
name: code-style
description: Apply coding style standards for readability, consistency, and formatting without changing business behavior. Use when implementing code, adjusting style, standardizing patterns, formatting modules/files, or finalizing a change set with consistent code conventions.
---

# Code Style Standards

## Objective

Apply a clear, pragmatic, and consistent coding style to the codebase. This skill is not limited to refactoring requests: it defines formatting, naming, module boundaries, and organization conventions to be used as the default finalization step in code changes.

Boundary: this skill standardizes how code is written. It does **not** replace stack-specific implementation guidance such as React component architecture, state design, layout patterns, or data fetching shape (`frontend`), and it does **not** replace file/module placement or file names (`architect`). For React work (Vite SPA or Next.js): `frontend` (+ `architect` when placing or naming files) first, then apply `code-style`.

## Language/Area Selection (Auto)

Choose style rules based on project signals and target area, then apply only the relevant subset:

1. TypeScript and React:
   - Signals: `ts`, `tsx`, `jsx`, React components/hooks, shared frontend utilities, API client modules.
   - Use: `docs/typescript.md` for `.ts`, `.tsx`, and `.jsx` rules (including React component structure and ordering).
2. Python backend/scripts/data areas:
   - Signals: `py`, `pyproject.toml`, `uv.lock`, `requirements.txt`, Python package/module layout.
   - Use: `docs/python.md` for style (prefer current stable Python 3.13+ for greenfield; honor repo pins). Dependency installs and runs belong to `architect` (`docs/python.md`), not this skill.
3. Rust backend/systems/CLI areas:
   - Signals: `rs`, `Cargo.toml`, modules under `src/` in Rust projects.
   - Use: `docs/rust.md` (stable toolchain; edition 2024 greenfield when available, else 2021+).
4. Mixed repositories:
   - Apply language-specific docs per file/module.
   - Apply Canonical Rules from this `SKILL.md` as shared baseline.

If repository style conflicts with generic guidance, local project conventions win.

## Canonical Rules (Embedded In Skill)

1. **English:** All code, identifiers, comments, and docstrings in English (per Nexus contract).
2. Preserve behavior: style changes must not alter business logic, return values, side effects, or data flow.
3. Prefer clarity over cleverness: use the simplest structure that remains easy to maintain.
4. Keep local consistency: match dominant style from the target file and adjacent modules.
5. Enforce readable naming: names should communicate intent with minimal ambiguity.
6. Prefer simple file names: single-word when possible; at most two words when needed. Python/Rust use `_`; new TypeScript/React files prefer kebab-case unless the folder already uses `_` (see `architect` for placement). Tests are exempt from this pattern.
7. Prefer fewer files with better cohesion: keep related logic together unless there is a clear boundary to split.
8. Keep formatting uniform: spacing, blank lines, and wrapping should be predictable and stable.
9. Apply minimal viable changes: avoid broad rewrites when a focused style update solves the task.
10. **Docs and comments:** default is none. Add docstrings, `///`/`//!`, or line comments only when necessary (e.g. public API, non-obvious logic, safety notes); prefer self-explanatory code. Language specifics: `docs/typescript.md`, `docs/python.md`, `docs/rust.md`.
11. Keep code direct and pragmatic: avoid indirection and abstraction without clear readability or maintenance gain.
12. **Version-aware idioms:** match the repo's declared language/runtime version and prefer current idioms it supports. Do not add compatibility boilerplate (e.g. Python `from __future__ import annotations`, TypeScript `namespace`, Rust pre-2018 patterns) unless a concrete need exists. Language specifics: `docs/python.md`, `docs/typescript.md`, `docs/rust.md`.

## Style Scope

- Standardize formatting and layout.
- Enforce naming consistency.
- Keep module boundaries clean while minimizing unnecessary file count.
- Organize code blocks and method ordering.
- Improve structural readability when the change is small and safe.
- Finalize code with a coherent programming style baseline.

## Naming Conventions

- Functions/methods: use verb-oriented names that describe behavior (`calculate_total`, `validate_token`).
- Types/classes/components: use singular noun-based names (`User`, `PaymentService`, `OrderCard`).
- Variables: prefer explicit names over abbreviations (`customer_id` over `cid`).
- Booleans: use intent-revealing prefixes (`is_`, `has_`, `can_`, `should_`).
- Files/modules: prefer single-word names (`parser.py`, `cache.rs`, `route.tsx`). If needed, at most two words — Python/Rust with `_` (`create_order.py`); new TypeScript/React with kebab-case (`price-scatter.ts`) unless the folder already uses underscores. Avoid longer compounds (`market.py` over `market_data_processing_service.py`).
- Tests: naming pattern above does not apply; follow project test conventions.
- React components: `PascalCase` filenames (`Card.tsx`) when the project already uses that pattern.
- Rename only when clarity gain is obvious (obscure abbreviation, mixed convention in the same file). Skip cosmetic renames. Update references in the touched file.
- **TypeScript / React:** `camelCase` for functions and variables; `PascalCase` for types and components; hooks as `useSomething` (`camelCase`); module-level constants `UPPER_SNAKE_CASE`. Module layout and React component ordering: `docs/typescript.md`.

## Module order (by language)

Top-to-bottom intent (full steps in each language doc):

| Layer | Python | Rust | TypeScript |
| --- | --- | --- | --- |
| **Imports** | Top (`import` / `from`); optional `from __future__ import …` only when required (after docstring, before imports). | Top (`use`; see `docs/rust.md` for `mod` / inner attrs before `use`). | Top (`import`; include `import type` here). |
| **Constants** | Immediately after imports. | Immediately after the import block (`const` / `static` / `type` aliases). | **After** `type` / `interface` (not immediately after imports). |
| **Types** | Optional: hints on names; no top types block unless needed (e.g. `TYPE_CHECKING`). | Central: `struct` / `enum` / `trait`, then `impl`. | **First-class:** dedicated `type` / `interface` block high in the file. |
| **Classes / ADTs** | `class` after constants (before module-level `def`). | `struct` / `enum` (and `trait`) before matching `impl`. | `class` before module-level functions. |
| **Implementation** | Methods **inside** the `class` body. | Methods and trait items in **`impl`**, separate from type definitions. | Methods **inside** the `class` body. |
| **Module functions** | After classes: public free functions first, private (`_`) helpers last. | Free `fn` after the type/`impl` chain: public first, private last. | After classes: exported functions/components first (default export last among publics), non-exported helpers last. |
| **Entry** | `if __name__ == "__main__":` last. | `fn main` last in the binary crate root. | No runtime `main`; wire entry explicitly (bundler/CLI/test bootstrap). |

`.tsx` module order follows `docs/typescript.md` (same **types → constants** idea as `.ts`).

## Constants

Apply these rules whenever declaring module-level or shared immutable values:

1. **One constant per line.** Do not declare multiple unrelated constants on the same line.
2. **Group by domain.** Separate related constant groups with one blank line. Use language-specific grouping when it improves scanability (e.g. Rust `mod`, Python `Enum`/`dataclass`, TypeScript `as const` object).
3. **Readability over brevity.** Prefer clear layout and stable Git diffs over minimizing line count.
4. **Prefer structured config over constant sprawl.** When several constants represent one concept (timeouts, limits, feature flags, endpoint paths), replace scattered globals with a typed configuration object, struct, record, enum, or dedicated module instead of adding more top-level constants. This is an intentional exception to Canonical Rule 11 when the grouped shape is clearer than more globals.

Language-specific placement and examples: `docs/typescript.md`, `docs/python.md`, `docs/rust.md`.

## Organization Rules

- Keep imports/includes at the top of the file, grouped and consistently ordered.
- **Constants:** after imports in Python and Rust; **after types** in TypeScript and `.tsx` (see table above). Follow the **Constants** section above for layout and grouping.
- Keep public APIs before private helpers at module level and inside classes/`impl`.
- In classes/`impl` blocks, order is strict: constructor or essential dunders first, then other public methods, then private methods last.
- Group related methods only within the same visibility band (among publics, or among privates); never interleave private above remaining public for “logical” grouping.
- When touching a file, normalize that file's order and fix obviously unclear names; do not style-sweep untouched files.
- Avoid deep nesting when a guard clause or early return improves readability.
- Prefer keeping related code in existing modules when cohesion remains clear.
- Split into a new file only with a clear boundary (different responsibility, independent lifecycle, stable reuse by 2+ modules, or readability loss from mixed concerns).

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
2. Detect language/area and load the matching internal doc(s) (for React UI, `docs/typescript.md`).
3. Apply code-style rules with minimal, behavior-safe changes.
4. Normalize naming, formatting, and organization where there is clear value.
5. Run project formatter/linter if available and aligned with the repository.
6. Review diff to confirm style gains without logic changes.

### Final pass order (code changes)

1. Implement the task.
2. Area cleanup (obvious removals; escalate doubt) — see Area Cleanup below.
3. Apply naming / order / format rules from this skill to every touched file.
4. Run `integrity-review` (canonical closeout: area review, verdict, commit handoff).

## Area Cleanup (final pass)

Apply this pass to the **affected feature area**, not the whole repository and not only the diff hunks.

### Delimit the area

- Start from touched files.
- Include modules in the same flow: direct callers/callees, re-exports, and tests/fixtures for that flow.
- Stop at the feature boundary; do not sweep unrelated neighbor packages.

### Remove when obvious

- Function / type / constant with no remaining references in the area after the change
- Dead branch / `if` / `match` left by a migration
- Old fallback path when the new path is the only one used
- Debug prints, dead flags, migration TODOs/comments already completed
- Session scratch / temp left behind

### Escalate (do not remove without evidence)

- Public API / external contract
- Compat still required for a supported client or version
- Feature flag without confirmation it is off / removed
- Code that looks unused but may have dynamic callers or callers outside the area

When escalating: leave the code in place, report it in `blockers` / `next_step`, and do not conclude the task as clean.

## Checklist Before Finishing

- Behavior is unchanged.
- Formatting is consistent and clean.
- Naming is clear and coherent.
- Production file names prefer single-word (two words max; Python/Rust `_`, new TS/React kebab-case unless local folder uses `_`); tests exempt.
- Related logic is not fragmented across unnecessary files.
- Organization improves readability; constants follow the **Constants** section (one per line, grouped by domain).
- Diff stays focused and pragmatic.
- Affected area has no obvious dead code, legacy fallback, or residue left by this change.
- Ambiguous leftovers are reported in `blockers` / `next_step` (not silently kept as “done”).

## Internal Skill Docs

Use this skill as the source of truth for code style decisions. For a compact operational reference, see:

- `docs/typescript.md`
- `docs/python.md`
- `docs/rust.md`

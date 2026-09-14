---
name: code-style
description: Apply coding style standards for readability, consistency, and formatting without changing business behavior. Use when touched code needs style alignment beyond what local conventions already show—not on every change.
---

# Code Style Standards

## Objective

Apply a clear, pragmatic, and consistent coding style when touched code needs alignment beyond what adjacent modules and project tooling already establish. Load this skill proportionally—skip it for trivial one-line fixes that already match local conventions.

Boundary: this skill standardizes how code is written. It does **not** replace UI structure, state, layout, or data-fetching shape (`frontend`), file/module placement or file names (`architect`), or logging levels, messages, and logger setup (`log-writer`). For UI work: `frontend` (+ `architect` when placing or naming files) first, then apply `code-style`.

## Adaptive rule (read first)

1. Read the target file and 1–2 adjacent modules in the same package.
2. If the repository has a formatter/linter config, follow it.
3. If local style conflicts with this skill, **local conventions win**.
4. When no local pattern exists (greenfield), load the language doc **only if one exists for that file** (`docs/typescript.md`, `docs/python.md`, or `docs/rust.md`); otherwise follow formatter/linter defaults and defer file placement to `$architect`.
5. Apply only rules needed for the touched lines — do not style-sweep untouched files.
6. File and folder placement/naming: defer to `$architect` (this skill handles in-file formatting and order only).

## Language/Area Selection (Auto)

Choose style rules based on project signals and target area, then apply only the relevant subset:

1. TypeScript / JavaScript:
   - Signals: `ts`, `tsx`, `jsx`, `js`, `mjs`, shared frontend utilities, API client modules.
   - Use: `docs/typescript.md` when those files are in the change. Skip React-specific ordering in that doc when the file is not React.
2. Python:
   - Signals: `py`, `pyproject.toml`, `uv.lock`, `requirements.txt`.
   - Use: `docs/python.md` when those files are in the change. Honor repo pins. Dependency installs belong to `architect`, not this skill.
3. Rust:
   - Signals: `rs`, `Cargo.toml`.
   - Use: `docs/rust.md` when those files are in the change.
4. Other languages:
   - Apply Canonical Rules from this `SKILL.md` and local formatter/linter output. Do not force a Nexus language doc.
5. Mixed repositories:
   - Apply language-specific docs per file only when a matching doc exists.

If repository style conflicts with generic guidance, local project conventions win.

## Canonical Rules (Embedded In Skill)

1. **English:** All code, identifiers, comments, and docstrings in English (per Nexus contract).
2. Preserve behavior: style changes must not alter business logic, return values, side effects, or data flow.
3. Prefer clarity over cleverness: use the simplest structure that remains easy to maintain.
4. Keep local consistency: match dominant style from the target file and adjacent modules.
5. Enforce readable naming: names should communicate intent with minimal ambiguity.
6. **File and module names:** defer to `$architect` and local project patterns (this skill does not own placement).
7. **Module cohesion:** prefer fewer files with clear boundaries; package layout follows `$architect`.
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

- File and module names: follow `$architect` and local project patterns.
- Identifiers inside files: verb-oriented functions, noun types/components, explicit variables, boolean prefixes (`is`/`has`/`can`) in the language's case.
- UI component filenames: match the local pattern (do not invent PascalCase or kebab-case).
- Rename only when clarity gain is obvious; skip cosmetic renames.

## Module order (by language)

Apply only when touching a file whose order is already inconsistent with nearby modules. Do not reorder greenfield-correct files for ceremony.

Top-to-bottom intent (full steps in each language doc):

| Layer | Python | Rust | TypeScript |
| --- | --- | --- | --- |
| **Imports** | Top (`import` / `from`); optional `from __future__ import …` only when required (after docstring, before imports). | Top (`use`; see `docs/rust.md` for `mod` / inner attrs before `use`). | Top (`import`; include `import type` here). |
| **Typing** | `if TYPE_CHECKING:` imports, then `TypeVar` / `ParamSpec` / `type` aliases after runtime imports — **before constants**. | `type` aliases with the constants block. | **First-class:** dedicated `type` / `interface` block after imports. |
| **Constants** | Immutable `UPPER_SNAKE_CASE` (module-private: `_UPPER_SNAKE_CASE`) after typing. | Scalar `const` / `static` immediately after imports (see `docs/rust.md` for `static` split). | **After** `type` / `interface`. |
| **Logger / infra** | Module `logger` and one-shot setup after constants (`log-writer` for setup). | `static` / `LazyLock` / `OnceLock` for shared clients after scalar constants. | Scoped logger instance after constants (`log-writer` for setup). |
| **Module state** | Mutable `_`-prefixed globals after logger/infra. | Mutable `static` / interior-mutability globals after infra. | Module-level caches, maps, singleton refs after logger/infra. |
| **Classes / ADTs** | `class` after module state (before module-level `def`). | `struct` / `enum` / `trait`, then `impl`. | `class` before module-level functions. |
| **Implementation** | Methods **inside** the `class` body. | Methods and trait items in **`impl`**, separate from type definitions. | Methods **inside** the `class` body. |
| **Module functions** | After classes: public free functions first, private (`_`) helpers last. | Free `fn` after the type/`impl` chain: public first, private last. | After classes: exported functions/components first (default export last among publics), non-exported helpers last. |
| **Entry** | `if __name__ == "__main__":` last. | `fn main` last in the binary crate root. | No runtime `main`; wire entry explicitly (bundler/CLI/test bootstrap). |

**Dependency order wins** in every language: if reordering changes initialization or import-time behavior, keep the order that preserves correctness.

**Module-level blank lines (all languages):** **one** blank line between groups in the same layer and between module-order layers (typing → constants → logger → state). **Never** double-space every phase. **Python only:** **two** blank lines before a top-level `class` or `def` (PEP 8). TypeScript and Rust: one blank line between top-level items (match Prettier/rustfmt).

`.tsx` module order follows `docs/typescript.md` (same **types → constants → logger/infra → module state** idea as `.ts`).

## Constants

Apply these rules whenever declaring module-level or shared immutable values:

1. **One constant per line.** Do not declare multiple unrelated constants on the same line.
2. **Group by domain.** Separate related constant groups with one blank line. Use language-specific grouping when it improves scanability (e.g. Rust `mod`, Python `Enum`/`dataclass`, TypeScript `as const` object).
3. **Readability over brevity.** Prefer clear layout and stable Git diffs over minimizing line count.
4. **Prefer structured config over constant sprawl.** When several constants represent one concept (timeouts, limits, feature flags, endpoint paths), replace scattered globals with a typed configuration object, struct, record, enum, or dedicated module instead of adding more top-level constants. This is an intentional exception to Canonical Rule 11 when the grouped shape is clearer than more globals.

Language-specific placement and examples: `docs/typescript.md`, `docs/python.md`, `docs/rust.md`.

## Variables

Apply these rules to module-level mutable state and to locals inside functions (same grouping model as **Constants**):

1. **One variable per line.** Do not declare multiple unrelated variables on the same line.
2. **Group by domain.** Separate related variable groups with one blank line—the same rule as **Constants**. At module level, apply in the **module state** layer. Inside functions, apply **within** a coarse phase when locals fall into distinct domains; coarse phase separation still applies between phases.
3. **Readability over brevity.** Prefer clear layout and stable Git diffs over minimizing line count.
4. **Naming:** use language conventions (`snake_case` / `camelCase`); do not use `UPPER_SNAKE_CASE` for mutable variables. Module-private globals follow each language doc (e.g. `_` prefix in Python). Parameters keep contract names with no `_` prefix.

Language-specific placement and examples: `docs/typescript.md`, `docs/python.md`, `docs/rust.md`.

## Organization Rules

- Keep imports/includes at the top of the file, grouped and consistently ordered. Prefer top-level imports/`use`; use a local import only for lazy loading or to break a real circular dependency (see language docs).
- **Constants:** after typing in Python; after imports (with `type` aliases) in Rust; **after types** in TypeScript and `.tsx` (see table above). **Logger/infrastructure** and **module state** follow constants in that order when present. Follow the **Constants** section above for layout and grouping.
- **Variables (module state and locals):** follow the **Variables** section above—one per line, grouped by domain with one blank line between groups.
- When a signature or call has many parameters that already form clear groups, prefer a typed options/config object or a small helper over a long flat argument list. Do not invent wrappers for short, clear signatures (same exception to Canonical Rule 11 as structured constants).
- Keep failure-handling scopes small: wrap only the statement(s) that can fail (Python `try`/`except`/`finally`, TypeScript `try`/`catch`/`finally`, Rust `?` or a narrow `match`). Do not extract a helper solely to shrink a `try` block.
- Keep public APIs before private helpers at module level and inside classes/`impl`.
- In classes/`impl` blocks, order is strict: constructor or essential dunders first, then other public methods, then private methods last.
- Group related methods only within the same visibility band (among publics, or among privates); never interleave private above remaining public for “logical” grouping.
- When touching a file, normalize that file's order and fix obviously unclear names; do not style-sweep untouched files.
- Avoid deep nesting when a guard clause or early return improves readability.
## Formatting

- Follow the project’s formatter and linter (e.g. Black, Ruff, Prettier, rustfmt) when present; otherwise match the style of the file and adjacent modules.
- Keep indentation and spacing consistent. Use blank lines only at **coarse phase** boundaries inside functions; do not blank-line inside a single phase, and do not insert blank lines inside argument lists.
- Do not use comments to label or separate phases, argument groups, or blocks — structure and blank lines are enough (Canonical Rule 10).

### Line length and wrapping

- Use the project's configured line limit (`pyproject.toml` / Ruff / Black `line-length`, Prettier `printWidth`, rustfmt `max_width`).
- Keep statements, calls, and simple `raise` / `return` / `throw` expressions on **one line** when the full line (including indentation) fits within that limit.
- Do **not** pre-break lines that fit — agents and formatters should not expand vertically when horizontal space remains.
- Do **not** add a **trailing comma** inside `(...)`, `[...]`, or `{...}` when a single-line form fits; Black, Ruff, and Prettier treat it as a signal to expand to multiple lines.
- Language specifics: `docs/python.md`, `docs/typescript.md`, `docs/rust.md`.

### Module-level blank lines

- **One** blank line between import groups, between module-order layers (typing → constants → logger/infra → state), and between constant or variable domains in the same layer.
- **Never** use two blank lines between those layers — order already signals structure; double-spacing adds noise.
- **Python:** **two** blank lines only before a top-level `class` or `def` (PEP 8).
- **TypeScript / Rust:** one blank line between top-level declarations; follow Prettier or rustfmt when present.
- **Inside functions / methods / impl blocks:** exactly **one** blank line between coarse phases when the body has two or more steps (see below); never two. A single-step body needs no extra blank lines.

### Coarse phase separation (all languages)

Separate function bodies into a few coarse phases with **exactly one** blank line between phases (never two). Use only the phases that apply; do not invent empty phases. Common phases:

- **Validation** — guards / early `return` / `raise`
- **Preparation** — locals, normalization, derived values
- **Main effect** — core work (IO, mutation, call)
- **Cleanup** — release / restore when present
- **Return** — terminal result

There is **no canonical prepare-vs-validate order**. Follow the function’s natural flow; skip phases that do not apply. Do **not** micro-split: related assignments in the **same domain** and the `if` that uses them stay together. **Within** a phase, group locals by domain with one blank line between domains (same rule as **Variables**). Prefer readable phase layout over minimizing line count. A short body with a single step needs **no** extra blank lines.

Language docs under Visual Block Separation show the same pattern. Python applies this when the body has two or more distinct steps (below).

### Python: blank-line block separation

When touching Python whose function/method body has **two or more distinct steps**, enforce **exactly one** blank line between those coarse phases — even if the surrounding file is inconsistent. Do not invent phases in a short, single-step body.

Typical phases (use only those that apply; order follows the function, not this list):

- **Validation** — guard clauses (early `continue`/`return`/`raise`)
- **Preparation** — variable collection / normalization (parsing, conversions, primary locals)
- **Main effect** — core loop body, IO, mutations, writes
- **Cleanup / post-processing** — sorting, dedupe, aggregation, resource release when present
- **Return** — the real output / terminal return

Also enforce:

- One blank line before `if`/`for`/`try` only when it **starts a new coarse phase**. Do not insert a blank line between assignments in the same domain group, or between an assignment and a guard that belongs to the same step.
- Within a phase, group locals by domain with one blank line between domains (same rule as **Variables**).
- Avoid stacked `if` blocks with no separation when they represent different phases (e.g., validations vs main effect).
- Keep `try`/`except`/`finally` bodies as small as practical (only the failing call and its direct handlers).

## Workflow

1. Inspect target file and nearby files to learn existing style conventions.
2. Detect language/area and load the matching internal doc only when that language is in the change.
3. Apply code-style rules with minimal, behavior-safe changes.
4. Normalize naming, formatting, and organization where there is clear value.
5. Run project formatter/linter if available and aligned with the repository.
6. Review diff to confirm style gains without logic changes.

### Final pass order (code changes)

1. Implement the task.
2. Apply naming, order, and format rules from this skill to every touched file (mirror local conventions or the language doc in greenfield).
3. Hand off to `$integrity-review` for verdict and closeout.

When cleanup, deduplication, legacy removal, or simplification is the primary goal, use `$code-cleanup` instead of expanding this pass.

## Checklist Before Finishing

- Behavior is unchanged.
- Formatting is consistent and clean.
- Naming is clear and coherent.
- Organization improves readability; constants and variables follow **Constants** / **Variables** (one per line, grouped by domain); function bodies use coarse phase blank lines (no comment separators).
- Diff stays focused and pragmatic.

## Internal Skill Docs

Optional language references — load only when those files are in the change:

- `docs/typescript.md`
- `docs/python.md`
- `docs/rust.md`

---
name: architect
description: Define and apply simple, clear, direct architecture. Use when creating modules, packages, or features so structure and naming follow the project's existing style. Prefer simple pragmatic names over compound names.
---

# Architect Standards

## Objective

Keep architecture simple, clear, and direct. Every new module, package, or feature must follow the same style and patterns as the current project. Prefer fewer files with well-defined modules, and use simple, pragmatic names for files and modules.

## Language / Area Selection

- **Python:** Use `docs/python.md` for backend, services, scripts, package layout, runtime (current stable / 3.13+ greenfield), and dependency/run workflow (uv preferred; Poetry/pip when local).
- **Rust:** Use `docs/rust.md` for crates, binaries, modules, package layout, and toolchain/Cargo (stable; edition 2024 greenfield when available).
- **TypeScript / React:** Use the File naming rules below (including the React/TS casing note). UI architecture and runtime (Vite vs Next) belong to `frontend`.
- Other languages: add docs when needed; prefer current stable toolchains when starting greenfield work.

## Canonical Rules

1. **English:** All code, identifiers, comments, docstrings, and file/module names in English (per Nexus contract).
2. **Match existing structure:** Place code in the same hierarchy the project already uses, organized by module/submodule (e.g. `src/api`, `src/services`, `src/ui/components`).
3. **Simple file names:** Prefer **single-word** names when possible (`parser`, `client`, `cache`, `route`). If one word is not enough, use **at most two words**. Default separator for Python/Rust is `_` (`create_order`, `sync_users`). For TypeScript/React, see File naming below (prefer kebab-case for new two-word `.ts`/`.tsx` files). Avoid longer compounds (e.g. `billing_webhook_processing_service`, `market_offer_creator`).
4. **Tests exempt:** Test files do not need this pattern; follow project test naming (`test_parser.py`, `orders_test.rs`, descriptive pytest names).
5. **Concept-first modules:** Design around cohesive concepts, not individual classes, functions, or file types. Prefer one module per concept, not one module per class. See **Module organization** below.
6. **Fewer files first:** Prefer extending an existing module when responsibility is the same and cohesion stays clear. Do not split solely to reduce file size or line count.
7. **Split only with clear boundary:** Create a new file/package only when at least one condition is true: multiple independent responsibilities, the module becomes difficult to navigate, multiple reasons to change, independent lifecycle, stable reuse by 2+ modules, or readability loss from mixed concerns.
8. **One clear purpose per module:** Each file or package should have a single, obvious responsibility.
9. **Flat when possible:** Avoid deep nesting; group by module, then keep submodules at one or two levels when it stays clear.
10. **No over-engineering:** Add layers (e.g. services, handlers, repositories) only when the project already uses them in that area.
11. **Local conventions win:** If the codebase does something different from this skill, follow the codebase.

## Module organization

Design modules around cohesive **concepts**, not around individual classes, functions, or file types.

- Prefer **one module per concept**, not one module per class.
- Keep related functionality together to minimize the context required to understand or modify a feature. Do not split modules solely to reduce file size or line count.
- Split a module only when it begins representing **multiple independent responsibilities**, becomes difficult to navigate, or has **multiple reasons to change**.
- Avoid generic catch-all modules such as `utils`, `helpers`, `common`, or `misc`. Place code in the module that owns the concept. When a shared abstraction naturally emerges, create a dedicated, well-named module for that responsibility (for example: `format`, `dates`, `validation` — not `utils`).
- Organize packages by **domain or subsystem** whenever practical. Within each package, prioritize cohesion, discoverability, and predictable locations over minimizing the number of files.
- When making structural changes, preserve or improve the project's architectural consistency instead of introducing unnecessary granularity.

## Scope

- Where to put new code (package and file location).
- How to name new modules, packages, and files.
- How to organize submodules (e.g. infra, services, tasks, components).
- When to add a new package vs. a new file in an existing package.
- When to keep logic in the current module to avoid unnecessary file proliferation.

## Workflow

1. Identify the module or submodule (e.g. `src/api`, `src/services`, `src/ui/components`).
2. Check how that module is structured (folders and naming pattern).
3. Try the smallest placement first: existing module, then existing package, then new file as the last option.
4. If a new file is required, validate the split criteria first, then choose a simple, descriptive name.
5. Place the new code in the same pattern (e.g. `src/services/notifier.py`, `src/tasks/sync.py`).
6. Expose public API via existing patterns (e.g. `__init__.py` with `__all__` where the project uses it).

## Checklist

- New code lives under the right module and follows existing hierarchy.
- File names prefer single-word; two words max with the language-appropriate separator (Python/Rust `_`, new TS/React kebab-case unless the folder already uses `_`); tests exempt.
- Python dependencies/runs follow `docs/python.md` (uv for greenfield/uv-managed; Poetry/pip-only when that is local; current stable Python 3.13+ for greenfield).
- Rust toolchain/Cargo follow `docs/rust.md` (stable; edition 2024 for greenfield when available).
- Modules are organized by concept, not by class or file type.
- Existing module was preferred when responsibility matched.
- New files were created only when split criteria were explicitly met.
- No new `utils` / `helpers` / `common` / `misc` catch-alls; code lives in the owning concept or a named shared module.
- One clear responsibility per module.
- No extra layers or folders without a matching pattern in the project.
- Imports and public API follow the style of nearby modules.

## Current Repository Signals

Use this repository structure as baseline for placement and naming:

- Top-level content is grouped by purpose (`skills/`, `rules/`, plugin manifest), not by deep product hierarchies.
- Skill folders use short, kebab-case names (`api-docs-writer`, `code-style`, `log-writer`, `readme-writer`).
- Supporting material stays close to the owning skill (`docs/`, `scripts/`, `assets/`, `references/`, `agents/` for Codex metadata) instead of being scattered.
- Keep this same approach: simple names, clear ownership, and minimal file fragmentation inside each skill or module.

## File naming (default)

| Priority | Pattern | Examples |
| --- | --- | --- |
| 1 | Single word | `parser.py`, `cache.rs`, `route.tsx`, `notifier.py` |
| 2 | Two words, language separator | Python/Rust: `create_order.py`; new TS/React: `price-scatter.ts` |
| Avoid | Three+ terms or long compounds | `billing_webhook_processing_service.py` |

- **Tests:** exempt — use project test conventions (longer or descriptive names are fine).
- **Python / Rust:** `snake_case`; two words with one `_`.
- **TypeScript / React:**
  - Prefer **single-word lowercase** filenames (`route.tsx`, `model.ts`, `client.ts`, `layout.tsx`).
  - If two words are needed for **new** `.ts` / `.tsx` files, prefer **kebab-case** (`price-scatter.ts`, `date-range.ts`) over `snake_case`, unless the surrounding folder already standardizes on underscores.
  - Hook modules may keep a `use_` / `use-` prefix (`use_table_sort.ts` or `use-table-sort.ts`); match the folder's existing separator.
  - React/UI components may use `PascalCase` files (`Card.tsx`) only when the project already does.
  - Avoid three+ term compounds (`item-detail-model.ts` → prefer `detail.ts` colocated, or a two-word max name).

## Naming Clarification

- Use `module` and `submodule` as default terms for placement decisions.
- Do not create a folder named `domain` unless the existing area already uses that exact convention.
- Good module names are short and direct: `infra`, `services`, `tasks`, `api`, `ui`.
- In skill repositories, prefer support folder names that describe their purpose directly: `docs`, `scripts`, `assets`, `references`, `agents`.

## Internal Docs

- `docs/python.md` — Python package layout, naming, structure, and dependency workflow (aligned with a `src/`-style project).
- `docs/rust.md` — Rust crate layout, naming, and structure (aligned with a `src/`-style crate).

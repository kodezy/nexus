---
name: architect
description: Define and apply simple, clear, direct architecture. Use when creating modules, packages, or features so structure and naming follow the project's existing style. Prefer simple pragmatic names over compound names.
---

# Architect Standards

## Objective

Keep architecture simple, clear, and direct. Every new module, package, or feature must follow the same style and patterns as the current project. Prefer fewer files with well-defined modules, and use simple, pragmatic names for files and modules.

## Language / Area Selection

- **Python:** Use `docs/python.md` for backend, services, scripts, package layout, and **uv** dependency/run workflow.
- **Rust:** Use `docs/rust.md` for crates, binaries, modules, and package layout.
- **TypeScript / React:** Use the File naming rules below (including the React/TS casing note). UI architecture and runtime (Vite vs Next) belong to `frontend`.
- Other languages: add docs when needed.

## Canonical Rules

1. **English:** All code, identifiers, comments, docstrings, and file/module names in English (per project AGENTS.md).
2. **Match existing structure:** Place code in the same hierarchy the project already uses, organized by module/submodule (e.g. `src/api`, `src/services`, `src/ui/components`).
3. **Simple file names:** Prefer **single-word** names when possible (`parser`, `client`, `cache`, `route`). If one word is not enough, use **at most two words**. Default separator for Python/Rust is `_` (`create_order`, `sync_users`). For TypeScript/React, see File naming below (prefer kebab-case for new two-word `.ts`/`.tsx` files). Avoid longer compounds (e.g. `billing_webhook_processing_service`, `market_offer_creator`).
4. **Tests exempt:** Test files do not need this pattern; follow project test naming (`test_parser.py`, `orders_test.rs`, descriptive pytest names).
5. **Fewer files first:** Prefer extending an existing module when responsibility is the same and cohesion stays clear.
6. **Split only with clear boundary:** Create a new file/package only when at least one condition is true: different responsibility from the current module, independent lifecycle, stable reuse by 2+ modules, or the current file loses readability due to mixed concerns.
7. **One clear purpose per module:** Each file or package should have a single, obvious responsibility.
8. **Flat when possible:** Avoid deep nesting; group by module, then keep submodules at one or two levels when it stays clear.
9. **No over-engineering:** Add layers (e.g. services, handlers, repositories) only when the project already uses them in that area.
10. **Local conventions win:** If the codebase does something different from this skill, follow the codebase.

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
- Python dependencies/runs use **uv** unless the repo is pip-only (see `docs/python.md`).
- Existing module was preferred when responsibility matched.
- New files were created only when split criteria were explicitly met.
- One clear responsibility per module.
- No extra layers or folders without a matching pattern in the project.
- Imports and public API follow the style of nearby modules.

## Current Repository Signals

Use this repository structure as baseline for placement and naming:

- Top-level content is grouped by purpose (`skills/`, `AGENTS.md`, optional tool metadata), not by deep product hierarchies.
- Skill folders use short, kebab-case names (`code-style`, `log-writer`, `readme-writer`).
- Supporting material stays close to the owning skill (`docs/`, `scripts/`, `assets/`, `references/`, `agents/`) instead of being scattered.
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

- `docs/python.md` — Python package layout, naming, structure, and uv dependencies (aligned with a `src/`-style project).
- `docs/rust.md` — Rust crate layout, naming, and structure (aligned with a `src/`-style crate).

---
name: architect
description: Define and apply simple, clear, direct architecture. Use when creating modules, packages, or features so structure and naming follow the project's existing style. Prefer simple pragmatic names over compound names.
---

# Architect Standards

## Objective

Keep architecture simple, clear, and direct. Every new module, package, or feature must follow the same style and patterns as the current project. Prefer fewer files with well-defined modules, and use simple, pragmatic names for files and modules.

## Language / Area Selection

- **Python:** Use `docs/python.md` for backend, services, scripts, and package layout.
- **Rust:** Use `docs/rust.md` for crates, binaries, modules, and package layout.
- Other languages: add docs when needed.

## Canonical Rules

1. **English:** All code, identifiers, comments, docstrings, and file/module names in English (per project AGENTS.md).
2. **Match existing structure:** Place code in the same hierarchy the project already uses, organized by module/submodule (e.g. `src/api`, `src/services`, `src/ui/components`).
3. **Simple names:** Prefer short, descriptive names for files and modules (e.g. `parser`, `client`, `notifier`) over compound names (e.g. `billing_webhook_processing_service`, `market_offer_creator`).
4. **Fewer files first:** Prefer extending an existing module when responsibility is the same and cohesion stays clear.
5. **Split only with clear boundary:** Create a new file/package only when at least one condition is true: different responsibility from the current module, independent lifecycle, stable reuse by 2+ modules, or the current file loses readability due to mixed concerns.
6. **One clear purpose per module:** Each file or package should have a single, obvious responsibility.
7. **Flat when possible:** Avoid deep nesting; group by module, then keep submodules at one or two levels when it stays clear.
8. **No over-engineering:** Add layers (e.g. services, handlers, repositories) only when the project already uses them in that area.
9. **Local conventions win:** If the codebase does something different from this skill, follow the codebase.

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
- File and module names are simple and descriptive, not long compounds.
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

## Naming Clarification

- Use `module` and `submodule` as default terms for placement decisions.
- Do not create a folder named `domain` unless the existing area already uses that exact convention.
- Good module names are short and direct: `infra`, `services`, `tasks`, `api`, `ui`.
- In skill repositories, prefer support folder names that describe their purpose directly: `docs`, `scripts`, `assets`, `references`, `agents`.

## Internal Docs

- `docs/python.md` — Python package layout, naming, and structure (aligned with a `src/`-style project).
- `docs/rust.md` — Rust crate layout, naming, and structure (aligned with a `src/`-style crate).

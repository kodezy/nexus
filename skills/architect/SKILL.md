---
name: architect
description: Define and apply simple, clear, direct architecture. Use when creating modules, packages, or features so structure and naming follow the project's existing style. Prefer simple pragmatic names over compound names.
---

# Architect Standards

## Objective

Keep architecture simple, clear, and direct. Every new module, package, or feature must follow the same style and patterns as the current project. File and module names stay simple, pragmatic, and descriptive—avoid compound or verbose names.

## Language / Area Selection

- **Python:** Use `docs/python.md` for backend, services, scripts, and package layout.
- **Rust:** Use `docs/rust.md` for crates, binaries, modules, and package layout.
- Other languages: add docs when needed.

## Canonical Rules

1. **English:** All code, identifiers, comments, docstrings, and file/module names in English (per project AGENTS.md).
2. **Match existing structure:** Place code in the same kind of hierarchy the project already uses (e.g. `src/domain/subdomain`, `domain/services`, `domain/workflows`).
3. **Simple names:** Prefer short, descriptive names for files and modules (e.g. `analyzer`, `arbitrage`, `notifier`) over compound names (e.g. `trading_metrics_service`, `market_offer_creator`).
4. **One clear purpose per module:** Each file or package should have a single, obvious responsibility.
5. **Flat when possible:** Avoid deep nesting; group by domain, then keep modules at one or two levels when it stays clear.
6. **No over-engineering:** Add layers (e.g. services, handlers, repositories) only when the project already uses them in that area.
7. **Local conventions win:** If the codebase does something different from this skill, follow the codebase.

## Scope

- Where to put new code (package and file location).
- How to name new modules, packages, and files.
- How to organize subdomains (e.g. actions, workflows, services, tabs).
- When to add a new package vs. a new file in an existing package.

## Workflow

1. Identify the domain or subdomain (e.g. trading, game, vision, dashboard).
2. Check how that domain is structured (folders, naming pattern).
3. Choose a simple, descriptive name for the new file or package.
4. Place the new code in the same pattern (e.g. `trading/services/foo.py`, `game/actions/market/bar.py`).
5. Expose public API via existing patterns (e.g. `__init__.py` with `__all__` where the project uses it).

## Checklist

- New code lives under the right domain and follows existing hierarchy.
- File and module names are simple and descriptive, not long compounds.
- One clear responsibility per module.
- No extra layers or folders without a matching pattern in the project.
- Imports and public API follow the style of nearby modules.

## Internal Docs

- `docs/python.md` — Python package layout, naming, and structure (aligned with a `src/`-style project).
- `docs/rust.md` — Rust crate layout, naming, and structure (aligned with a `src/`-style crate).

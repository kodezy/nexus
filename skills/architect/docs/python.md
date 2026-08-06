---
description: Python architecture — simple layout, pragmatic naming, one purpose per module.
alwaysApply: false
---

# Architect Guide (Python)

## Objective

Keep Python architecture simple, clear, and direct, in the same style as the project: simple, descriptive file and module names, without long compound names.

## Runtime

- Prefer **current stable Python** (**3.13+** when available) for greenfield projects.
- Pin via `requires-python` in `pyproject.toml` (and `.python-version` when the repo uses it).
- Do not raise or lower the declared runtime unless the user asks; follow existing pins and CI.

## Dependencies

Choose the workflow from repository signals. Do not migrate tooling unless the user explicitly asks.

**uv (preferred for greenfield and uv-managed repos)** — signals: `uv.lock`, or `pyproject.toml` managed with uv.

- **Add:** `uv add <package>` (dev: `uv add --dev <package>`)
- **Remove:** `uv remove <package>`
- **Install / sync:** `uv sync`
- **Run:** `uv run <command>` (tests, scripts, CLIs)
- Treat `pyproject.toml` and the uv lockfile as the source of truth.
- **Do not** use bare `pip install` or maintain a hand-edited `requirements.txt` in a uv-managed project.

**Existing non-uv workflows** — follow local convention until migration is requested:

- **Poetry:** `poetry.lock` / Poetry `[tool.poetry]` metadata → use Poetry commands the repo already uses.
- **pip-only:** `requirements.txt` without uv → use that workflow.
- Mixed lockfiles (for example Poetry + `uv.lock`): follow the primary tool the project documents or already uses for day-to-day work; do not invent a second path.

Keep dependency changes focused; do not mix broad upgrades with unrelated feature work.

## Folder structure (project baseline)

- **Code root:** `src/` (or equivalent).
- **First-level modules:** one folder per clear responsibility (for example: `api`, `services`, `workers`, `storage`, `infra`, `ui`).
- **Submodules as needed:** inside each module, group by function when it makes sense:
  - `services/` — service modules and orchestrators (`notifier`, `sync`, `billing`).
  - `api/` — route handlers, schemas, and request-specific helpers.
  - `workers/` or `tasks/` — background jobs and scheduled flows.
  - `storage/` — repositories, models, and persistence helpers.
  - `ui/` or `dashboard/` — app-facing callbacks, layouts, or view helpers when the project already uses them.
- **Avoid unnecessary depth:** two levels under a module are usually enough; three only when the module is large and already follows that pattern.

## File and module names

- **Single word first:** prefer one term in **snake_case** (`client.py`, `cache.py`, `notifier.py`).
- **Two words max:** when one word is not enough, use at most two terms with one underscore (`create_order.py`, `sync_users.py`).
- **Avoid:** three or more terms or long compounds (`billing_webhook_processing_service.py`, `market_offer_creation_handler.py`). Prefer `billing.py`, `create_order.py`, `login.py`.
- **Tests exempt:** test modules may use longer or descriptive names per project conventions (`test_create_order.py`, `test_parser_rejects_invalid_input.py`).
- **Verb + noun for actions (two-word cap):** `create_order`, `cancel_order`, `sync_users`, `login_user`.
- **Noun for concepts/services (prefer one word):** `client`, `notifier`, `cache`, `session`, `repository`.

## Module organization

Design modules around cohesive **concepts**, not around individual classes, functions, or file types.

- Prefer **one module per concept**, not one module per class (for example: `billing.py` or `services/billing.py`, not one file per small helper).
- Keep related functionality together to minimize context needed to understand or change a feature. Do not split solely to reduce file size or line count.
- Split only when a module has **multiple independent responsibilities**, becomes hard to navigate, or has **multiple reasons to change**. When splitting, use simple names by responsibility (for example: multiple workflows in `workflows/`, multiple services in `services/`).
- Avoid generic catch-all modules (`utils`, `helpers`, `common`, `misc`). Place code in the owning package (for example: date logic in `billing` or a dedicated `dates` module). Create a named shared module only when a real cross-cutting concept emerges.
- Organize packages by **domain or subsystem** (`api`, `services`, `storage`). Prioritize cohesion and predictable locations over minimizing file count.
- Preserve or improve architectural consistency when restructuring; do not introduce unnecessary granularity.
- Avoid "hub" modules that only re-export many items without conceptual grouping; prefer exporting only what is used outside the package.

## Where to place new code

| Code type | Where to place (examples) |
|----------------|--------------------------|
| Service / orchestrator | `services/<name>.py` (for example: `billing`, `notifier`) |
| Background job / flow | `workers/<name>.py` or `tasks/<name>.py` (for example: `sync_users`, `cleanup`) |
| API handler / schema | `api/<name>.py` or `api/<group>/<name>.py` following the project |
| UI callback / view helper | `ui/<name>.py` or `dashboard/<name>/` when the project already uses that pattern |
| Shared infra | `infra/<name>.py` (for example: `cache`, `logger`, `database`) |
| Models / repository | `storage/models.py`, `storage/repository.py`, or new modules in `storage/` with simple names |

## Naming examples (follow this style)

**Good:**  
`client`, `metrics`, `notifier`, `cache`, `billing`, `create_order`, `cancel_order`, `sync_users`, `refresh_cache`, `login_user`, `session`, `context`, `repository`.

**Avoid:**  
`billing_webhook_processing_service`, `market_offer_creator`, `user_authentication_service`, `dashboard_trading_tab_layout`.

## Imports and public API

- Import from the most direct path already used in the project (for example: `from src.services.notifier import ...`).
- In packages with `__init__.py`, keep `__all__` when the project uses it, listing only what is part of the package public API.
- Do not create new re-export "hubs" unless the same package already uses that pattern.

## Summary

- Runtime: current stable Python (**3.13+** for greenfield); honor existing `requires-python` / pins.
- Dependencies and runs: **uv** for greenfield and uv-managed repos; Poetry/pip-only (or other established tools) follow local convention until migration is requested.
- Structure aligned with the project: module → submodule → files with short names.
- File/module names: simple, pragmatic, descriptive, snake_case; avoid long compounds.
- One clear purpose per module; concept-first layout; flat structure or only a few levels.
- Place new code in the same folder type and naming pattern the module already uses.

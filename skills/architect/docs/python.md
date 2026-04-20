---
description: Python architecture — simple layout, pragmatic naming, one purpose per module.
alwaysApply: false
---

# Architect Guide (Python)

## Objective

Keep Python architecture simple, clear, and direct, in the same style as the project: simple, descriptive file and module names, without long compound names.

## Folder structure (project baseline)

- **Code root:** `src/` (or equivalent).
- **First-level modules:** one folder per clear responsibility (for example: `api`, `services`, `workers`, `storage`, `infra`, `ui`).
- **Submodules as needed:** inside each module, group by function when it makes sense:
  - `services/` — domain services and orchestrators (`notifier`, `sync`, `billing`).
  - `api/` — route handlers, schemas, and request-specific helpers.
  - `workers/` or `tasks/` — background jobs and scheduled flows.
  - `storage/` — repositories, models, and persistence helpers.
  - `ui/` or `dashboard/` — app-facing callbacks, layouts, or view helpers when the project already uses them.
- **Avoid unnecessary depth:** two levels under a domain are usually enough; three only when the domain is large and already follows that pattern.

## File and module names

- **Simple and direct:** one or a few terms that describe the content.
- Use **snake_case** for files: `client.py`, `notifier.py`, `create_order.py`, `sync_users.py`.
- **Prefer:** `client`, `notifier`, `metrics`, `cache`, `create_order`, `cancel_order`, `sync_users`.
- **Avoid:** long or generic compound names such as `billing_webhook_processing_service.py`, `market_offer_creation_handler.py`, `user_authentication_manager.py`. Prefer: `billing`, `create_order`, `login_user`.
- **Verb + noun for actions:** `create_order`, `cancel_order`, `sync_users`, `login_user`, `refresh_cache`.
- **Noun for concepts/services:** `client`, `notifier`, `strategy`, `session`, `context`, `repository`.

## One purpose per module

- Each file should have one clear responsibility (for example: one workflow, one action type, one service).
- If a file grows too large, split by responsibility and keep simple names (for example, multiple workflows in `workflows/`, multiple services in `services/`).
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
- Do not create new re-export "hubs" unless the same domain already uses that pattern.

## Summary

- Structure aligned with the project: module → submodule → files with short names.
- File/module names: simple, pragmatic, descriptive, snake_case; avoid long compounds.
- One clear purpose per module; flat structure or only a few levels.
- Place new code in the same folder type and naming pattern the domain already uses.

---
description: Rust architecture — simple layout, pragmatic naming, one purpose per module.
alwaysApply: false
---

# Architect Guide (Rust)

## Objective

Keep Rust architecture simple, clear, and direct, in the same style as the project: simple, descriptive file and module names, without long compound names.

## Folder structure (project baseline)

- **Code root:** `src/` (crate root with `lib.rs` and/or `main.rs`).
- **Binaries:** `src/main.rs` for the primary binary; additional binaries in `src/bin/<name>.rs` (for example: `src/bin/cli.rs`, `src/bin/worker.rs`).
- **First-level modules:** one module per clear responsibility (for example: `api`, `services`, `workers`, `storage`, `infra`, `ui`), each as `src/<module>/` with `mod.rs` or as `src/<module>.rs`.
- **Submodules as needed:** inside each module, group by function when it makes sense:
  - `services/` — domain services and orchestrators (`notifier`, `sync`, `billing`).
  - `api/` — route handlers, DTOs, and transport-specific adapters.
  - `workers/` or `tasks/` — background jobs and scheduled flows.
  - `storage/` — repositories, models, and persistence helpers.
  - `ui/` or `dashboard/` — view-specific modules only when the project already uses them.
- **Avoid unnecessary depth:** two levels under a domain are usually enough; three only when the domain is large and already follows that pattern.

## File and module names

- **Simple and direct:** one or a few terms that describe the content.
- Use **snake_case** for files and modules: `client.rs`, `notifier.rs`, `create_order.rs`, `sync_users.rs`.
- **Prefer:** `client`, `notifier`, `metrics`, `cache`, `create_order`, `cancel_order`, `sync_users`.
- **Avoid:** long or generic compound names such as `billing_webhook_processing_service.rs`, `market_offer_creation_handler.rs`, `user_authentication_manager.rs`. Prefer: `billing`, `create_order`, `login_user`.
- **Verb + noun for actions:** `create_order`, `cancel_order`, `sync_users`, `login_user`, `refresh_cache`.
- **Noun for concepts/services:** `client`, `notifier`, `strategy`, `session`, `context`, `repository`.
- **Module as folder:** `services/` -> `services/mod.rs` re-exporting items, or `services.rs`; submodules as `services/notifier.rs` (declared in `mod.rs` or parent module).

## One purpose per module

- Each file should have one clear responsibility (for example: one workflow, one action type, one service).
- If a file grows too large, split by responsibility and keep simple names (for example, multiple workflows in `workflows/`, multiple services in `services/`).
- Avoid "hub" modules that only re-export many items without conceptual grouping; prefer re-exporting only what is part of the crate or module public API.

## Where to place new code

| Code type | Where to place (examples) |
|----------------|--------------------------|
| Service / orchestrator | `src/services/<name>.rs` (for example: `billing`, `notifier`) |
| Background job / flow | `src/workers/<name>.rs` or `src/tasks/<name>.rs` (for example: `sync_users`, `cleanup`) |
| API handler / DTO | `src/api/<name>.rs` or `src/api/<group>/<name>.rs` following the project |
| UI module | `src/ui/<name>.rs` or `src/dashboard/<name>/` when the project already uses that pattern |
| Shared infra | `src/infra/<name>.rs` (for example: `cache`, `logger`, `database`) |
| Models / repository | `src/storage/models.rs`, `src/storage/repository.rs`, or new modules in `src/storage/` with simple names |
| Extra binary | `src/bin/<name>.rs` (for example: `cli`, `worker`, `migrate`) |

## Naming examples (follow this style)

**Good:**  
`client`, `metrics`, `notifier`, `cache`, `billing`, `create_order`, `cancel_order`, `sync_users`, `refresh_cache`, `login_user`, `session`, `context`, `repository`.

**Avoid:**  
`billing_webhook_processing_service`, `market_offer_creator`, `user_authentication_service`, `dashboard_trading_tab_layout`.

## Imports and public API

- Use `mod` and `use` with the most direct path already used in the project (for example: `use crate::services::notifier::...`).
- Expose only what is needed in `lib.rs` or the domain `mod.rs`; use `pub use` to re-export types and functions that are part of the crate public API.
- Do not create new re-export "hubs" unless the same domain already uses that pattern.
- Prefer `pub(crate)` for items used only inside the crate and `pub` only for external API.

## Summary

- Structure aligned with the project: module -> submodule -> files with short names.
- File/module names: simple, pragmatic, descriptive, snake_case; avoid long compounds.
- One clear purpose per module; flat structure or only a few levels.
- Place new code in the same folder type and naming pattern the domain already uses.
- Extra binaries in `src/bin/<name>.rs`; public API exposed with deliberate `pub`/`pub use`.

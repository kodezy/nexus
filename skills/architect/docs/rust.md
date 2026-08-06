---
description: Rust architecture — simple layout, pragmatic naming, one purpose per module.
alwaysApply: false
---

# Architect Guide (Rust)

## Objective

Keep Rust architecture simple, clear, and direct, in the same style as the project: simple, descriptive file and module names, without long compound names.

## Toolchain and Cargo

- Prefer the **stable** Rust toolchain for greenfield and day-to-day work (`rustup` stable, or `rust-toolchain.toml` with `channel = "stable"`).
- Prefer **edition 2024** for new crates when stable supports it; otherwise **2021+**. Do not change `edition` / `rust-version` in existing crates unless the user asks.
- Treat `Cargo.toml` (and the lockfile when present) as the source of truth for dependencies.
- **Add:** `cargo add <crate>` (dev: `cargo add --dev <crate>`)
- **Remove:** `cargo remove <crate>`
- **Build / run / test:** `cargo build`, `cargo run`, `cargo test` (or the project’s documented wrappers).
- Keep dependency changes focused; do not mix broad upgrades with unrelated feature work.
- Do not migrate to nightly or alternate tooling unless the user explicitly asks.

## Folder structure (project baseline)

- **Code root:** `src/` (crate root with `lib.rs` and/or `main.rs`).
- **Binaries:** `src/main.rs` for the primary binary; additional binaries in `src/bin/<name>.rs` (for example: `src/bin/cli.rs`, `src/bin/worker.rs`).
- **First-level modules:** one module per clear responsibility (for example: `api`, `services`, `workers`, `storage`, `infra`, `ui`), each as `src/<module>/` with `mod.rs` or as `src/<module>.rs`.
- **Submodules as needed:** inside each module, group by function when it makes sense:
  - `services/` — service modules and orchestrators (`notifier`, `sync`, `billing`).
  - `api/` — route handlers, DTOs, and transport-specific adapters.
  - `workers/` or `tasks/` — background jobs and scheduled flows.
  - `storage/` — repositories, models, and persistence helpers.
  - `ui/` or `dashboard/` — view-specific modules only when the project already uses them.
- **Avoid unnecessary depth:** two levels under a module are usually enough; three only when the module is large and already follows that pattern.

## File and module names

- **Single word first:** prefer one term in **snake_case** (`client.rs`, `cache.rs`, `notifier.rs`).
- **Two words max:** when one word is not enough, use at most two terms with one underscore (`create_order.rs`, `sync_users.rs`).
- **Avoid:** three or more terms or long compounds (`billing_webhook_processing_service.rs`, `market_offer_creation_handler.rs`). Prefer `billing.rs`, `create_order.rs`, `login.rs`.
- **Tests exempt:** test modules may use longer or descriptive names per project conventions (`orders_test.rs`, `create_order_integration_test.rs`).
- **Verb + noun for actions (two-word cap):** `create_order`, `cancel_order`, `sync_users`, `login_user`.
- **Noun for concepts/services (prefer one word):** `client`, `notifier`, `cache`, `session`, `repository`.
- **Module as folder:** `services/` -> `services/mod.rs` re-exporting items, or `services.rs`; submodules as `services/notifier.rs` (declared in `mod.rs` or parent module).

## Module organization

Design modules around cohesive **concepts**, not around individual classes, functions, or file types.

- Prefer **one module per concept**, not one module per struct or trait (for example: `services/billing.rs`, not one file per small helper).
- Keep related functionality together to minimize context needed to understand or change a feature. Do not split solely to reduce file size or line count.
- Split only when a module has **multiple independent responsibilities**, becomes hard to navigate, or has **multiple reasons to change**. When splitting, use simple names by responsibility (for example: multiple workflows in `workflows/`, multiple services in `services/`).
- Avoid generic catch-all modules (`utils`, `helpers`, `common`, `misc`). Place code in the owning module (for example: date logic in `billing` or a dedicated `dates` module). Create a named shared module only when a real cross-cutting concept emerges.
- Organize crates and `src/` modules by **domain or subsystem** (`api`, `services`, `storage`). Prioritize cohesion and predictable locations over minimizing file count.
- Preserve or improve architectural consistency when restructuring; do not introduce unnecessary granularity.
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
- Expose only what is needed in `lib.rs` or the module `mod.rs`; use `pub use` to re-export types and functions that are part of the crate public API.
- Do not create new re-export "hubs" unless the same module already uses that pattern.
- Prefer `pub(crate)` for items used only inside the crate and `pub` only for external API.

## Summary

- Toolchain: **stable**; new crates prefer edition **2024** (else **2021+**); honor existing `Cargo.toml` pins.
- Structure aligned with the project: module -> submodule -> files with short names.
- File/module names: simple, pragmatic, descriptive, snake_case; avoid long compounds.
- One clear purpose per module; concept-first layout; flat structure or only a few levels.
- Place new code in the same folder type and naming pattern the module already uses.
- Extra binaries in `src/bin/<name>.rs`; public API exposed with deliberate `pub`/`pub use`.

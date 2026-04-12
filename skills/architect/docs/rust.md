---
description: Rust architecture - simple layout, pragmatic naming, one purpose per module.
alwaysApply: false
---

# Architect Guide (Rust)

## Objective

Keep Rust architecture simple, clear, and direct, in the same style as the project: simple and descriptive file and module names, without long compound names.

## Folder Structure

- **Code root:** `src/`, with crate root files such as `lib.rs` and/or `main.rs`.
- **Binaries:** `src/main.rs` for the main binary; additional binaries under `src/bin/<name>.rs`, such as `src/bin/cli.rs` or `src/bin/worker.rs`.
- **Top-level domains:** one module per domain, such as `trading`, `game`, `vision`, `storage`, `dashboard`, `network`, or `infra`. Use either `src/<domain>/` with `mod.rs` or `src/<domain>.rs`.
- **Subdomains when needed:** inside the domain, group by function when it helps:
  - `trading/services/`: domain services such as `analyzer`, `arbitrage`, `metrics`, `notifier`, `selector`, `availability`, and `factory`.
  - `trading/workflows/`: flows such as `base`, `start`, `finish`, `preparing`, `trading`, and `handler`.
  - `trading/signals/`: signals such as `create`, `cancel`, and `utils`.
  - `game/actions/`: actions grouped by context, such as `auth/`, `gameplay/`, and `market/`.
  - `dashboard/tabs/`: one module per tab, such as `trading`, `market`, `arbitrage`, `metrics`, `workers`, `accounts`, and `misc`.
  - `vision/screens/components/`: components grouped by context, such as `auth`, `gameplay`, and `market`.
- **Avoid unnecessary depth:** two levels under the domain are usually enough; use three only when the domain is large and already follows that pattern.

## File And Module Names

- **Simple and direct:** use one or a few terms that describe the content.
- **Use snake_case** for files and modules: `analyzer.rs`, `arbitrage.rs`, `create_offer.rs`, `scan_balances.rs`.
- **Prefer:** `notifier`, `metrics`, `selector`, `availability`, `factory`, `open_market`, `close_market`, `cancel_offer`, `create_offer`.
- **Avoid:** long or generic compound names such as `trading_metrics_service.rs`, `market_offer_creation_handler.rs`, and `user_authentication_manager.rs`. Prefer `metrics`, `create_offer`, and `login_account`.
- **Use verb + noun for actions:** `create_offer`, `cancel_offer`, `scan_balances`, `open_market`, `login_account`, `select_character`.
- **Use a noun for concepts and services:** `analyzer`, `arbitrage`, `notifier`, `strategy`, `session`, `context`.
- **Module as folder:** `trading/services/` can use `trading/services/mod.rs` for re-exports, or `trading/services.rs`; submodules can live at `trading/services/analyzer.rs` and be declared in `mod.rs` or the parent module.

## One Purpose Per Module

- Each file should have one clear responsibility, such as one workflow, one kind of action, or one service.
- If a file grows too much, split it by responsibility and keep names simple, such as multiple workflows under `workflows/` or multiple services under `services/`.
- Avoid guardian modules that only re-export dozens of things without grouping by concept. Prefer re-exporting only what is public API for the crate or module.

## Where To Put New Code

| Code type | Location examples |
|-----------|-------------------|
| Domain service for trading | `src/trading/services/<name>.rs`, such as `metrics` or `analyzer` |
| Workflow or flow | `src/trading/workflows/<name>.rs`, such as `start`, `finish`, or `trading` |
| Game action | `src/game/actions/<context>/<name>.rs`, such as `market/create_offer` or `auth/login_account` |
| Dashboard tab | `src/dashboard/tabs/<name>/` with `mod.rs` and submodules, following the project |
| Vision screen component | `src/vision/screens/components/<context>/<name>.rs` |
| Shared infrastructure | `src/infra/<name>.rs`, such as `cache`, `logger`, or `database` |
| Models or repository | `src/storage/models.rs`, `src/storage/repository.rs`, or new modules under `src/storage/` with simple names |
| Extra binary | `src/bin/<name>.rs`, such as `cli`, `worker`, or `migrate` |

## Naming Examples

Prefer:

```text
analyzer
arbitrage
metrics
notifier
selector
availability
factory
create_offer
cancel_offer
open_market
close_market
scan_balances
scan_my_offers
login_account
select_character
base
start
finish
preparing
trading
handler
```

Avoid:

```text
trading_metrics_service
market_offer_creator
user_authentication_service
gameplay_market_open_action
dashboard_trading_tab_layout
```

## Imports And Public API

- Use `mod` and `use` from the most direct path the project already uses, such as `use crate::trading::services::analyzer::...`.
- Expose only what is needed in `lib.rs` or the domain `mod.rs`. Use `pub use` to re-export types and functions that are public crate API.
- Do not create new re-export hubs unless the same domain already follows that pattern.
- Prefer `pub(crate)` for items used only inside the crate and `pub` only for external API.

## Summary

- Keep structure aligned with the project: domain, subdomain, then short-named modules.
- Use simple, pragmatic, descriptive snake_case file and module names. Avoid long compounds.
- Keep one clear purpose per module. Prefer a flat structure or a few levels.
- Put new code in the same kind of folder and naming pattern the domain already uses.
- Put extra binaries under `src/bin/<name>.rs`. Expose public API through deliberate `pub` and `pub use`.

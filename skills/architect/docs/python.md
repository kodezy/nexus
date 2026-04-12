---
description: Python architecture - simple layout, pragmatic naming, one purpose per module.
alwaysApply: false
---

# Architect Guide (Python)

## Objective

Keep Python architecture simple, clear, and direct, in the same style as the project: simple and descriptive file and module names, without long compound names.

## Folder Structure

- **Code root:** `src/` or the project equivalent.
- **Top-level domains:** one folder per domain, such as `trading`, `game`, `vision`, `storage`, `dashboard`, `network`, or `infra`.
- **Subdomains when needed:** inside the domain, group by function when it helps:
  - `trading/services/`: domain services such as `analyzer`, `arbitrage`, `metrics`, `notifier`, `selector`, `availability`, and `factory`.
  - `trading/workflows/`: flows such as `base`, `start`, `finish`, `preparing`, `trading`, and `handler`.
  - `trading/signals/`: signals such as `create`, `cancel`, and `utils`.
  - `game/actions/`: actions grouped by context, such as `auth/`, `gameplay/`, and `market/`.
  - `dashboard/tabs/`: one folder per tab, such as `trading`, `market`, `arbitrage`, `metrics`, `workers`, `accounts`, and `misc`.
  - `vision/screens/components/`: components grouped by context, such as `auth`, `gameplay`, and `market`.
- **Avoid unnecessary depth:** two levels under the domain are usually enough; use three only when the domain is large and already follows that pattern.

## File And Module Names

- **Simple and direct:** use one or a few terms that describe the content.
- **Use snake_case** for files: `analyzer.py`, `arbitrage.py`, `create_offer.py`, `scan_balances.py`.
- **Prefer:** `notifier`, `metrics`, `selector`, `availability`, `factory`, `open_market`, `close_market`, `cancel_offer`, `create_offer`.
- **Avoid:** long or generic compound names such as `trading_metrics_service.py`, `market_offer_creation_handler.py`, and `user_authentication_manager.py`. Prefer `metrics`, `create_offer`, and `login_account`.
- **Use verb + noun for actions:** `create_offer`, `cancel_offer`, `scan_balances`, `open_market`, `login_account`, `select_character`.
- **Use a noun for concepts and services:** `analyzer`, `arbitrage`, `notifier`, `strategy`, `session`, `context`.

## One Purpose Per Module

- Each file should have one clear responsibility, such as one workflow, one kind of action, or one service.
- If a file grows too much, split it by responsibility and keep names simple, such as multiple workflows under `workflows/` or multiple services under `services/`.
- Avoid guardian modules that only re-export dozens of things without grouping by concept. Prefer re-exporting only what is used outside the package.

## Where To Put New Code

| Code type | Location examples |
|-----------|-------------------|
| Domain service for trading | `trading/services/<name>.py`, such as `metrics` or `analyzer` |
| Workflow or flow | `trading/workflows/<name>.py`, such as `start`, `finish`, or `trading` |
| Game action | `game/actions/<context>/<name>.py`, such as `market/create_offer` or `auth/login_account` |
| Dashboard tab | `dashboard/tabs/<name>/` with `layout.py` and `callbacks.py`, following the project |
| Vision screen component | `vision/screens/components/<context>/<name>.py` |
| Shared infrastructure | `infra/<name>.py`, such as `cache`, `logger`, or `database` |
| Models or repository | `storage/models.py`, `storage/repository.py`, or new modules under `storage/` with simple names |

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

- Import from the most direct path the project already uses, such as `from src.trading.services.analyzer import ...`.
- In packages with `__init__.py`, keep `__all__` when the project uses it, listing only the package's public API.
- Do not create new re-export hubs unless the same domain already follows that pattern.

## Summary

- Keep structure aligned with the project: domain, subdomain, then short-named modules.
- Use simple, pragmatic, descriptive snake_case file and module names. Avoid long compounds.
- Keep one clear purpose per module. Prefer a flat structure or a few levels.
- Put new code in the same kind of folder and naming pattern the domain already uses.

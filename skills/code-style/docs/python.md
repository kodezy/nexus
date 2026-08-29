# Clean Code Guide (Python)

## Objective

Clarity, simplicity, and pragmatism above all. Code that is easy to understand, maintain, and evolve.

## Naming

Highest priority: simple, clear, pragmatic names.

- Use direct, descriptive names: `calculate_total`, `user_name`, `process_order`.
- Avoid unnecessary abbreviations: prefer `calculate` over `calc`, `user` over `usr`.
- Use names that describe purpose, not implementation: `get_active_users` is better than `get_users_from_db`.
- For booleans, use `is_`, `has_`, `can_`, `should_`.
- For functions, use verbs in infinitive form: `calculate`, `validate`, `process`.
- For classes, use singular nouns: `User`, `Order`, `Strategy`.
- Be specific when needed: `calculate_profit_margin` is better than `calculate`.
- Keep prefix and convention consistency across the module.

## Structure and Organization

- Prefer **current stable Python** (3.13+ when available) for greenfield work and new modules when the repo does not pin an older runtime.
- When the project already declares a runtime (`requires-python`, `.python-version`, CI matrix), use that version and only the features it supports.
- Dependency installs and run workflow: `architect` → `docs/python.md` (not this style guide).

### Module organization

- One **concept** per module or package, not one module per class. Keep related behavior together; do not split solely for file size.
- Split when a module has multiple independent responsibilities, is hard to navigate, or has multiple reasons to change.
- Avoid `utils`, `helpers`, `common`, `misc`. Place code in the owning package or a named shared module (`format`, `dates`, `validation`). Package layout: `architect`.

### Order inside a `.py` file

Top to bottom:

1. **Module docstring** — when present, first line of the file; skip entirely when the module does not need one.
2. **`from __future__ import …`** — **only when required**; omit by default on 3.13+ (see **Type hints and modern idioms** below).
3. **`import` / `from … import`** — standard library, blank line, third-party, blank line, local. One group per layer. Import `TYPE_CHECKING` here when needed (`from typing import TYPE_CHECKING`).
4. **Type-only imports and aliases** — `if TYPE_CHECKING:` block (type-only `from … import` for real circular imports), then `TypeVar` / `ParamSpec` / `type` aliases when needed. **Always before constants** — never place `TYPE_CHECKING` imports below the constants block.
5. **Constants** — immutable module config: `UPPER_SNAKE_CASE` for module-public scalars, `_UPPER_SNAKE_CASE` for module-private scalars (see **Constants** below).
6. **Logger / infrastructure** — module-scoped setup treated as configuration, not mutable runtime state (`logger = setup_logger(__name__)`, one-shot clients). Logger **setup** details: `log-writer`; this step is **file order** only.
7. **Module-level state** — private mutable module globals (`_cache_*`, `_connected_logged`, dicts/maps holding runtime data). Prefix with `_` when module-private.
8. **Classes**
9. **Module-level functions** — public free functions first, then private helpers (`_`).
10. **`if __name__ == "__main__":`** — last in the file.

Mnemonic: **imports → typing (`TYPE_CHECKING`, aliases) → constants → logger/infrastructure → module state → classes → functions → entry**.

**Blank lines at module level:** use **one** blank line between groups in the same layer (typing names, constant domains, related `_cache_*` assignments). Use **two** blank lines only before a top-level `class` or `def` (PEP 8). Do not double-space every phase — that contradicts the skill’s “never two blank lines” rule inside functions and adds noise without clearer structure.

**Dependency order wins.** If moving a name changes import-time initialization or creates a forward-reference error, keep the order that preserves correct behavior. Do not reorder solely for style.

Example (typing and constants above `logger`; mutable `_cache_*` below it):

```python
from collections.abc import Callable
from typing import Any, ParamSpec, TypeVar

from myapp.infra.logging import setup_logger

P = ParamSpec("P")
R = TypeVar("R")

_REDIS_RETRY_COOLDOWN_SECONDS: float = 5.0

logger = setup_logger(__name__)

_cache_instances: dict[str, Any] = {}
_redis_clients: dict[str, Any] = {}
_redis_retry_after: dict[str, float] = {}
_redis_connected_logged: bool = False
_redis_fallback_logged: bool = False
_image_cache_keys: dict[int, tuple[weakref.ref, str]] = {}


class RedisCache:
    ...
```

`TYPE_CHECKING` (when needed) belongs in step 4, not below constants:

```python
from typing import TYPE_CHECKING

from myapp.infra.logging import setup_logger

if TYPE_CHECKING:
    from myapp.models import Order

_REDIS_RETRY_COOLDOWN_SECONDS: float = 5.0

logger = setup_logger(__name__)
```

**How this compares to other languages:** imports and typing (`TYPE_CHECKING`, aliases) sit at the top, **before constants**; **types are optional and lightweight** (PEP 484 hints on parameters, attributes, and return values—no separate “types block” unless you need one). **Logger and infrastructure** sit after constants but **before** mutable module state. **Behavior lives inside the `class`** (methods), not in a separate block like Rust’s `impl`. Module-level **functions come after** all classes: public free functions first, then private helpers. The **entry hook** is **`if __name__ == "__main__":`** at the bottom.

### Type hints and modern idioms

**Baseline:** use features allowed by the repo's declared runtime (`requires-python`, `.python-version`, CI). On **3.13+** greenfield, write modern idioms by default. Do not copy legacy patterns from older codebases unless the repo still supports that older runtime.

#### `from __future__ import annotations`

- **Default: omit.** Do not paste this into new modules "just in case."
- Add it only when there is a **concrete need** on the pinned runtime (for example, a library boundary that must postpone annotation evaluation and cannot be solved with quotes, reordering, or a narrow `TYPE_CHECKING` import).
- On **3.14+**, prefer native lazy annotations; do not add the future import for new code.

#### Type hints (prefer modern builtins)

| Avoid (legacy) | Prefer (3.10+ / 3.13+ greenfield) |
| --- | --- |
| `Optional[X]` | `X \| None` |
| `Union[A, B]` | `A \| B` |
| `List`, `Dict`, `Tuple`, `Set` from `typing` | `list`, `dict`, `tuple`, `set` |
| `Type[X]` | `type[X]` |
| `typing_extensions` for features already in stdlib | stdlib on the pinned runtime |

- Use `type Alias = ...` (3.12+) for module-level type aliases when it reads better than assignment.
- Use `enum.StrEnum` (3.11+) for string enums instead of manual `str, Enum` mixes.
- Use `TYPE_CHECKING` imports only to break **real** circular imports; do not wrap every cross-reference. Keep the `if TYPE_CHECKING:` block in the **typing** layer (step 4), immediately after runtime imports and **before** constants — not after logger, state, or classes.
- Prefer fixing definition order or a quoted forward ref (`"MyClass"`) over blanket future imports.

#### Other legacy residues to avoid on modern runtimes

- f-strings for interpolation — not `%` formatting or `.format()` in new/changed code.
- `pathlib.Path` for new path handling — not `os.path` joins unless matching surrounding legacy code.
- `@dataclass(..., slots=True)` only when it is a clear win (fixed fields, many instances) and the type does not need `__dict__`, multiple inheritance, or weakrefs — not a default on every dataclass.
- `match` / `case` when it is clearer than long `if` / `elif` chains (3.10+).

**When touching existing files:** do not mass-migrate unrelated lines; apply modern idioms to code you change when the file's runtime allows.

### Constants

- Declare **one constant per line**; do not assign multiple unrelated names in one statement.
- **Group related constants by domain** with one blank line between groups (e.g. HTTP limits, cache TTLs, feature flags).
- Prefer readability and clean Git diffs over minimizing line count.
- When several constants describe a single concept, prefer structured config over more globals:
  - `enum.Enum` or `enum.StrEnum` for a closed set of variants
  - `@dataclass(frozen=True)` or `typing.TypedDict` for a fixed field set
  - dedicated module when the surface is large or reused across packages
- **Naming:** module-public scalars use `UPPER_SNAKE_CASE` (`MAX_RETRIES`, `REQUEST_TIMEOUT_SECONDS`). Module-private scalars use `_UPPER_SNAKE_CASE` (`_REDIS_RETRY_COOLDOWN_SECONDS`).
- **Placement:** keep scalar constants in the constants block (step 5). Place config `Enum`, `@dataclass(frozen=True)`, and `TypedDict` types in the **Classes** section (step 8), not mixed into the scalar constants block. Do not put mutable runtime dicts or flags in the constants block — use **module-level state** (step 7).

Module-public scalars:

```python
MAX_RETRIES = 3
REQUEST_TIMEOUT_SECONDS = 5.0

CACHE_TTL_SECONDS = 60.0
```

Module-private scalars (same constants block):

```python
_REDIS_RETRY_COOLDOWN_SECONDS: float = 5.0
```

Structured config (in the **Classes** section, after scalar constants):

```python
@dataclass(frozen=True)
class RetryPolicy:
    max_retries: int = 3
    timeout_seconds: float = 5.0
    backoff_seconds: float = 0.25
```

### Documentation and comments

**Default: no new docstrings or comments.** Add them only when necessary, for example: public API that must be spelled out, non-obvious behavior or invariant, or compliance with a required doc standard. Prefer clear names, types, and structure instead.

- **Module docstring** (slot 1 above): include only when it adds real value; if the module is self-explanatory, skip it and start with imports.
- **Function / class docstrings** and **`#` line comments**: same bar—not for restating what the code already says.

- Use type hints and modern patterns (`|` unions, builtin generics `list[str]`, f-strings, `with`, comprehensions). See **Type hints and modern idioms** above; do not add `from __future__ import annotations` unless required.
- Prefer f-strings for general string interpolation in Python code.
- Bind the caught value as `exception` (not `e`) — a Nexus readability preference, not PEP 8. Catch the **specific** type that can fail. Use `except Exception` only at a process or request boundary.
- Keep `try`/`except`/`finally` scopes small: wrap only the call that can fail and its direct handlers.
- Prefer top-level imports. Local imports only for lazy loading or a real circular dependency (`TYPE_CHECKING` for type-only cycles).
- When a signature or call has many clear parameter groups, prefer a typed options object (`dataclass`/`TypedDict`) or a small helper over a long flat argument list — not for short, clear signatures.
- Avoid unnecessary abstractions; refactor only when there is a clear readability gain.
- In classes, method ordering is strict: **essential dunders first** (e.g. `__init__`, and other essential magic methods when present), then **other public methods**, then **private methods last** (prefixed with `_`). Never place private methods above remaining public methods for grouping.
- Leading `_` marks internal **attributes** and **methods** (`self._client`, `_validate_order`). Function **parameters** keep contract names with no `_` prefix (`order_id`, not `_order_id`). Unused arguments may be `_` or `_name`.
- Do not create test or example files unless explicitly requested.

### Line length and wrapping

- Read the limit from formatter config (`pyproject.toml`: `[tool.black] line-length`, `[tool.ruff] line-length`; default **88** when unset).
- **Keep a statement on one line** when the full line, including indentation, fits within that limit.
- Do **not** pre-break `raise`, `return`, calls, or assignments that fit on one line.
- **No trailing comma** after the last argument when a single-line form fits — a trailing comma inside `(...)` tells Black/Ruff to expand vertically ("magic trailing comma"), even when the content would fit on one line.
- After running the formatter, collapse an unnecessarily broken line when it fits; remove the trailing comma that triggered the break.

Bad (unnecessary break; trailing comma locks multiline layout):

```python
def verify_redis() -> None:
    if get_redis_client() is None:
        raise RedisRequiredError(
            "REDIS_URL is required and Redis must be reachable for store caches",
        )
```

Good (fits within the project line limit):

```python
def verify_redis() -> None:
    if get_redis_client() is None:
        raise RedisRequiredError("REDIS_URL is required and Redis must be reachable for store caches")
```

## Visual Block Separation

Core rule: when a function body has **two or more distinct steps**, one blank line separates those **coarse** phases; never two blank lines. A short single-step body needs no extra blank lines. Typical phases when present: validation, preparation, main effect, cleanup, return. There is no canonical prepare-vs-validate order — follow the function’s flow. Do not micro-split related statements (assignment and the `if` that uses it stay together); do not use comments to label or separate blocks. Prefer readable phase layout over minimizing line count. Avoid multiple conditions on the same line or variable; prefer named intermediate booleans when they clarify a phase.

### Between Functions and Classes

Two blank lines between top-level `def` / `class` (PEP 8):

```python
def calculate_total(items: list[Item]) -> float:
    return sum(item.price for item in items)


def validate_order(order: Order) -> bool:
    return order.amount > 0
```

### Between Logical Blocks Inside Functions

```python
def process_order(order: Order) -> Transaction | None:
    if not order.is_valid():
        return None

    total = calculate_total(order.items)
    if total > order.balance:
        raise InsufficientFundsError()

    return create_transaction(order, total)
```

### Before Control Structures

```python
def execute_trade(signal: Signal) -> TradeResult | None:
    if not signal.is_valid():
        return None

    price = get_current_price(signal.symbol)

    try:
        result = place_order(signal, price)
    except BrokerError as exception:
        log_error(exception)
        return None

    return result
```

### After Main Variables

```python
def analyze_market(symbol: str) -> MarketAnalysis:
    current_price = get_price(symbol)
    historical_data = fetch_history(symbol, days=30)

    trend = calculate_trend(historical_data)

    return MarketAnalysis(price=current_price, trend=trend)
```

### Grouping Related Methods

```python
class OrderManager:
    def __init__(self, client: Client) -> None:
        self._client = client

    def create_order(self, order_data: OrderData) -> OrderId:
        pass

    def cancel_order(self, order_id: OrderId) -> None:
        pass

    def get_order_status(self, order_id: OrderId) -> OrderStatus:
        pass

    def _validate_order_data(self, data: OrderData) -> None:
        pass

    def _calculate_fees(self, amount: float) -> float:
        pass
```

## Summary

Be pragmatic: simple and clear names, organized visual structure, and code that another developer understands at first glance.

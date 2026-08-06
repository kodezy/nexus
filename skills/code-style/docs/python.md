# Clean Code Guide (Python)

## Objective

Clarity, simplicity, and pragmatism above all. Code that is easy to understand, maintain, and evolve.

## Naming

Highest priority: simple, clear, pragmatic names.

- Use direct, descriptive names: `calculate_total`, `user_name`, `process_order`.
- Avoid unnecessary abbreviations: prefer `calculate` over `calc`, `user` over `usr`.
- Use names that describe purpose, not implementation: `get_active_users` is better than `get_users_from_db`.
- For booleans, use `is_`, `has_`, `can_`.
- For functions, use verbs in infinitive form: `calculate`, `validate`, `process`.
- For classes, use singular nouns: `User`, `Order`, `Strategy`.
- Be specific when needed: `calculate_profit_margin` is better than `calculate`.
- Keep prefix and convention consistency across the module.

## Structure and Organization

- Prefer **current stable Python** (3.13+ when available) for greenfield work and new modules when the repo does not pin an older runtime.
- When the project already declares a runtime (`requires-python`, `.python-version`, CI matrix), use that version and only the features it supports.
- Dependency installs and run workflow: `architect` → `docs/python.md` (not this style guide).

### Order inside a `.py` file

Top to bottom:

1. **Module docstring** — when present, first line of the file; skip entirely when the module does not need one.
2. **`from __future__ import …`** — **only when required**; omit by default on 3.13+ (see **Type hints and modern idioms** below).
3. **`import` / `from … import`** — standard library, blank line, third-party, blank line, local. One group per layer.
4. **Global constants** — module-level `UPPER_SNAKE_CASE` and immutable config (see **Constants** below).
5. **Classes**
6. **Module-level functions** — public free functions first, then private helpers (`_`).
7. **`if __name__ == "__main__":`** — last in the file.

**How this compares to other languages:** imports and constants sit at the top; **types are optional and lightweight** (PEP 484 hints on parameters, attributes, and return values—no separate “types block” unless you need one, e.g. `TYPE_CHECKING` imports). **Behavior lives inside the `class`** (methods), not in a separate block like Rust’s `impl`. Module-level **functions come after** all classes: public free functions first, then private helpers. The **entry hook** is **`if __name__ == "__main__":`** at the bottom.

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
- Use `TYPE_CHECKING` imports only to break **real** circular imports; do not wrap every cross-reference.
- Prefer fixing definition order or a quoted forward ref (`"MyClass"`) over blanket future imports.

#### Other legacy residues to avoid on modern runtimes

- f-strings for interpolation — not `%` formatting or `.format()` in new/changed code.
- `pathlib.Path` for new path handling — not `os.path` joins unless matching surrounding legacy code.
- `@dataclass(..., slots=True)` on 3.10+ when using dataclasses (unless a project-wide convention says otherwise).
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
- **Placement:** keep scalar `UPPER_SNAKE_CASE` values in the constants block. Place config `Enum`, `@dataclass(frozen=True)`, and `TypedDict` types in the **Classes** section (file order step 5), not mixed into the scalar constants block.

Scalar constants:

```python
MAX_RETRIES = 3
REQUEST_TIMEOUT_SECONDS = 5.0

CACHE_TTL_SECONDS = 60.0
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
- Use `except Exception as exception:` always (do not use `e`).
- Keep `try`/`except`/`finally` scopes small: wrap only the call that can fail and its direct handlers.
- Prefer top-level imports. Local imports only for lazy loading or a real circular dependency (`TYPE_CHECKING` for type-only cycles).
- When a signature or call has many clear parameter groups, prefer a typed options object (`dataclass`/`TypedDict`) or a small helper over a long flat argument list — not for short, clear signatures.
- Avoid unnecessary abstractions; refactor only when there is a clear readability gain.
- In classes, method ordering is strict: **essential dunders first** (e.g. `__init__`, and other essential magic methods when present), then **other public methods**, then **private methods last** (prefixed with `_`). Never place private methods above remaining public methods for grouping.
- Internal parameters should be private (`_param`) by default, except when the name is part of an external contract.
- Do not create test or example files unless explicitly requested.

## Visual Block Separation

Core rule: one blank line separates **coarse** phases inside a function; never two blank lines. Typical phases when present: validation, preparation, main effect, cleanup, return (order follows the function’s flow). Do not micro-split related statements; do not use comments to label or separate blocks. Prefer readable phase layout over minimizing line count. Avoid multiple conditions on the same line or variable; prefer named intermediate booleans when they clarify a phase.

### Between Functions and Classes

```python
def calculate_total(items):
    return sum(item.price for item in items)

def validate_order(order):
    return order.amount > 0
```

### Between Logical Blocks Inside Functions

```python
def process_order(order):
    if not order.is_valid():
        return None

    total = calculate_total(order.items)

    if total > order.balance:
        raise InsufficientFunds()

    return create_transaction(order, total)
```

### Before Control Structures

```python
def execute_trade(signal):
    if not signal.is_valid():
        return

    price = get_current_price(signal.symbol)

    try:
        result = place_order(signal, price)
    except Exception as exception:
        log_error(exception)
        return None

    return result
```

### After Main Variables

```python
def analyze_market(symbol):
    current_price = get_price(symbol)
    historical_data = fetch_history(symbol, days=30)

    trend = calculate_trend(historical_data)

    return MarketAnalysis(price=current_price, trend=trend)
```

### Grouping Related Methods

```python
class OrderManager:
    def __init__(self, client):
        self._client = client

    def create_order(self, order_data):
        pass

    def cancel_order(self, order_id):
        pass

    def get_order_status(self, order_id):
        pass

    def _validate_order_data(self, data):
        pass

    def _calculate_fees(self, amount):
        pass
```

## Summary

Be pragmatic: simple and clear names, organized visual structure, and code that another developer understands at first glance.

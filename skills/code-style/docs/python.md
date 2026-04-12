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

- Use Python 3.13+ and modern features when compatible with the project.
- Use type hints and modern patterns (`|` for unions, f-strings, `with`, comprehensions).
- **Always use f-strings** for any string interpolation (logs, messages, building strings). Never use `%s`/`%d`, `.format()`, or concatenation. Example: `f"Processing {item}"`, `logger.debug(f"Processing {item}")`.
- Log/print messages: at most one line; clear, direct, pragmatic; never split across multiple lines.
- Use `except Exception as exception:` always (do not use `e`).
- Avoid unnecessary abstractions; refactor only when there is a clear readability gain.
- **Do not add docstrings or comments** unless strictly necessary (e.g. public API contract, non-obvious algorithm). Prefer self-explanatory code; avoid obvious or redundant comments.
- Respect the project’s current organization pattern (names, architecture, and flow).
- In classes, method ordering is strict: **public methods first**, then **magic/dunder methods** (e.g. `__init__`, `__repr__`, `__iter__`), and **private methods last** (prefixed with `_`). Private methods must always be at the end of the class.
- Internal parameters should be private (`_param`) by default, except when the name is part of an external contract.
- Do not create test or example files unless explicitly requested.

## Visual Block Separation

Core rule: one blank line separates logical blocks; never two blank lines. Use space to separate contexts (validation, calculation, return). Avoid multiple conditions on the same line or variable; prefer well-defined blocks and named intermediate booleans for readability.

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

Be pragmatic: simple and clear names, organized visual structure, respect for the project’s pattern, and code that another developer understands at first glance.

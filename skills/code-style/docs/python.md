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

- Use modern Python features supported by the project runtime.

### Order inside a `.py` file

Top to bottom:

1. **Module docstring** — when present, first line of the file; skip entirely when the module does not need one.
2. **`import` / `from … import`** — standard library, blank line, third-party, blank line, local. One group per layer.
3. **Global constants** — module-level `UPPER_SNAKE_CASE` and immutable config.
4. **Classes**
5. **Module-level functions** — free functions and helpers.
6. **`if __name__ == "__main__":`** — last in the file.

**How this compares to other languages:** imports and constants sit at the top; **types are optional and lightweight** (PEP 484 hints on parameters, attributes, and return values—no separate “types block” unless you need one, e.g. `TYPE_CHECKING` imports). **Behavior lives inside the `class`** (methods), not in a separate block like Rust’s `impl`. Module-level **functions come after** all classes. The **entry hook** is **`if __name__ == "__main__":`** at the bottom.

### Documentation and comments

**Default: no new docstrings or comments.** Add them only when necessary, for example: public API that must be spelled out, non-obvious behavior or invariant, or compliance with a required doc standard. Prefer clear names, types, and structure instead.

- **Module docstring** (slot 1 above): include only when it adds real value; if the module is self-explanatory, skip it and start with imports.
- **Function / class docstrings** and **`#` line comments**: same bar—not for restating what the code already says.

- Use type hints and modern patterns (`|` for unions, f-strings, `with`, comprehensions).
- Prefer f-strings for general string interpolation in Python code.
- Use `except Exception as exception:` always (do not use `e`).
- Avoid unnecessary abstractions; refactor only when there is a clear readability gain.
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

Be pragmatic: simple and clear names, organized visual structure, and code that another developer understands at first glance.

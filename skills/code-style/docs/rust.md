# Clean Code Guide - Rust

## Objective

Clarity, simplicity, and pragmatism above all. Code that is easy to understand, maintain, and evolve.

## Naming

Highest priority: simple, clear, pragmatic names.

- Use direct, descriptive names: `calculate_total`, `user_name`, `process_order`.
- Avoid unnecessary abbreviations: prefer `calculate` over `calc`, `user` over `usr`.
- Use names that describe purpose, not implementation: `get_active_users` is better than `get_users_from_db`.
- For booleans: `is_active`, `has_permission`, `can_trade`.
- For functions: verbs in infinitive form: `calculate`, `validate`, `process`.
- For types: singular nouns: `User`, `Order`, `Strategy`.
- For modules: plural or singular nouns as context dictates: `users`, `order`, `strategies`.
- Be specific when needed: `calculate_profit_margin` is better than `calculate`.
- Keep consistency: if you use `get_` for reads, always use `get_`.
- Use `snake_case` for functions, variables, and modules.
- Use `PascalCase` for types, traits, enums, and structs.
- Use `SCREAMING_SNAKE_CASE` for constants.

## Structure and Organization

- Always use Rust edition 2021+ and modern language features.
- Use type annotations when they improve clarity, but avoid when obvious.
- **Always use format strings** for interpolation: `format!("{}", x)`, `format!("{name}: {value}"), etc. Prefer `format!` over string concatenation or manual building.
- Prefer `Result<T, E>` and `Option<T>` over exceptions or null values.
- Use `match` for explicit pattern matching, `if let` when appropriate.
- Do not overcomplicate: avoid unnecessary abstractions; refactor only to reduce repetition when it genuinely improves readability.
- **Do not add doc comments (`///`) or line comments** unless strictly necessary (e.g. public API, non-obvious algorithm). Prefer self-explanatory code.
- Follow and respect the project’s current organization, names, architecture, and flow.
- Prefer public methods first in `impl` blocks, private methods after.
- Use `pub` only when needed for the public API.
- Organize methods following best conventions: public methods first, then private.
- Do not create test or example files unless explicitly requested.
- Use `&str` when possible instead of `String` for read-only parameters.
- Prefer borrowing (`&`) when possible; use ownership (`move`) only when necessary.
- Use `clippy` and follow its recommendations when they make sense.
- Prefer `unwrap_or`, `unwrap_or_else`, `map`, `and_then` over `unwrap` or `expect` when possible.
- Use the `?` operator for idiomatic error propagation.

## Visual Block Separation

Core rule: one blank line separates logical blocks; never two blank lines.

### Between Functions and Structs

```rust
fn calculate_total(items: &[Item]) -> f64 {
    items.iter().map(|item| item.price).sum()
}


fn validate_order(order: &Order) -> bool {
    order.amount > 0.0
}
```

### Between Logical Blocks Inside Functions

```rust
fn process_order(order: &Order) -> Result<Transaction, OrderError> {
    if !order.is_valid() {
        return Err(OrderError::Invalid);
    }

    let total = calculate_total(&order.items);

    if total > order.balance {
        return Err(OrderError::InsufficientFunds);
    }

    create_transaction(order, total)
}
```

### Before Control Structures

```rust
fn execute_trade(signal: &Signal) -> Option<TradeResult> {
    if !signal.is_valid() {
        return None;
    }

    let price = get_current_price(&signal.symbol)?;

    match place_order(signal, price) {
        Ok(result) => Some(result),
        Err(error) => {
            log_error(&error);
            None
        }
    }
}
```

### After Main Variables

```rust
fn analyze_market(symbol: &str) -> Result<MarketAnalysis, AnalysisError> {
    let current_price = get_price(symbol)?;
    let historical_data = fetch_history(symbol, 30)?;

    let trend = calculate_trend(&historical_data)?;

    Ok(MarketAnalysis {
        price: current_price,
        trend,
    })
}
```

### Grouping Related Methods

```rust
impl OrderManager {
    pub fn create_order(&mut self, order_data: OrderData) -> Result<OrderId, OrderError> {
        // ...
    }

    pub fn cancel_order(&mut self, order_id: OrderId) -> Result<(), OrderError> {
        // ...
    }

    pub fn get_order_status(&self, order_id: OrderId) -> Option<OrderStatus> {
        // ...
    }

    fn validate_order_data(&self, data: &OrderData) -> Result<(), ValidationError> {
        // ...
    }

    fn calculate_fees(&self, amount: f64) -> f64 {
        // ...
    }
}
```

### Module Organization

```rust
mod order {
    pub struct Order {
        // ...
    }

    pub fn create() -> Order {
        // ...
    }

    fn validate() -> bool {
        // ...
    }
}
```

## Ownership and Borrowing

- Prefer `&T` for read-only parameters: `fn process(data: &Data)`.
- Use `&mut T` only when you actually need to modify: `fn update(data: &mut Data)`.
- Use ownership (`T`) when the function must consume the value: `fn take_ownership(data: Data)`.
- For returns, prefer owned types when it makes sense: `fn create() -> String`.
- Use `clone()` only when necessary, not by default.
- Prefer `Cow<'_, str>` when the value can be `&str` or `String` as needed.

## Error Handling

- Use `Result<T, E>` for operations that can fail.
- Use `Option<T>` for optional values.
- Define specific, descriptive error types.
- Use `thiserror` or `anyhow` when appropriate, but keep it simple.
- Propagate errors with `?` instead of `match` when possible.
- Use `map_err` to convert between error types when needed.
- Avoid `unwrap()` and `expect()` in production code; use only in tests or when truly guaranteed.

## Summary

Always be pragmatic: simple and clear names, well-separated visual structure, respect for the project’s pattern, and code that another developer understands at first glance. Leverage Rust’s type system for safety without sacrificing clarity.

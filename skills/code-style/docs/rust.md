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

- Prefer the **stable** Rust toolchain (`rustup default stable` / `rust-toolchain.toml` channel `stable`) unless the project pins another channel.
- Prefer **edition 2024** for greenfield crates when the stable toolchain supports it; otherwise edition **2021+**. Match `edition` / `rust-version` already set in `Cargo.toml`.
- Use modern language features supported by that edition and toolchain.
- Avoid pre-edition-2018 residues in new code (`extern crate` at crate root, `try!` instead of `?`) unless matching existing crate style.

### Module organization

Design child `mod` blocks and sibling files around cohesive **concepts**, not around individual types.

- One **concept** per module or crate subtree, not one module per struct or trait. Keep related behavior together; do not split solely for file size.
- Split when a module has multiple independent responsibilities, is hard to navigate, or has multiple reasons to change.
- Avoid `utils`, `helpers`, `common`, `misc`. Place code in the owning module or a named shared module (`format`, `dates`, `validation`). Crate layout: `architect`.

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

### Order inside a `.rs` file

Top to bottom:

1. **Inner attributes** — `#! [...]` when needed.
2. **`mod`** — child module declarations.
3. **`use`** — `std`, then other crates, then `crate::`, then `super::`, then `self::`; blank line between groups.
4. **`const` / `static` / `type`** — see **Constants** below.
5. **`struct` / `enum` / `union`**
6. **`trait`**
7. **`impl`** — after the `struct`/`enum`/`trait` each block implements (inherent `impl` right after its type; `impl Trait for` after that `trait`).
8. **Module-level functions** — free `fn` items.
9. **`fn main`** — in the binary root only; last.

**How this compares to other languages:** **`use`** is the import layer at the top (after inner `#!` and `mod` when present). **Constants** (`const` / `static` / `type` aliases) follow the import block. **Types are central:** `struct` / `enum` / `union` and `trait` define shape; **methods and trait items live only in `impl`**, not inside the `struct`/`enum` braces. **Free functions** sit **after** that type/`impl` chain. **Entry** for binaries is **`fn main`**, last. This differs from Python/TypeScript, where behavior is written inside the class body.

### Constants

- Declare **one constant per line**; do not declare multiple unrelated `const`/`static` items on one line.
- **Group related constants by domain** with one blank line between groups (e.g. HTTP limits, cache TTLs, feature flags). Use a child `mod` when a group is large or reused.
- Prefer readability and clean Git diffs over minimizing line count.
- When several constants describe a single concept, prefer structured config over more globals:
  - `struct` + `impl` with associated `const` defaults (see below)
  - `enum` for a closed set of variants
  - dedicated submodule when the surface is large or shared across crates
- **Placement:** keep scalar `SCREAMING_SNAKE_CASE` values in the constants block. Config `struct`/`enum` types belong in steps 5–7; a `const` whose type is a local `struct` must come **after** that `struct` (and typically lives in an `impl` associated `const`, not above the type definition).

Scalar constants:

```rust
const MAX_RETRIES: u32 = 3;
const REQUEST_TIMEOUT_MS: u64 = 5_000;

const CACHE_TTL_MS: u64 = 60_000;
```

Structured config (`struct` + `impl`; not in the scalar constants block):

```rust
struct RetryPolicy {
    max_retries: u32,
    timeout_ms: u64,
    backoff_ms: u64,
}

impl RetryPolicy {
    pub const DEFAULT: Self = Self {
        max_retries: 3,
        timeout_ms: 5_000,
        backoff_ms: 250,
    };
}
```

### Documentation and comments

**Default: no new doc comments or line comments.** Add `///`, `//!`, or `//` only when necessary, for example: public API surface, safety or correctness notes the types do not express, or non-obvious algorithm/invariant. Prefer self-explanatory code and names.

- Use type annotations when they improve clarity, but avoid when obvious.
- **Always use format strings** for interpolation: `format!("{}", x)`, `format!("{name}: {value}")`, etc. Prefer `format!` over string concatenation or manual building.
- Prefer `Result<T, E>` and `Option<T>` over exceptions or null values.
- Use `match` for explicit pattern matching, `if let` when appropriate.
- Do not overcomplicate: avoid unnecessary abstractions; refactor only to reduce repetition when it genuinely improves readability.
- In `impl` blocks, order is strict: constructors / essential associated constructors first (`new`, `try_new`, etc. when present), then other `pub` methods, then private methods last.
- At module level, public free `fn` items come before private free `fn` items.
- Use `pub` only when needed for the public API.
- Never place private items above remaining public items for grouping; group only within the same visibility band.
- Do not create test or example files unless explicitly requested.
- Use `&str` when possible instead of `String` for read-only parameters.
- Prefer borrowing (`&`) when possible; use ownership (`move`) only when necessary.
- Use `clippy` and follow its recommendations when they make sense.
- Prefer `unwrap_or`, `unwrap_or_else`, `map`, `and_then` over `unwrap` or `expect` when possible.
- Use the `?` operator for idiomatic error propagation.

## Visual Block Separation

Core rule: one blank line separates **coarse** phases inside a function; never two blank lines. Typical phases when present: validation, preparation, main effect, cleanup, return (order follows the function’s flow). Do not micro-split related statements; do not use comments to label or separate blocks. Prefer readable phase layout over minimizing line count.

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
    pub fn new(client: Client) -> Self {
        Self { client }
    }

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
- Propagate errors with `?` instead of `match` when possible; keep `match` arms narrow when you must handle locally.
- Use `map_err` to convert between error types when needed.
- Avoid `unwrap()` and `expect()` in production code; use only in tests or when truly guaranteed.

## Calls and imports

- Prefer top-level `use`. Nested/`use` inside a function only for lazy loading or to break a real circular dependency.
- When a signature or call has many clear parameter groups, prefer a typed options struct or a small helper over a long flat argument list — not for short, clear signatures.

## Summary

Always be pragmatic: simple and clear names, well-separated visual structure, and code that another developer understands at first glance. Leverage Rust’s type system for safety without sacrificing clarity.

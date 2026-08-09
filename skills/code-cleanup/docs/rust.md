# Code cleanup — Rust

Use with `../SKILL.md`. Match existing crate edition and style (`code-style` / `architect` rust docs).

## Scope signals

- `src/` modules, binaries, and `tests/` for the same crate flow.
- `mod` declarations and `pub use` re-exports in the affected subtree.

## Evidence (prefer project tooling)

| Check | Typical command / signal |
| --- | --- |
| Compiler unused | `cargo check`, `cargo build` (warnings) |
| Clippy dead code | `cargo clippy -- -W dead_code -W unused` or project CI |
| Tests | `cargo test` for affected crate/modules |
| Module graph | `mod` tree, `pub use`, binary `main` only calling removed fns |

Search for `#[allow(dead_code)]` and macro-generated items before deleting.

## Remove when obvious

- Unused `fn`, `struct`, `enum` variant, `const`, or `use` in scope (no `pub` consumers).
- Unreachable `match` arms after enum consolidation.
- Duplicate error mapping in adapter + domain layer—keep one boundary.
- Empty `impl` blocks or trait impls with no call sites.
- Orphan `mod` file no longer declared in parent `mod.rs` / parent module.

## Duplication patterns

- **Repeated `map_err` chains** — helper only if 2+ identical chains in scope; place in owning module, not `util.rs`.
- **Clone-heavy pass-through functions** — inline when single caller.
- **Parallel `From` / `Into` impls** — merge conversions at the type that owns the boundary.

## Simplification over abstraction

- Prefer `?` and narrow `match` over wrapper functions that only forward.
- Collapse trait objects used by a single concrete type when the trait adds no test seam.
- Do not introduce a new `services/` layer unless the crate already uses that pattern (`architect`).

## Escalate

- `pub` items, `pub use` in `lib.rs`, or documented crate API.
- `#[no_mangle]`, `export_name`, FFI, and proc-macro generated symbols.
- Feature-gated code (`#[cfg(feature = …)]`) without confirmed feature removal.
- `include!`, `build.rs` generated modules, and workspace path dependencies.

## After cleanup

Run `$code-style` (`docs/rust.md` in that skill), then `$integrity-review`.

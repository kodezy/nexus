# Logging (Rust)

## Default

At call sites, use the **`log`** crate macros:

```rust
log::info!("worker {} connected on port {}", worker_id, port);
log::warn!("retry {attempt} for job {job_id}");
log::error!("failed to persist order {order_id}: {err}");
```

Pass format args to the macro; avoid building strings with `+` or `format!` solely to log them.

Configure output once at binary startup with **fern** (or a project wrapper around it):

```rust
fern::Dispatch::new()
    .level(log::LevelFilter::Info)
    .chain(std::io::stdout())
    .apply()?;
```

Level, timestamps, and targets belong in that single dispatch — not scattered per module.

## When the crate already uses `tracing`

Match the existing stack (`tracing::info!`, spans, subscribers). Do not introduce a parallel `log` + fern path in the same binary without an explicit migration.

## Levels

Same intent as other stacks: `debug` for diagnostics, `info` for normal flow, `warn` for recoverable issues, `error` for failures. Prefer one error log at the layer that handles or surfaces the failure.

## Structured context

Keep messages short; put variable data in format args or structured fields the project already uses. Reuse field names the service already logs (`request_id`, `order_id`).

If the codebase uses `tracing` spans for request scope, attach context there instead of repeating IDs in every line.

## Setup (greenfield)

- One `fern::Dispatch` (or shared `init_logging()` helper) in the binary crate.
- Library crates log via `log` macros only — they do not configure sinks.
- Respect `RUST_LOG` or the project's env convention when filtering modules.

## Do not log

Secrets, bearer tokens, private key material, or full payloads that may contain PII. Log stable identifiers and error types instead.

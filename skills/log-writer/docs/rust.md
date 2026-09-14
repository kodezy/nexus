# Logging (Rust)

## When the crate uses `log`

At call sites, use the **`log`** crate macros:

```rust
log::info!("worker {} connected on port {}", worker_id, port);
log::warn!("retry {attempt} for job {job_id}");
log::error!("failed to persist order {order_id}: {err}");
```

Pass format args to the macro; avoid building strings with `+` or `format!` solely to log them.

If the binary configures output with **fern** (or a project wrapper), keep that in one startup path — level, timestamps, and targets belong in a single dispatch, not scattered per module.

## When the crate already uses `tracing`

Match the existing stack (`tracing::info!`, spans, subscribers). Do not introduce a parallel `log` + fern path in the same binary without an explicit migration.

## When no logger is established

Ask before choosing `log`, `tracing`, or another stack.

## Levels

Same intent as other stacks: `debug` for diagnostics, `info` for normal flow, `warn` for recoverable issues, `error` for failures. Prefer one error log at the layer that handles or surfaces the failure.

## Structured context

Keep messages short; put variable data in format args or structured fields the project already uses. Reuse field names the service already logs (`request_id`, `order_id`).

If the codebase uses `tracing` spans for request scope, attach context there instead of repeating IDs in every line.

## Setup

- One shared `init_logging()` helper or subscriber in the binary crate when the project uses that pattern.
- Library crates log via the project's macros only — they do not configure sinks.
- Respect `RUST_LOG` or the project's env convention when filtering modules.

## Do not log

Secrets, bearer tokens, private key material, or full payloads that may contain PII. Log stable identifiers and error types instead.

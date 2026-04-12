# Logging Style Guide

## Objective

Keep logging consistent, readable, and useful across the codebase: one line per message, format-string interpolation only, clear context, and the right level. Applies to Python (e.g. `manager/main.py`) and Rust.

## Message Format (All Languages)

- **One line per message**: keep the message on a single line; do not split across multiple lines.
- **Clear and direct**: describe what happened or what is happening in plain language.
- Prefer past tense for completed actions and present for ongoing state when it improves clarity.
- Include enough context: names, IDs, ports, or key values when relevant.
- Use an em dash (—) to separate a short label from variable context when it keeps the line readable.
- Keep the message concise; avoid duplicating the same context in every log of a sequence.

## Logger Setup

### Python

- Obtain the module logger at module level with the module name:
  - `logger = setup_logger(__name__)` when the project provides `setup_logger`.
  - Otherwise: `logger = logging.getLogger(__name__)`.
- Do not create loggers inside functions or classes; use the module-level logger.

### Rust

- Use the `log` crate macros at the call site: `info!`, `warn!`, `error!`, `debug!`, `trace!`.
- If the project uses a module-scoped logger or `tracing`, follow the project pattern; still use one line per message and format strings.
- Do not build loggers inside hot paths; use the crate’s standard or project-configured setup.

## String Interpolation

### Python

- **Always use f-strings** for log messages. Never use `%` formatting, `.format()`, or string concatenation.

```python
logger.info("Debug mode enabled")
logger.info("Tekram starting")
logger.info(f"Manager (WSS) reusing existing — {existing_manager._host}:{existing_manager._port}")
logger.warning(f"Unknown option: {arg}")
logger.warning(f"Error closing recordings on shutdown: {exception}")
```

Avoid: `logger.info("Started %s" % name)`, `logger.info("Value: {}".format(x))`, or multi-line message strings.

### Rust

- **Always use format strings** for log messages: `format!(...)` or the macro form with format args (e.g. `info!("{}", x)`, `info!("{name} — {host}:{port}", ...)`). Never use string concatenation or manual building.

```rust
info!("Debug mode enabled");
info!("Tekram starting");
info!("Manager (WSS) reusing existing — {}:{}", host, port);
warn!("Unknown option: {}", arg);
warn!("Error closing recordings on shutdown: {}", error);
```

Avoid: `info!("Started ".to_string() + &name)`, or multi-line format strings; keep one line per macro call.

## Log Levels

Use the same semantics in both languages:

- **DEBUG** (Python `logger.debug`, Rust `debug!`): detailed flow, state changes, or values useful only when debugging.
- **INFO** (Python `logger.info`, Rust `info!`): normal application flow and notable events (startup, shutdown, listening, mode changes, success of a major step).
- **WARNING** (Python `logger.warning`, Rust `warn!`): recoverable or unexpected situations (unknown options, retries, non-fatal errors).
- **ERROR** (Python `logger.error`, Rust `error!`): operation failed but execution continues.
- **CRITICAL** (Python only `logger.critical`): uncaught exceptions or unrecoverable failures; use with `exc_info` when logging an exception. In Rust, use `error!` for fatal or panic-like cases and include context in the message.

## Exceptions and Fatal Errors

### Python

- For **uncaught or fatal** exceptions, use `logger.critical(...)` and pass `exc_info` so the stack trace is recorded:

```python
logger.critical(
    f"Uncaught exception: {exc_type.__name__}: {exc_value}",
    exc_info=(exc_type, exc_value, exc_traceback),
)
```

- For **handled** errors, use `logger.warning` or `logger.error` with an f-string; add `exc_info=True` only if the full trace is needed:

```python
except Exception as exception:
    logger.warning(f"Error closing recordings on shutdown: {exception}")
```

### Rust

- For **fatal or panic-like** cases, use `error!` with a clear message and include the error (e.g. `error!("Uncaught error in thread {}: {}: {}", thread_name, err_type, err_value)`). Use the project’s panic hook or error reporting if one exists.
- For **handled** errors, use `warn!` or `error!` with format args that include the error: `warn!("Error closing recordings on shutdown: {}", e)`.

## What to Avoid (All Languages)

- Multi-line log messages.
- Vague messages (e.g. "Done", "Here").
- Logging inside tight loops without a good reason (consider level or sampling).

## Summary

- **Format**: one line per message; clear, direct wording; format-string interpolation only (f-strings in Python, `format!`/macro args in Rust).
- **Levels**: DEBUG for detailed flow, INFO for normal flow, WARNING/ERROR for problems, CRITICAL (Python) or `error!` (Rust) for uncaught/fatal cases.
- **Context**: add names, ports, options where it helps; use — for label vs context when it fits.
- **Python**: module-level `logger = setup_logger(__name__)`; use `exc_info` for critical/fatal exceptions.
- **Rust**: use `log` (or project) macros with format strings; use `error!` for fatal cases and include error context in the message.

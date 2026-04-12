---
name: log-writer
description: Define and apply logging standards for messages, levels, and structure. Use when adding, changing, or reviewing log statements, logger setup, or logging configuration in any language.
---

# Logging Standards

## When to Use This Skill

- Adding new log statements (debug, info, warning, error).
- Changing or standardizing existing log messages.
- Setting up or configuring loggers (Python `logging`, Rust `tracing`/`log`, etc.).
- Deciding log level and message content for errors and events.

Apply this skill **before** or **together** with code-style when the change involves logging.

## Principles

1. **Levels:** Use the right level—debug for development detail, info for normal flow, warning for recoverable issues, error for failures.
2. **Messages:** Short, clear, in English. Prefer structured context (e.g. key-value) over long prose.
3. **Single line (code and output):** Each log event should be one plain sentence in the log output—no embedded newlines (`\n`) unless you intentionally log a stack trace or multiline blob. In source, express the message as **one** string (one f-string or one implicitly joined literal), on **one line** when it fits the project line length. Do not split the same sentence across several lines of string fragments for readability; keep the call compact and pragmatic. If the line is too long, shorten the wording or move details into `extra={...}` / structured fields instead of wrapping prose across lines.
4. **Consistency:** Match the project’s existing logging style (same logger name, same format, same place for context).
5. **No secrets:** Never log passwords, tokens, or other sensitive data.
6. **Structured when useful:** In APIs or services, prefer structured fields (e.g. `user_id`, `request_id`) for filtering and analysis.

### Example (Python, avoid vs prefer)

Avoid splitting one sentence across multiple lines of strings:

```python
# Avoid
logger.warning(
    f"Worker {worker_id} has invalid/closed websocket, marking for disconnection "
    f"(state: {worker.state.value})",
)

# Prefer
logger.warning(
    f"Worker {worker_id} invalid or closed websocket, marking disconnect (state={worker.state.value})",
)
```

Prefer one line if it stays within the formatter’s line length:

```python
logger.warning(f"Worker {worker_id} invalid or closed websocket, marking disconnect (state={worker.state.value})")
```

## By Stack

- **Python:** Use `logging` module; get logger with `logging.getLogger(__name__)`. Avoid `print()` for production logs.
- **Rust:** Use `tracing` or `log` as in the project; use spans and events for context where appropriate.
- **TypeScript/JavaScript:** Use the project’s logger (e.g. `pino`, `winston`); keep levels and message shape consistent.

## Workflow

1. Check how logging is done in the same file or module.
2. Choose the appropriate level and a clear, single-sentence message (one line in output; one compact expression in code).
3. Add any needed context (IDs, counts) without leaking secrets; use structured `extra` fields if the sentence would become too long.
4. Ensure new logs align with existing format and conventions.

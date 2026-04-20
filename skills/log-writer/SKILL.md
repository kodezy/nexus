---
name: log-writer
description: Define and apply logging standards for messages, levels, and structure. Use when adding, changing, or reviewing log statements, logger setup, or logging configuration in any language.
---

# Logging Standards

## When to Use This Skill

- Adding new log statements (debug, info, warning, error).
- Changing or standardizing existing log messages.
- Setting up or configuring loggers (Python **loguru**, Rust **`log` + fern**, TypeScript **consola**, etc.).
- Deciding log level and message content for errors and events.

Apply this skill **before** or **together** with code-style when the change involves logging.

## Principles

1. **Levels:** Use the right level: debug for deep diagnostics, info for normal flow, warning for recoverable issues, error for failures.
2. **Messages:** Keep text short, direct, and in English.
3. **One event per line:** Keep each log event to one output line; allow multiline only for intentional stack traces or multiline payloads.
4. **Structured context:** Prefer fields/attributes (`request_id`, `user_id`, `order_id`) over long prose.
5. **No secrets:** Never log passwords, tokens, private keys, or personal data unless explicitly required and redacted.
6. **Local consistency:** Match the project logger, formatting style, and context shape already used in the module.

## By Stack

The sections below are **language-specific**. Do not apply Python rules (for example f-strings) to Rust, TypeScript, or other stacks. For a language not listed, follow [Principles](#principles) and the logging style already used in the codebase.

### Python (loguru)

- Use **loguru** (`from loguru import logger`). Do not add new code paths on the stdlib `logging` module unless the file already uses it and you are matching local style.
- For interpolating values into the message string, use **f-strings only** (project policy). This applies to Python only; other languages use their idiomatic patterns below.

```python
from loguru import logger

logger.info(f"Worker {worker_id} connected on port {port}")
```

- Avoid `%` formatting, `.format()`, and concatenation in log messages:

```python
# Avoid
logger.info("Worker %s connected on port %s", worker_id, port)
logger.info("Worker {} connected on port {}".format(worker_id, port))
logger.info("Worker " + str(worker_id) + " connected")
```

- Use `logger.exception(...)` (or `logger.opt(exception=True).error(...)`) when a stack trace is needed; otherwise log concise error context without stack noise.
- Use `logger.bind(...)` when attaching stable context fields; keep field names consistent across the service.

### Rust (`log` + fern)

- Use the **`log`** crate macros at call sites (`log::info!`, `log::warn!`, `log::error!`, …). Pass format args; avoid string concatenation for dynamic pieces.

```rust
log::info!("worker {} connected on port {}", worker_id, port);
```

- Configure output (levels, format, targets) with **fern** once at process startup—typically in `main` or the crate that owns binary entry. Apply a single `fern::Dispatch` (or project wrapper) so all modules share the same policy.

```rust
// Example: startup only — adjust format/level to project standards
fern::Dispatch::new()
    .level(log::LevelFilter::Info)
    .chain(std::io::stdout())
    .apply()?;
```

- Do not introduce **`tracing`** for new application logging in this repo unless existing code already uses it; then match that module.

### TypeScript/JavaScript (consola)

- Prefer **consola** for new code (`import { consola } from 'consola'`). Use `consola.withTag('context')` or scoped loggers when it improves traceability.
- Prefer template literals when building message strings with embedded values; avoid long chains of `+` concatenation.

```typescript
import { consola } from 'consola';

consola.info(`Worker ${workerId} connected on port ${port}`);
```

- If the project already standardizes on another logger (`pino`, `winston`, etc.) in a given package, match that package until a deliberate migration.

## Workflow

1. Check the logging pattern in the same module/service.
2. Choose the level by operational impact.
3. Keep message text short and attach context as structured fields.
4. Validate no sensitive data is emitted.
5. Run code-style after logging decisions are finalized.

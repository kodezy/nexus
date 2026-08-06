# Logging (Python)

## Default

Prefer **loguru** for new code:

```python
from loguru import logger

logger.info(f"Worker {worker_id} connected on port {port}")
```

Do not add stdlib `logging` in new modules unless the service or repo already standardizes on it — then match local setup (handlers, formatters, `LoggerAdapter`, etc.).

## Messages

- Use **f-strings** for interpolated values in log messages.
- Avoid `%` formatting, `.format()`, and string concatenation in log calls.

```python
# Avoid
logger.info("Worker %s connected on port %s", worker_id, port)
logger.info("Worker " + str(worker_id) + " connected")
```

## Levels and errors

| Level | Use for |
| --- | --- |
| `debug` | Verbose diagnostics, loop internals |
| `info` | Normal lifecycle (started, completed, connected) |
| `warning` | Recoverable oddity (retry, fallback, deprecated path) |
| `error` | Failure that needs attention |

- `logger.exception(...)` (or `logger.opt(exception=True).error(...)`) when a stack trace helps; otherwise log concise error context without stack noise.
- Log once at the boundary that owns recovery (handler, worker, CLI entry) — avoid duplicate error lines for the same failure bubbling up.

## Structured context

Attach stable fields with `logger.bind(...)` or equivalent local pattern. Keep names consistent across the service (`request_id`, `job_id`, `user_id`).

```python
log = logger.bind(request_id=request_id)
log.info(f"Order {order_id} created")
```

Prefer fields over embedding IDs only in free text when downstream tools may filter on them.

## Setup (greenfield)

Configure loguru once at process entry (CLI `main`, app factory, worker bootstrap) — not per module. Typical knobs: level from env, stderr/stdout sink, serialize JSON when the deployment expects it.

Match existing project helpers if present; do not invent a second global logging path.

## Do not log

Passwords, API keys, session tokens, private keys, full auth headers, or unredacted PII. When debugging auth, log stable opaque identifiers only (`user_id`, `session_id` prefix) if the project already does so.

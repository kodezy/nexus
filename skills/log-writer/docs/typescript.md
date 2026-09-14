# Logging (TypeScript / JavaScript)

## When the package uses consola

```typescript
import { consola } from 'consola';

consola.info(`Worker ${workerId} connected on port ${port}`);
```

Use `consola.withTag('billing')` or a scoped logger when it improves traceability without repeating a prefix in every message.

## When the package already uses another logger

Match local choice (`pino`, `winston`, `debug`, framework logger) until a deliberate migration. Same principles apply: level, short English message, structured fields the logger supports.

## When no logger is established

Ask before introducing consola, pino, winston, or another library.

## Messages

- Prefer template literals for interpolated values.
- Avoid long `+` concatenation chains.
- One line per event; multiline only for intentional stack traces.

## Levels

Use the levels your logger exposes. Typical mapping:

| Intent | Use for |
| --- | --- |
| `debug` | Verbose diagnostics |
| `info` | Normal lifecycle |
| `warn` | Recoverable oddity |
| `error` | Failure |

Log errors once at the boundary that owns handling (route handler, job runner, CLI). Include `cause` / `err` when useful; avoid logging the same rejection at every middleware layer.

## Structured context

Pass a context object when the logger supports it:

```typescript
logger.info({ requestId, orderId }, `Order created`);
```

Reuse field names already present in the package (`requestId` vs `request_id` — pick what the codebase uses).

## Browser vs server

- **Server / Node:** match the project's server logger; respect env log level.
- **Browser:** avoid noisy `debug` in hot paths; never log secrets from `localStorage`, cookies, or auth headers.

## Do not log

Tokens, passwords, API keys, or full request/response bodies that may contain PII. Redact or omit when unsure.

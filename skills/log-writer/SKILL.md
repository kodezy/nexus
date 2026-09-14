---
name: log-writer
description: Define and apply logging standards for messages, levels, and structure. Use when adding, changing, or reviewing log statements, logger setup, or logging configuration in any language.
---

# Logging Standards

## When to Use

- Adding or changing log statements (debug, info, warning, error).
- Setting up or configuring a logger.
- Choosing level and message content for errors and events.

Apply this skill **before** or **together** with `$code-style` when the change involves logging.

## Principles

1. **Levels:** debug for deep diagnostics, info for normal flow, warning for recoverable issues, error for failures.
2. **Messages:** short, direct, English.
3. **One event per line:** multiline only for intentional stack traces or multiline payloads.
4. **Structured context:** prefer fields (`request_id`, `user_id`, `order_id`) over long prose.
5. **No secrets:** never log passwords, tokens, private keys, or personal data unless explicitly required and redacted.
6. **Local conventions win:** match the logger, format, and context shape already used in the module or package. If the repo has no logging pattern yet, ask before introducing a library or global setup.

## Stack Selection

Pick the doc for the file you are editing when the repository already uses that stack. Do not mix rules across languages.

1. **Python** (`.py`, services, scripts): `docs/python.md` when the project uses that logger family (for example loguru or stdlib `logging`).
2. **Rust** (`.rs`, `Cargo.toml`): `docs/rust.md` when the project uses `log`, `tracing`, or an established wrapper.
3. **TypeScript / JavaScript** (`.ts`, `.tsx`, `.js`, `.mjs`): `docs/typescript.md` when the package already uses that logger (for example consola, pino, winston).
4. **Other languages:** follow [Principles](#principles) and the logging style already used in the codebase.

## Workflow

1. Read the logging pattern in the same module or adjacent files.
2. Open the stack doc above only when it matches the project's logger.
3. Choose the level by operational impact.
4. Keep message text short; attach context as structured fields.
5. Confirm no sensitive data is emitted.
6. Run `$code-style` on touched files after logging decisions are final.

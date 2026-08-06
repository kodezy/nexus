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
6. **Local conventions win:** match the logger, format, and context shape already used in the module or package. Stack-doc defaults apply to greenfield work only.

## Stack Selection

Pick the doc for the file you are editing. Do not mix rules across languages.

1. **Python** (`.py`, services, scripts): `docs/python.md` — prefer **loguru**; match stdlib `logging` when the file or service already uses it.
2. **Rust** (`.rs`, `Cargo.toml`): `docs/rust.md` — prefer **`log`** at call sites and **fern** at startup; match **`tracing`** when the crate already standardizes on it.
3. **TypeScript / JavaScript** (`.ts`, `.tsx`, `.js`, `.mjs`): `docs/typescript.md` — prefer **consola**; match **pino**, **winston**, or another logger when the package already uses it.
4. **Other languages:** follow [Principles](#principles) and the logging style already used in the codebase.

## Workflow

1. Read the logging pattern in the same module or adjacent files.
2. Open the stack doc above when you need setup or examples.
3. Choose the level by operational impact.
4. Keep message text short; attach context as structured fields.
5. Confirm no sensitive data is emitted.
6. Run `$code-style` on touched files after logging decisions are final.

---
name: project-context
description: >-
  Capture learnings in docs/<topic>.md, grow the AGENTS.md ## Docs index, and
  merge docs when asked. Use when the user asks to document, bootstrap, save a
  learning, or refresh docs/. On demand only — never auto-save during routine
  implementation.
---

# Project Context

Grow committed `docs/` in the **app repo**, indexed from `AGENTS.md` → `## Docs`.

Create `docs/<slug>.md` when there is content. Add a row per file. Docs may link to each other.

## When to use

Only when the user explicitly asks to capture, bootstrap, refresh, merge, or prune docs.

## Workflow

Follow `docs/curator.md`. Optional shapes: `examples/docs/` in the Nexus harness checkout.

## After changes

Do not commit unless asked. Doc changes go through `$integrity-review` like other project docs.

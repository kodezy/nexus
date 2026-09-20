---
name: project-context
description: >-
  Capture learnings in docs/<topic>.md, reconcile docs/ with the AGENTS.md ## Docs
  index, and merge docs when asked. Use when the user asks to document, bootstrap, save a
  learning, or refresh docs/. On demand only — never auto-save during routine
  implementation.
---

# Project Context

Grow repo `docs/` in the **app repo**, indexed from `AGENTS.md` → `## Docs`.

Create `docs/<topic>.md` when there is content (kebab-case filename). Add a row per file. Docs may link to each other.

## When to use

Only when the user explicitly asks to capture, bootstrap, refresh, merge, or prune docs.

## Workflow

Follow `docs/curator.md` (reconcile index with existing `docs/` first). App index template: `template/AGENTS.md` in the Nexus plugin checkout.

## After changes

Do not commit unless asked. When docs changed, offer `$integrity-review` before claiming done — run it when the user wants validation.

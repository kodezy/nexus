---
name: project-context
description: >-
  Bootstrap or refresh project docs/, capture learnings in docs/notes/, promote
  notes when asked. Use when the user asks to document, bootstrap, save a
  learning, or refresh docs/. On demand only.
---

# Project Context

Curate durable knowledge in the app repo under `docs/`, linked from `AGENTS.md` → `## Docs`.

Document boundaries, domain language, conventions, git policy, and learnings **not** in tooling or CI.

## When to use

Only when the user explicitly asks to bootstrap, refresh, capture, promote, or prune docs.

## Workflow

Follow `docs/curator.md`. Shapes: `examples/docs/` in the Nexus harness checkout.

## After changes

Do not commit unless asked. Doc changes go through `$integrity-review` like any other project docs.

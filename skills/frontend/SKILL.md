---
name: frontend
description: Build frontends with React/Next.js or Dash. Use when creating or modifying apps, dashboards, components, pages, layouts, or callbacks.
---

# Frontend

Clear, pragmatic frontends. Smallest viable solution. Align with `architect` and `code-style` (project style doc by stack).

**Naming rule (always):** Prefer **simple, clear, pragmatic names** whenever possible. Avoid clever abbreviations, overly generic names, and long compound names. If two names are valid, pick the simpler one.

**UI rule (always):** Keep UI **clean and readable**. Prefer fewer components, fewer visual styles, and fewer layout primitives. Avoid decorative complexity unless the user explicitly asks for it.

**When:** React/Next.js app or Dash dashboard — pages, tabs, layouts, components, callbacks, styling.

**Language:** All code, identifiers, comments, and docstrings in English (per project AGENTS.md). UI copy in another language only when explicitly requested.

---

## Stack selection

Pick one from context. Read that stack’s doc, apply its patterns, then run `code-style` with the project style doc for that stack.

| Stack | Signals | Doc | Style (code-style) |
|-------|---------|-----|--------------------|
| **React** | `tsx`/`jsx`/`ts`, `app/`, `pages/`, `components/`, Next/React/Tailwind in deps | [docs/react.md](docs/react.md) | project React style doc |
| **Dash** | `from dash import`, `dash/`, `tabs/`, `dash` in deps | [docs/dash.md](docs/dash.md) | project Python style doc |

**Unclear:** Prefer stack that matches files/paths. New project: React for web app, Dash for internal dashboard. One stack per task.

---

## Execution order

1. **Choose stack** from signals above.
2. **Read** `docs/react.md` or `docs/dash.md` (this skill folder).
3. **Structure:** `architect` for layout and naming.
4. **Implement** using that doc.
5. **Style:** `code-style` with project doc (React or Python).

---

## Checklist (use only for chosen stack)

**React:** Structure/naming per docs/react.md **and follow the Naming/UI rules above**. Components focused, props typed, state local/lifted. Tailwind + CSS variables. `code-style` applied.

**Dash:** App factory, layout, callbacks per docs/dash.md **and follow the Naming/UI rules above**. Constants for theme; shared tables/charts. Callbacks per tab; consistent ids. `code-style` applied.

---

## Docs (this skill)

- **docs/react.md** — React/Next.js: structure, components, data, state, styling, hooks.
- **docs/dash.md** — Dash: app, layout, tabs, theme, components, callbacks.

Style: run `code-style` with project’s React or Python style doc after implementing.

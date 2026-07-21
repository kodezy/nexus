---
name: frontend
description: Build frontends with React (Vite SPA or Next.js). Use when creating or modifying apps, components, pages, layouts, state, and data flows.
---

# Frontend

Clear, pragmatic React frontends. Use the smallest viable solution. Align with `architect` for placement and `code-style` for how code reads.

**UI rule (always):** Keep UI **clean and readable**. Prefer fewer components, fewer visual styles, and fewer layout primitives. Avoid decorative complexity unless the user explicitly asks for it.

**Copy rule (always):** Prefer title, label, and value. Add description or helper text only when it adds actionable context the title does not already say. Do not restate the title.

**When:** React app work — Vite SPA, React Router, or Next.js — pages, layouts, components, hooks, data fetching, state, and styling.

**Language:** All code, identifiers, comments, and docstrings in English (per project AGENTS.md). UI copy in another language only when explicitly requested.

---

## Responsibility split

Use these skills together on frontend work, each for a different job:

- **`frontend` owns:** UI structure, component boundaries, state placement, data fetching shape, layout patterns, styling direction, and UI copy density.
- **`architect` owns:** file/module placement and file/folder names (match the project; React components may use `PascalCase` files when that is the local pattern).
- **`code-style` owns:** identifier naming, imports, module/component body order, comments/doc policy, spacing, and final formatting polish.
- Practical rule: `frontend` decides **how the UI should be built**; `architect` decides **where files live and how they are named**; `code-style` decides **how the code should read**.

---

## Stack selection

This skill is React-first. If the repository is not React, do not use this skill.

Detect the **existing runtime** and keep it. Do not introduce Next.js into a Vite app, or Vite into a Next.js app, unless the user explicitly asks.

Detect in this order (first match wins for bundler/framework; router is additive):

| Priority | Signals | Runtime |
| --- | --- | --- |
| 1 | `next` dependency, `next.config.*`, or Next App Router conventions with Next package | Next.js |
| 2 | `vite.config.*`, `@vitejs/plugin-react`, SPA `index.html` + `createRoot` | Vite SPA |
| — | `react-router` / `react-router-dom` (often together with Vite) | Client router on top of the SPA (declarative or data mode) |

Do **not** treat a folder named `app/` alone as Next.js — Vite apps often use `src/app/` for shell/providers.

Also look for: `tsx` / `jsx`, React components or hooks, Tailwind.

---

## Execution order

1. **Confirm React context** and runtime (Vite, React Router mode, or Next.js) from repository signals.
2. **Read** [docs/react.md](docs/react.md) — use the section that matches the runtime.
3. **Structure:** use `architect` for file/module placement and file names.
4. **Implement** with React patterns for that runtime.
5. **Style finalization:** run `code-style` using [typescript.md](../code-style/docs/typescript.md).

---

## Checklist

- Runtime preserved (no stack swap without an explicit ask).
- Feature layout and UI boundaries follow `docs/react.md` for that runtime.
- File placement and names follow `architect` (and local project conventions).
- Components stay focused on one UI responsibility.
- State stays local first, then is lifted only when sharing is required.
- Data fetching and effects are clear and predictable for the runtime.
- UI copy stays minimal (no redundant descriptions).
- Styling stays clean and consistent (Tailwind + CSS variables when applicable).
- Finish with `code-style` (`typescript.md`).

---

## Docs (this skill)

- **docs/react.md** — React: Vite SPA, React Router, Next.js; feature layout; data; state; forms; styling; hooks; modern APIs.

**code-style (final pass):** React — [typescript.md](../code-style/docs/typescript.md).

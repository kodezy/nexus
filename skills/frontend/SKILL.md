---
name: frontend
description: Build frontends with React/Next.js. Use when creating or modifying apps, components, pages, layouts, state, and data flows.
---

# Frontend

Clear, pragmatic React frontends. Use the smallest viable solution. Align with `architect` for placement and `code-style` for how code reads.

**UI rule (always):** Keep UI **clean and readable**. Prefer fewer components, fewer visual styles, and fewer layout primitives. Avoid decorative complexity unless the user explicitly asks for it.

**When:** React/Next.js app work — pages, layouts, components, hooks, data fetching, state, and styling.

**Language:** All code, identifiers, comments, and docstrings in English (per project AGENTS.md). UI copy in another language only when explicitly requested.

---

## Responsibility split

Use these skills together on frontend work, each for a different job:

- **`frontend` owns:** UI structure, component boundaries, state placement, data fetching shape, layout patterns, and styling direction.
- **`architect` owns:** file/module placement and file/folder names (match the project; React components may use `PascalCase` files when that is the local pattern).
- **`code-style` owns:** identifier naming, imports, module/component body order, comments/doc policy, spacing, and final formatting polish.
- Practical rule: `frontend` decides **how the UI should be built**; `architect` decides **where files live and how they are named**; `code-style` decides **how the code should read**.

---

## Stack selection

This skill is React-first. If the repository is not React/Next.js, do not use this skill.

Signals:
- `tsx` / `jsx`
- React components or hooks
- Next.js `app/` or `pages/`
- React/Next/Tailwind dependencies

---

## Execution order

1. **Confirm React/Next.js context** from repository signals.
2. **Read** [docs/react.md](docs/react.md).
3. **Structure:** use `architect` for file/module placement and file names.
4. **Implement** with React-specific patterns from this skill.
5. **Style finalization:** run `code-style` using [typescript.md](../code-style/docs/typescript.md).

---

## Checklist

- Feature layout and UI boundaries follow `docs/react.md`.
- File placement and names follow `architect` (and local project conventions).
- Components stay focused on one UI responsibility.
- State stays local first, then is lifted only when sharing is required.
- Data fetching and effects are clear and predictable.
- Styling stays clean and consistent (Tailwind + CSS variables when applicable).
- Finish with `code-style` (`typescript.md`).

---

## Docs (this skill)

- **docs/react.md** — React/Next.js: feature layout, data, state, forms, styling, hooks boundaries.

**code-style (final pass):** React — [typescript.md](../code-style/docs/typescript.md).

---
name: frontend
description: Build frontends with React/Next.js. Use when creating or modifying apps, components, pages, layouts, state, and data flows.
---

# Frontend

Clear, pragmatic React frontends. Use the smallest viable solution. Align with `architect` for structure and `code-style` for final style.

**Naming rule (always):** Prefer **simple, clear, pragmatic names** whenever possible. Avoid clever abbreviations, overly generic names, and long compound names. If two names are valid, pick the simpler one.

**UI rule (always):** Keep UI **clean and readable**. Prefer fewer components, fewer visual styles, and fewer layout primitives. Avoid decorative complexity unless the user explicitly asks for it.

**When:** React/Next.js app work — pages, layouts, components, hooks, data fetching, state, and styling.

**Language:** All code, identifiers, comments, and docstrings in English (per project AGENTS.md). UI copy in another language only when explicitly requested.

---

## Responsibility split

Use this skill and `code-style` together on frontend work, but for different jobs:

- **`frontend` owns:** UI structure, component boundaries, state placement, data fetching shape, layout patterns, and styling direction.
- **`code-style` owns:** naming, imports, module/file order, comments/doc policy, spacing, and final formatting polish.
- Practical rule: `frontend` decides **how the UI should be built**; `code-style` decides **how the code should read**.

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
3. **Structure:** use `architect` for file/module placement and naming boundaries.
4. **Implement** with React-specific patterns from this skill.
5. **Style finalization:** run `code-style` using [typescript.md](../code-style/docs/typescript.md).

---

## Checklist

- Structure and naming follow `docs/react.md` and the Naming/UI rules above.
- Components stay focused, with explicit props typing.
- State stays local first, then is lifted only when sharing is required.
- Data fetching and effects are clear and predictable.
- Styling stays clean and consistent (Tailwind + CSS variables when applicable).
- Finish with `code-style` (`typescript.md`).

---

## Docs (this skill)

- **docs/react.md** — React/Next.js: structure, components, data, state, styling, hooks.

**code-style (final pass):** React — [typescript.md](../code-style/docs/typescript.md).

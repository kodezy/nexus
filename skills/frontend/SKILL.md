---
name: frontend
description: Build user interfaces. Use when creating or modifying pages, screens, components, layouts, state, and data flows in any UI stack.
---

# Frontend

Clear, pragmatic UIs. Use the smallest viable solution. Align with `architect` for placement and `code-style` for how code reads.

**UI rule (always):** Keep UI **clean and readable**. Prefer fewer components, fewer visual styles, and fewer layout primitives. Avoid decorative complexity unless the user explicitly asks for it.

**Copy rule (always):** Prefer title, label, and value. Add description or helper text only when it adds actionable context the title does not already say. Do not restate the title.

**When:** User-facing UI — pages, screens, layouts, components, state, data fetching, and styling — in whatever stack the repository already uses.

**Language:** All code, identifiers, comments, and docstrings in English (per Nexus contract). UI copy in another language only when explicitly requested.

---

## Responsibility split

Use these skills together on frontend work, each for a different job:

- **`frontend` owns:** UI structure, component boundaries, state placement, data fetching shape, layout patterns, styling direction, UI copy density, and pre-closeout **Quality review**.
- **`architect` owns:** file/module placement and file/folder names (match the project).
- **`code-style` owns:** identifier naming, imports, module/component body order, comments/doc policy, spacing, and final formatting polish.
- Practical rule: `frontend` decides **how the UI should be built**; `architect` decides **where files live and how they are named**; `code-style` decides **how the code should read**.

---

## Stack selection

Detect the **existing** UI stack from the repository and keep it. Do not introduce a framework, bundler, router, or styling system unless the user explicitly asks.

Detect from manifests and configs first (`package.json`, lockfiles, `*.config.*`, adjacent modules). Examples of signals — first clear match wins; this list is not exclusive:

| Signals | Typical stack |
| --- | --- |
| `vue`, `nuxt`, `vite.config.*` + Vue plugins | Vue |
| `svelte`, `@sveltejs/kit` | Svelte |
| `@angular/core`, `angular.json` | Angular |
| `next`, `next.config.*` | Next.js |
| `react` + `vite.config.*` + SPA `index.html` | React SPA |
| `react-router` / `react-router-dom` | Client router on an existing SPA |
| Templates + CSS in a server app (Django, Rails, Laravel, …) | Keep that template/CSS approach |

If the repository is not a UI, do not use this skill.

Do **not** treat a folder named `app/` alone as a specific framework.

When the user asks for a **new** UI and does not name a stack, **ask** before choosing one. Do not default to a Nexus-preferred framework or CSS library.

Optional stack docs under `docs/` apply **only** when that stack is already in the repo or the user chose it. There is no required frontend stack.

---

## Quality review (before integrity-review)

Review the completed UI. Fix supported issues; report uncertainties instead of guessing.

1. Confirm every visible element supports the primary task. Remove duplicate descriptions and decorative noise.
2. Check narrow and wide viewports — readable layout, reachable controls, no horizontal overflow.
3. Check semantic elements, explicit labels, visible focus, keyboard operation, contrast, and accessible names for icon-only controls.
4. Check loading, empty, error, disabled, and success states the feature can reach. Keep messages short and actionable.
5. Check styling consistency with the project's existing tokens, CSS, or utility system; no inline layout styles unless values are dynamic.

Use existing project primitives first. Do not add a component or styling library for polish alone.

Validation: use host browser tools or project UI tests when the flow can be exercised. When browser tests exist (or the user authorizes adding them), supplement with an accessibility checker the project already uses. Do not create test files solely for this review when the project contract forbids new automated tests.

---

## Execution order

1. **Confirm UI context** and runtime from repository signals (or the stack the user named).
2. **Read** the matching optional doc under `docs/` only if one exists for that stack (for example [docs/react.md](docs/react.md) when the repo is React). Otherwise follow adjacent modules and project instructions.
3. **Structure:** use `architect` for file/module placement and file names.
4. **Implement** with patterns already in the repo (or the stack the user chose).
5. **Style finalization:** run `code-style` on touched files (language doc only when it matches those files).
6. **Quality review:** run **Quality review** above before `integrity-review`.

---

## Checklist

- Runtime preserved (no stack swap without an explicit ask).
- Feature layout and UI boundaries follow the repo (or the optional stack doc when it applies).
- File placement and names follow `architect` (and local project conventions).
- Components stay focused on one UI responsibility.
- State stays local first, then is lifted only when sharing is required.
- Data fetching and effects are clear and predictable for the runtime.
- UI copy stays minimal (no redundant descriptions).
- Styling matches the project's existing system; do not introduce a new one without an explicit ask.
- Finish with `code-style` on touched files.
- **Quality review** completed (section above) before `integrity-review`.

---

## Docs (this skill)

Optional stack playbooks — load only when that stack is in use:

- **docs/react.md** — React (Vite SPA, React Router, Next.js) when the repository is already React or the user chose it.

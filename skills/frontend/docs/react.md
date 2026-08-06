# React

Use this doc when the `frontend` skill is active. Build with TypeScript and clear separation of concerns. Keep solutions small, pragmatic, and easy to evolve.

This doc owns React-specific implementation decisions: runtime detection (and greenfield preference), feature layout, component boundaries, state strategy, data flow, UI copy density, and styling direction.

**Not owned here (do not duplicate):**

- File/folder names and module placement → `architect`
- Identifier naming, imports, module/component body order, formatting → `code-style` ([typescript.md](../../code-style/docs/typescript.md))

## Runtime

Match the repository. Do not change runtime unless the user asks.

| Runtime | When | Default data approach |
| --- | --- | --- |
| **Vite SPA** | `vite.config.*`, SPA `index.html`, client `createRoot` (may include `src/app/` shell — that is not Next) | Fetch on the client; keep requests in `services/` / `api/` |
| **React Router** | Used with a SPA (usually Vite); not a separate bundler | Declarative: effects + shared client. Data mode: loaders/actions when they remove scattered effects |
| **Next.js** | `next` package / `next.config.*` already in use | Server Components first; client only when interactivity requires it |

### New projects

When the user asks for a **new** React app and does not specify a stack:

- Prefer **Vite + React + TypeScript** for dashboards, internal tools, and SPA UIs.
- Prefer **Next.js App Router** only when SSR, SEO, or server-first routing is a stated need.
- Prefer current stable React (19.x line when available) and current stable Vite for greenfield work.
- Use Tailwind for styling unless the user explicitly requests another system.
- Keep dependency upgrades in their own change; do not mix large upgrades with feature work.

### Do not force

- Do not add SSR, React Query, Remix/RR framework mode, or a new state library unless the problem needs them.
- Do not introduce Next.js into a Vite repo (or the reverse) without an explicit ask.

## Project setup

- Use TypeScript.
- Match the repository package manager (`npm`, `pnpm`, or `yarn`).
- Keep one stack per task.

## Project structure (`src/`)

Use a feature-oriented structure as the project grows. For small scopes, keep it flatter and match the existing repository shape. Prefer local conventions when the repository already differs.

```
src/
├── app/                    # shell, providers, bootstrap, router entry
├── features/               # feature modules (UI + hooks + local logic)
├── components/ or shared/ui/  # reusable UI (match local name)
├── hooks/ or shared/hooks/    # shared custom hooks
├── services/ or shared/api/   # API and integration layer
├── types/ or shared/model/    # shared types when not local to a feature
└── styles/ or shared/styles/  # global styles or theme tokens
```

Vite apps often use `shared/` instead of top-level `components/` / `hooks/`. Next.js apps often use `app/` for routes. Follow the repo.

### Separation of concerns

| Concern | Location |
|--------|----------|
| App shell / providers / bootstrap | `app/` |
| Route / feature UI | `features/<feature>/` (or Next `app/` routes) |
| Shared UI | `components/` or `shared/ui/` |
| Reusable logic | `hooks/` or `shared/hooks/` |
| Data / API | `services/` or `shared/api/` |
| Shared types | `types/`, `shared/model/`, or colocated when local |

### Placement rules

- Keep feature-specific code inside `features/<feature>/`.
- Move code to shared folders only after real reuse appears.
- Prefer colocated types and helpers while scope is local.
- Avoid `utils/`, `helpers/`, `common/`, `misc`. Keep logic with the owning feature or use a named shared module (`format`, `dates`, `validation`) per `architect`.
- Prefer flat paths until a feature has several pieces, then nest under `features/<name>/`.
- Prefer one concept per module; split when one file mixes independent responsibilities or becomes hard to scan (large route files with several tabs/panels are a split signal).
- File names follow `architect`.

## Components

- Keep components focused on one UI responsibility.
- Prefer composition over deeply configurable components.
- Keep presentational and data logic separate when the file becomes hard to scan.
- Props typing, early returns, hooks rules, and body order: follow [typescript.md](../../code-style/docs/typescript.md).

```tsx
type OrderCardProps = { order: Order; onCancel?: (id: string) => void };

export function OrderCard({ order, onCancel }: OrderCardProps) {
  if (!order) return null;
  return <div className="card">{/* ... */}</div>;
}
```

## UI copy

- Default: title / label / value only.
- Optional description or helper text only when it adds **actionable** context the title does not already convey.
- Bad: title `Accounts` + description `Accounts and characters`.
- Good: title `Accounts` alone, or a description that states a non-obvious constraint or state.
- Prefer short empty/error strings over paragraphs.

## UI quality

- Design for the primary task first. Remove cards, icons, helper text, and controls that do not help the user complete it.
- Start with the narrow viewport, then confirm the layout at a wider viewport. Do not hide the primary action or require horizontal scrolling.
- Use semantic HTML before ARIA. Inputs need labels, icon-only controls need accessible names, and interactive controls need visible keyboard focus.
- Use buttons for actions and links for navigation. Do not recreate native behavior with non-interactive elements.
- Implement loading, empty, error, disabled, and success states when the feature can reach them.

## Data fetching

### Vite SPA / client router (declarative)

- Centralize HTTP in `services/` or `shared/api/`.
- Model loading, success, and error states explicitly.
- Prevent duplicated requests from scattered effects.
- Cancel or ignore stale async results when filters/params change quickly (e.g. request generation / `useLatestRequest` patterns).
- Prefer React Router **data mode** (loaders/actions) when it clearly removes manual effect orchestration; do not migrate a whole app opportunistically.

### Next.js (server-first)

- Fetch on server components (`page.tsx`, `layout.tsx`) when possible.
- Pass only required data to client components as props.
- Keep route handlers thin; move reusable integration logic to `services/`.
- Fetch on the client only when interactivity requires it.
- Be explicit about `"use client"` boundaries; push client leaves down the tree.

## State

- Keep state local by default.
- Lift state when two or more siblings need the same source of truth.
- Use Context only for broadly shared state (session, theme, currency, feature-wide settings).
- Use external state libraries only when local/context patterns become hard to maintain.

### Forms

- Prefer controlled inputs for simple forms.
- Use `react-hook-form` when validation rules or nested fields become complex.
- Keep validation rules close to the form domain.

## Styling

- Prefer Tailwind utility classes for layout and spacing.
- Keep design tokens in CSS variables (`app/globals.css`, `styles/`, or `shared/styles/`).
- Avoid inline layout styles unless values are truly dynamic.
- Keep visual primitives consistent: spacing scale, radius, typography, colors.
- Dark mode: use `prefers-color-scheme` or an explicit theme toggle with variables.
- Match the project's Tailwind major (v3 config vs v4 CSS-first); do not upgrade Tailwind inside unrelated feature work.
- Use existing primitives first. Add shadcn/ui or Radix only when an accessible primitive is needed and the dependency fits the project.

## Hooks and modern React

- Create custom hooks for reusable stateful behavior.
- Give each hook one responsibility.
- Hook call rules, naming, and `useMemo` / `useCallback` policy: follow [typescript.md](../../code-style/docs/typescript.md).
- Use effects for **synchronizing with external systems**, not as a default place for derived state.
- Prefer derived values during render over effect + setState mirrors.
- Use `useEffectEvent`, `startTransition`, and related modern APIs when they simplify a real problem (stable event logic, non-urgent updates). Do not add them by habit.
- Avoid `useMemo` / `useCallback` unless identity stability or measured cost requires them (React Compiler projects: follow repo guidance).

## Evolvability

- Start minimal and colocate by default.
- Extract shared abstractions when a pattern appears in 2-3 places.
- Keep public component APIs small and stable.
- Prefer incremental refactors over broad rewrites.
- Match existing project conventions before introducing new patterns.
- Stack upgrades (React, Vite, router, Tailwind) stay in dedicated changes with verification.

---

After implementing, run **code-style** using [typescript.md](../../code-style/docs/typescript.md).

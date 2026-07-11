# React/Next.js

Use this doc when the `frontend` skill is active for React/Next.js work. Build with Next.js App Router and TypeScript, with clear separation of concerns. Keep solutions small, pragmatic, and easy to evolve.

This doc owns React-specific implementation decisions: feature layout, component boundaries, state strategy, data flow, and styling direction.

**Not owned here (do not duplicate):**

- File/folder names and module placement → `architect`
- Identifier naming, imports, module/component body order, formatting → `code-style` ([typescript.md](../../code-style/docs/typescript.md))

## Project Setup

- Use Next.js App Router and TypeScript.
- Match the repository package manager (`npm`, `pnpm`, or `yarn`).
- Keep one stack per task. Do not mix React architecture with unrelated UI stacks.

## Project structure (`src/`)

Use a feature-oriented structure as the project grows. For small scopes, keep it flatter and match the existing repository shape. Prefer local conventions when the repository already differs.

```
src/
├── app/                    # App Router entries: layout.tsx, page.tsx, route groups
├── features/               # feature modules (UI + hooks + services for one domain)
├── components/             # reusable UI components
├── hooks/                  # shared custom hooks
├── services/               # API and integration layer
├── utils/                  # pure helpers
├── types/                  # shared types when not local to a feature
└── styles/                 # global styles or theme tokens
```

### Separation of concerns

| Concern | Location |
|--------|----------|
| Route UI | `app/` |
| Feature UI | `features/<feature>/` |
| Shared UI | `components/` |
| Reusable logic | `hooks/` |
| Data / API | `services/` |
| Utilities | `utils/` |
| Shared types | `types/` (or colocated when local) |

### Placement rules

- Keep feature-specific code inside `features/<feature>/`.
- Move code to shared folders only after real reuse appears.
- Prefer colocated types/helpers while scope is local.
- Prefer flat paths until a feature has several pieces, then nest under `features/<name>/`.
- One primary component or one hook per file when practical.
- Split files only when it improves readability or reuse; file names follow `architect`.

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

## Data Fetching

### Server-first strategy

- Fetch on server components (`page.tsx`, `layout.tsx`) when possible.
- Pass only required data to client components as props.
- Keep API handlers thin and move reusable integration logic to `services/`.

### Client-side fetching

- Fetch on client only when interactivity requires it.
- Model loading, success, and error states explicitly.
- Prevent duplicated requests from scattered effects.
- Cancel or ignore stale async results when state can change quickly.

## State

- Keep state local by default.
- Lift state when two or more siblings need the same source of truth.
- Use Context only for broadly shared state (session, theme, feature-wide settings).
- Use external state libraries only when local/context patterns become hard to maintain.

### Forms

- Prefer controlled inputs for simple forms.
- Use `react-hook-form` when validation rules or nested fields become complex.
- Keep validation rules close to the form domain.

## Styling

- Prefer Tailwind utility classes for layout and spacing.
- Keep design tokens in CSS variables (`app/globals.css` or `styles/`).
- Avoid inline layout styles unless values are truly dynamic.
- Keep visual primitives consistent: spacing scale, radius, typography, colors.
- Dark mode: use `prefers-color-scheme` or an explicit theme toggle with variables.

## Hooks

- Create custom hooks for reusable stateful behavior.
- Give each hook one responsibility.
- Hook call rules, naming, and `useMemo` / `useCallback` policy: follow [typescript.md](../../code-style/docs/typescript.md).

## Evolvability

- Start minimal and colocate by default.
- Extract shared abstractions when a pattern appears in 2-3 places.
- Keep public component APIs small and stable.
- Prefer incremental refactors over broad rewrites.
- Match existing project conventions before introducing new patterns.

---

After implementing, run **code-style** using [typescript.md](../../code-style/docs/typescript.md).

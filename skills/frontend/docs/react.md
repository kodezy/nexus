# React/Next.js

Use when frontend skill selects stack = React. Next.js App Router, TypeScript, flat structure. Goal: clean, pragmatic, easy to evolve and maintain. Align with **architect** (structure, naming, one purpose per module) and **code-style** (formatting, naming, final pass).

## Project Setup

- Next.js (App Router). TypeScript; no `any`.
- Package manager: match project (npm, pnpm, yarn).

## Structure

Flat, one purpose per folder. Match existing project if it differs.

```
src/
├── app/                    # layout.tsx, page.tsx, (routes)/
├── components/
│   ├── ui/                 # Primitives (Button, Input, Card)
│   └── features/           # OrderCard, SessionTable
├── lib/                    # api, utils, constants
└── types/                  # optional; prefer colocation
```

## Naming

- Components and types: PascalCase (`OrderCard`, `Order`).
- Hooks: `use*` (`useOrders`, `useSession`).
- Files and folders: kebab-case.
- One component per file; one hook per file.
- Prefer flat: `components/features/OrderCard.tsx` until a feature has 3+ components, then `components/features/orders/`.

## Components

- Small and focused. Explicit props (no `any`). Types in same file when trivial.
- Early returns to reduce nesting.

```tsx
type OrderCardProps = { order: Order; onCancel?: (id: string) => void };

export function OrderCard({ order, onCancel }: OrderCardProps) {
  if (!order) return null;
  return <div className="card">{/* ... */}</div>;
}
```

## Data Fetching

- Server: fetch in page/layout; pass as props.
- Client: `use` or `useEffect` + `useState` when needed.
- API: `app/api/`; keep handlers thin.

## State

- Local first. Lift when shared.
- Context/Zustand only when necessary.
- Forms: controlled inputs; `react-hook-form` only for complex forms.

## Styling

- Tailwind. CSS variables in `globals.css` for theme.
- No inline layout styles. Dark: `prefers-color-scheme` or toggle + variables.

## Hooks

- Top level only. `useMemo`/`useCallback` only when needed.
- Custom hooks: one responsibility, clear names (`useOrders`, `useSession`).

## Evolvability

- Start minimal. Colocate; split when reuse appears.
- Abstract when you have 2–3 cases. Match project naming.

---

After implementing, run **code-style** with the project React/TypeScript style doc.

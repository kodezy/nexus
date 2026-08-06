# Clean Code Guide (TypeScript)

## Objective

Clarity, simplicity, and pragmatism above all. Code that is easy to understand, maintain, and evolve.

## Scope

Use for `.ts`, `.tsx`, and `.jsx` files, including React components and hooks.

## Naming

Highest priority: simple, clear, pragmatic names.

- **Types and interfaces:** `PascalCase` (`User`, `OrderRow`).
- **Functions, methods, variables:** `camelCase` (`loadUser`, `isVisible`).
- **Module-level constants** (immutable config, shared literals): `UPPER_SNAKE_CASE` (`MAX_RETRIES`, `API_BASE_URL`).
- Avoid unnecessary abbreviations: prefer `calculateTotal` over `calcTot`, `user` over `usr`.
- Use names that describe purpose, not implementation.
- **Booleans:** intent-revealing prefixes (`is`, `has`, `can`, `should`) in camelCase (`isReady`, `hasAccess`, `canSubmit`).
- Prefer `type` for object shapes and unions unless you need interface merging.
- Name functions and methods with verbs (`loadUser`, `formatDate`); name types with nouns (`User`, `ApiError`).
- Keep prefix and convention consistency across the module.

## Structure and Organization

- Prefer explicit types on public APIs and non-obvious values; avoid implicit `any`.
- Use ES modules (`import` / `export`); avoid `namespace`, `require()`, and other legacy module patterns in new code unless the file already uses them.
- Use early returns and guard clauses to keep control flow shallow.
- One primary responsibility per file; prefer one **concept** per module, not one file per type or helper.
- Package and folder layout (features, services, shared modules): `architect` — avoid `utils` / `helpers` / `common` / `misc` catch-alls.

### Order inside a `.ts`, `.tsx`, or `.jsx` file

Top to bottom:

1. **`import`** — third-party packages first, then path aliases, then relative imports (`./`, `../`). Blank line between those three groups. Include `import type` here.
2. **`type` / `interface`** — shared shapes for this module.
3. **Module-level constants** — `UPPER_SNAKE_CASE` and other file-level immutable values (see **Constants** below).
4. **`class` declarations** — before any module-level functions.
5. **Module-level functions/components** — exported functions/components first, then non-exported helpers last. **If there is a default export, it is last among the publics** (still before private helpers).

**Exports:** use `export` on each named declaration as you go. **If the file has a default export, place it last among exported declarations**, then keep non-exported helpers after all exports.

**How this compares to other languages:** **`type` / `interface` before constants**—types are **first-class** in TypeScript (unlike Python, where hints are optional and usually inline). **Constants** are **after** types, not immediately after imports (unlike Python and Rust). **`class` methods** live **inside** the class body, like Python. **Module-level functions** come **after** classes. There is **no** `main`: execution is **explicit** (bundler entry, CLI, `node` script, or tests).

### React component order (`.tsx` and React `.jsx`)

Use this body order inside function components:

1. **Props** — destructure in the function parameter list.
2. **State hooks** — `useState` and equivalent state hooks.
3. **Other hooks** — `useEffect`, `useMemo`, `useCallback`, custom hooks, and context reads.
4. **Derived values** — values computed from props, state, or hooks.
5. **Handlers** — event handlers and callbacks (`handle...`).
6. **`return`** — JSX last.

React-specific style rules:

- Use function components only.
- Keep hooks at top level; never call hooks conditionally.
- Keep components focused; extract only for clear reuse or clarity gains.
- Prefer explicit props typing in `.tsx`.
- Keep JSX readable and use early returns to reduce nesting.
- Use `useMemo` and `useCallback` only when there is measurable benefit (identity stability or measured cost). Prefer derived values over effect + setState mirrors.
- UI copy density and runtime/data patterns belong to `frontend`; do not invent redundant descriptions while styling.

### Constants

- Declare **one constant per line**; do not chain unrelated `const` declarations on one line.
- **Group related constants by domain** with one blank line between groups (e.g. HTTP limits, cache TTLs, feature flags).
- Prefer readability and clean Git diffs over minimizing line count.
- **Naming:** scalar module-level literals use `UPPER_SNAKE_CASE`; structured `as const` config objects use idiomatic `camelCase`.
- When several constants describe a single concept, prefer a typed config over more globals:
  - `as const` object + `type` alias for a fixed key set
  - `enum` for a closed set of named variants
  - dedicated module when the surface is large or reused across files
- A `type` alias derived via `typeof` from an `as const` object may sit **immediately below** that object in the constants block (exception to the usual types-before-constants order).

Scalar constants:

```typescript
const MAX_RETRIES = 3;
const REQUEST_TIMEOUT_MS = 5_000;

const CACHE_TTL_MS = 60_000;
```

Structured config (same constants block; derived type may follow the object):

```typescript
const retryPolicy = {
  maxRetries: 3,
  timeoutMs: 5_000,
  backoffMs: 250,
} as const;

type RetryPolicy = typeof retryPolicy;
```

### Documentation and comments

**Default: no new comments or JSDoc.** Add `//`, `/* */`, or `/** */` only when necessary: public API that must be spelled out, non-obvious invariant, or compliance with a required doc standard. Prefer clear names, types, and structure instead.

### Formatting

- Keep one blank line between coarse phases where it aids scanning; do not blank-line inside a single phase or inside argument lists.
- Do not change behavior while styling (return values, side effects, exports).

### Calls, imports, and failure scope

- Prefer top-level `import`. Local imports only for lazy loading or to break a real circular dependency.
- When a signature or call has many clear parameter groups, prefer a typed options object or a small helper over a long flat argument list — not for short, clear signatures.
- Keep `try`/`catch`/`finally` scopes small: wrap only the call that can fail and its direct handlers.

## Visual Block Separation

Core rule: one blank line separates **coarse** phases inside a function; never two blank lines. Typical phases when present: validation, preparation, main effect, cleanup, return (order follows the function’s flow). Do not micro-split related statements; do not use comments to label or separate blocks. Prefer readable phase layout over minimizing line count. Avoid multiple conditions on the same line when it hurts readability; prefer guard clauses and named intermediate booleans.

### Between Functions and Classes

```typescript
function calculateTotal(items: Item[]): number {
  return items.reduce((sum, item) => sum + item.price, 0);
}

function validateOrder(order: Order): boolean {
  return order.amount > 0;
}
```

### Between Logical Blocks Inside Functions

```typescript
function processOrder(order: Order): Transaction | null {
  if (!order.isValid()) {
    return null;
  }

  const total = calculateTotal(order.items);

  if (total > order.balance) {
    throw new InsufficientFundsError();
  }

  return createTransaction(order, total);
}
```

### Before Control Structures

```typescript
function executeTrade(signal: Signal): TradeResult | null {
  if (!signal.isValid()) {
    return null;
  }

  const price = getCurrentPrice(signal.symbol);

  try {
    return placeOrder(signal, price);
  } catch (error) {
    logError(error);
    return null;
  }
}
```

### After Main Variables

```typescript
function analyzeMarket(symbol: string): MarketAnalysis {
  const currentPrice = getPrice(symbol);
  const historicalData = fetchHistory(symbol, 30);

  const trend = calculateTrend(historicalData);

  return { price: currentPrice, trend };
}
```

### Grouping Related Methods

```typescript
class OrderManager {
  constructor(private readonly client: Client) {}

  createOrder(orderData: OrderData): OrderId {
    // ...
  }

  cancelOrder(orderId: OrderId): void {
    // ...
  }

  getOrderStatus(orderId: OrderId): OrderStatus | undefined {
    // ...
  }

  private validateOrderData(data: OrderData): void {
    // ...
  }

  private calculateFees(amount: number): number {
    // ...
  }
}
```

Inside classes, order is strict: **constructor first** (when present), then **other public methods**, then **private** helpers last — consistent with `docs/python.md` / `docs/rust.md`. Never interleave private above remaining public for grouping.

```typescript
export function createOrder(orderData: OrderData): OrderId {
  return buildOrder(orderData);
}

export default function OrderPage(): JSX.Element {
  return <main />;
}

function buildOrder(orderData: OrderData): OrderId {
  // private helper
  return orderData.id;
}
```

## Safety

- Preserve type contracts consumed by other modules.
- Prefer narrowing (`if (x === null) return`) and discriminated unions over unchecked assertions.

## Summary

Be pragmatic: simple and clear names, stable module order, and code that another developer understands at first glance.

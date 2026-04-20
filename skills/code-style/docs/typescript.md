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
- Use early returns and guard clauses to keep control flow shallow.
- One primary responsibility per file.

### Order inside a `.ts`, `.tsx`, or `.jsx` file

Top to bottom:

1. **`import`** — third-party packages first, then path aliases, then relative imports (`./`, `../`). Blank line between those three groups. Include `import type` here.
2. **`type` / `interface`** — shared shapes for this module.
3. **Module-level constants** — `UPPER_SNAKE_CASE` and other file-level immutable values.
4. **`class` declarations** — before any module-level functions.
5. **Module-level functions/components** — non-exported helpers first, then exported functions/components. **Default export last.**

**Exports:** use `export` on each named declaration as you go. **If the file has a default export, it is the last top-level declaration.**

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
- Use `useMemo` and `useCallback` only when there is measurable benefit.

### Documentation and comments

**Default: no new comments or JSDoc.** Add `//`, `/* */`, or `/** */` only when necessary: public API that must be spelled out, non-obvious invariant, or compliance with a required doc standard. Prefer clear names, types, and structure instead.

### Formatting

- Keep one blank line between logical sections where it aids scanning.
- Do not change behavior while styling (return values, side effects, exports).

## Visual Block Separation

Core rule: one blank line separates logical blocks; never two blank lines. Use space to separate contexts (validation, calculation, return). Avoid multiple conditions on the same line when it hurts readability; prefer guard clauses and named intermediate booleans.

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

Prefer **public methods first**, then **private** helpers at the end of the class, consistent with `docs/python.md` / `docs/rust.md`.

## Safety

- Preserve type contracts consumed by other modules.
- Prefer narrowing (`if (x === null) return`) and discriminated unions over unchecked assertions.

## Summary

Be pragmatic: simple and clear names, stable module order, and code that another developer understands at first glance.

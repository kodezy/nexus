# Domain glossary (observed)

_Last reviewed: YYYY-MM-DD. On conflict, types and schemas in code win._

| Term | Meaning | Primary references |
| --- | --- | --- |
| Order | Customer purchase record | `src/models/order.ts`, `GET /api/orders` |
| Account | Billing identity (not the same as User) | `src/models/account.ts` |

## Avoid

- `Purchase` — use `Order` in code and UI copy
- `Customer` in API paths — use `User` (`/api/users`)

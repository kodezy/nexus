# Auth callbacks (captured)

_Optional shape. Captured: YYYY-MM-DD. Merge into a named doc when durable._

- OAuth redirect handler lives in `src/api/routes/auth/callback.ts` — do not add a second entry point.
- Session cookie name is `sid`; see `src/api/session.ts` for TTL.

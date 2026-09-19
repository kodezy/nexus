# Auth callbacks (captured)

_Captured: YYYY-MM-DD. Promote to architecture when the flow stabilizes._

- OAuth redirect handler lives in `src/api/routes/auth/callback.ts` — do not add a second entry point.
- Session cookie name is `sid`; see `src/api/session.ts` for TTL.

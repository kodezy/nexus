# Monorepo documentation

Use with the **Monorepo** variant in `$readme-writer`. Applies when the root README points at multiple packages (for example `manager/`, `dashboard/`).

## Split responsibilities

| Doc | Owns |
|-----|------|
| Root `README.md` | Install, Run, host ports, `## Packages`, `## Docs` index |
| `<service>/docs/` or `docs/API.md` | HTTP API reference (`$api-docs-writer`) |
| `<ui-package>/docs/README.md` | Pages, filters, UI workflows — not HTTP schemas |
| `OPERATIONS.md` (or equivalent) | End-to-end flows, curl examples |

Do not put UI page guides in API reference docs. Do not duplicate OpenAPI shapes in package READMEs.

## Root README rules

- `## Docs` links **every** package-level doc index in the repo.
- `## Packages` lists only directories that exist. Mark **external** components (not in the repo) explicitly.
- When `docker-compose.yml` (or similar) publishes ports, show **host → container** mapping once in Config or Run.
- Local dev: **separate** instructions per package. Never attribute one package's env vars to another.

## Package README rules

Before documenting config, read that package's `.env.example` (or equivalent). Document **only** variables defined there.

- Backend package: `DATABASE_URL`, `REDIS_URL`, service tokens.
- UI package: proxy target, UI bind host/port, shared `API_TOKEN` — not database URLs.

Verify commands (`npm run dev`, `poetry run`, etc.) against `package.json`, `pyproject.toml`, or the package Dockerfile.

## Terminology

Pick canonical names once in the root README or primary service docs. Reuse them in every touched doc:

| Avoid mixing | Pick one |
|--------------|----------|
| manager / Manager API / REST API | **Manager API** (HTTPS `/api`) — pick one service name for the repo |
| dashboard / Dashboard / web UI | **Dashboard** (or the UI package name) |
| worker / client binary | Name used in operations docs (e.g. **Golen worker**) |
| trading run / session | **trading session** (match API field names) |
| game actions / game-actions | **game-actions** (match API path) |

Package names in `## Packages` stay lowercase (`manager`, `dashboard`). Product-facing names stay capitalized (Manager API, Dashboard).

## UI names

When documenting a web UI, match labels in code:

- Sidebar / nav link text for page names
- `PageTabs` labels (or equivalent) for tab names
- Do not name a UI page after an API path segment (e.g. `/metrics/dashboard` → **Metrics** page, not "Dashboard endpoint")

## Cross-links

- API `## Docs` → operations guide and UI doc index when a UI package exists.
- UI doc `## Docs` → API index and root README.
- Operations monitoring tables: **page name** + endpoint, not endpoint alone.

## Checklist (monorepo doc change)

- [ ] Each package doc lists only its own env vars (verified against `.env.example`)
- [ ] Root `## Docs` links all package doc indexes
- [ ] External components marked; no phantom packages
- [ ] Host and container ports documented where Compose exists
- [ ] Local dev split per package
- [ ] Canonical terms consistent across touched files
- [ ] UI page and tab names match the app
- [ ] No duplicated API schemas or long flows in READMEs
- [ ] Every relative link resolves

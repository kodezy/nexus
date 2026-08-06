---
name: api-docs-writer
description: Write short, scannable HTTP API reference docs. Use when creating or updating docs/API.md, REST or WebSocket endpoint documentation, or an API section that links to a full reference.
---

# API Docs Writer

## Objective

Write API reference docs that are short, direct, and easy to scan. One job per section. Omit empty sections.

Answer **how to call** the API. OpenAPI (or generated schema) owns exact types. Business flows belong in a separate doc, linked from `## Docs`.

## Choose A Variant

Detect API size, then use that skeleton. When editing an existing `docs/API.md`, keep its working structure unless the user asks to restructure.

### Compact (default, roughly ≤15 endpoints)

Single file: `docs/API.md`.

```md
# Service — API

One factual sentence.

## Overview
## Auth
## Conventions
## Endpoints
## Docs
```

### Large

Same top sections in `docs/API.md`, plus:

- `## Endpoints` — index table only (method, path, one-line purpose).
- Detail per route in `docs/api/<group>.md` only when a route is non-obvious or the index row is not enough.

Do not duplicate OpenAPI field tables for straightforward CRUD routes.

## Section Rules

### Overview

Short table when it helps:

| Item | Value |
|------|--------|
| Base URL | `https://host:port/api` |
| Format | JSON (unless otherwise) |
| Schema | `GET /openapi.json`, `GET /docs` |

### Auth

One explanation block and one request example. No secrets in examples.

### Conventions

Include only non-obvious rules: date/query validation, shared enums, common error codes. Skip what OpenAPI already states clearly.

### Endpoints

Group by path prefix (`/accounts`, `/workers`). One block per route.

### Docs

Links only: OpenAPI, operational flows, README, related guides.

## Endpoint Block

Use this order. Omit lines that add nothing.

```md
### `POST /resource`
**Body:** `field` (type), `optional?`  
**201:** brief response shape  
**409:** conflict — when
```

Rules:

- Path in backticks with method: `` `GET /items` ``.
- **Query**, **Body**, **Response** — only fields that affect calling the API.
- **Errors** — non-obvious status codes only; use `·` between items on one line when short.
- One `http` or `bash` example per group when it clarifies auth or a common pattern.

## Style

Match `$readme-writer`:

- One idea per sentence. Prefer bullets over paragraphs.
- Short section headers: `Overview`, `Auth`, `Conventions`, `Endpoints`, `Docs`.
- English unless the project already uses another language.
- No marketing language. No secrets in examples.
- Verify every link before adding or keeping it.

## README Link

When the project README needs an API entry:

- App/CLI or HTTP service: add `## API` with a link to `docs/API.md`.
- Library with HTTP surface: keep `## API` in the Lib README; link here for HTTP, keep import/usage notes for the library API.

Use `$readme-writer` for README structure.

## Avoid

- Operational guides, sequence diagrams, or long flows in `docs/API.md` — link a separate doc.
- Duplicating full OpenAPI schemas or every response field.
- Endpoint index plus full per-route docs for the same route.
- Documenting internal wire protocols unless callers use them directly.
- Sections filled only to match a template.

## Checklist

- Base URL, auth, and paths match the code or OpenAPI export.
- Every documented route exists.
- Empty sections removed.
- Schemas defer to OpenAPI where types are exhaustive.
- Flows and runbooks live under `## Docs`, not in the endpoint reference.

# Architecture (observed)

_Last reviewed: YYYY-MM-DD. On conflict, the codebase wins._

## Overview

Monorepo with a single deployable API and a web client.

## Boundaries

| Area | Path | Responsibility |
| --- | --- | --- |
| API | `src/api/` | HTTP transport, auth middleware, route wiring |
| Services | `src/services/` | Business rules and orchestration |
| Data | `src/db/` | Queries and migrations |
| UI | `src/ui/` | React app, pages, and shared components |

## Data flow

Client → API routes → services → database. Services do not import from route handlers.

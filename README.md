# Nexus

A lightweight control layer that keeps coding agents scoped, consistent, and verifiable.

![Nexus illustration](assets/nexus.png)

## Why

Coding agents are good at implementation, but project context, completion criteria, and durable knowledge often drift between sessions and hosts.

Nexus adds a small portable control layer without replacing the coding agent or project conventions.

## Model

```text
Understand → Implement → Verify → Persist
```

| Phase | What happens |
| --- | --- |
| **Understand** | `AGENTS.md` → relevant `docs/` → adjacent code |
| **Implement** | Coding agent + local conventions |
| **Verify** | `$integrity-review` with project checks |
| **Persist** | `$project-context` only when requested |

Code written ≠ done. Nexus requires evidence before completion.

## Principles

**Local first** — Project instructions and adjacent code beat Nexus defaults.

**Context on demand** — Load only the project knowledge relevant to the current task.

**Evidence over confidence** — An implementation is not complete until relevant evidence supports it.

**Explicit persistence** — Durable project knowledge is written only when requested.

## Install

```bash
git clone https://github.com/kodezy/nexus.git
cd nexus
./scripts/install.sh
```

Enable the plugin in your agent host, then reload. Re-run install after pulling. Details: [docs/install.md](docs/install.md).

## Project setup

1. Copy [template/AGENTS.md](template/AGENTS.md) into your app repo (merge if needed).
2. Grow `docs/<topic>.md` as needed — add a **Docs** row per file.

Nexus belongs to the agent environment. `AGENTS.md` and `docs/` belong to the project.

## Architecture

```text
nexus-contract        →  what must always hold
skills                →  how to perform special procedures
hooks / scripts       →  deterministic behavior / integration
AGENTS.md             →  project router
docs/                 →  project knowledge
```

| Layer | Role |
| --- | --- |
| `rules/nexus-contract.mdc` | Always-on policy |
| `skills/integrity-review/` | Evidence before “done” |
| `skills/project-context/` | Docs curator on request |
| `hooks/` | Session bootstrap |
| App `AGENTS.md` | Ritual, validation, doc index |
| App `docs/` | Living index from `## Docs`; flat `docs/<topic>.md` files with links |

Full workflow: [docs/workflow.md](docs/workflow.md).

## Maintainer

```bash
./scripts/verify.sh
```

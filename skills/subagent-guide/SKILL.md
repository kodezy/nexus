---
name: subagent-guide
description: Research and apply current best practices for creating subagents and multi-agent workflows from trusted official sources. Use when the user asks to create subagents/agents, define orchestration patterns, or validate agent architecture decisions with up-to-date web references.
---

# Subagent Best Practices

Create subagents with current, evidence-based guidance from trusted sources.

## When to use

Use this skill when the request includes:

- creating new subagents or agent teams
- choosing between single-agent and multi-agent orchestration
- defining manager/specialist handoffs
- validating agent architecture against current best practices

## Source priority

Use sources in this order:

1. Official model/vendor docs and engineering posts
2. Cloud provider architecture docs
3. Official SDK/framework documentation
4. Reputable independent technical publications

Prefer these domains:

- `openai.com`, `developers.openai.com`
- `anthropic.com`, `github.com/anthropics`
- `cloud.google.com`, `google.github.io`
- `learn.microsoft.com`

Avoid using blogs as primary evidence when official guidance exists.

## Research workflow

### 1) Clarify the target outcome

Capture:

- business goal
- latency/cost constraints
- safety requirements
- expected ownership model (single manager answer vs specialist takeover)

### 2) Collect recent evidence

Search for current guidance focused on:

- when to stay single-agent
- when to split into subagents
- orchestration patterns (handoff, manager-as-tools, parallel fan-out)
- guardrails, observability, and failure isolation

Use at least three trusted sources before final recommendations.

### 3) Extract decision signals

Summarize:

- triggers to keep one agent
- triggers to split into multiple agents
- pattern trade-offs (latency, cost, reliability, maintainability)
- required controls (limits, retries, approvals, stop conditions)

### 4) Propose the minimum viable architecture

Default recommendation order:

1. Single agent with clear tools
2. Manager + specialist-as-tool
3. Handoffs for delegated ownership
4. Parallel specialists with synthesis
5. Hierarchical decomposition only when needed

Add complexity only when evidence shows measurable benefit.

### 5) Deliver a practical spec

Provide:

- chosen pattern and why
- agent roles with narrow responsibilities
- tool contracts per agent
- state/context boundaries
- safety and observability controls
- rollout plan (prototype -> eval -> staged production)

## Core principles

- Start simple, split later
- Give each subagent one clear responsibility
- Keep routing rules explicit and legible
- Use structured outputs for machine-consumed results
- Define hard limits: max turns, max tool calls, timeout, budget
- Add human approval for irreversible or high-risk actions
- Instrument traces across orchestrator and subagents
- Design for partial failure and graceful degradation

## Recommended output format

Use this template in responses:

```markdown
## Goal
[What outcome the agent system must produce]

## Constraints
- Latency:
- Cost:
- Risk/Safety:

## Recommended pattern
[Single agent / manager+tools / handoff / parallel / hierarchical]

## Why this pattern
- [Reason 1]
- [Reason 2]

## Agent roles
- [Agent name]: [narrow responsibility]
- [Agent name]: [narrow responsibility]

## Contracts
- Inputs:
- Outputs (structured):
- Handoff or tool-call criteria:

## Guardrails
- Max turns/tool calls:
- Human approval gates:
- Allowed tools/data boundaries:

## Observability
- Trace IDs across agents:
- Metrics: success rate, latency, cost, handoff errors

## Sources
- [Title](URL)
- [Title](URL)
- [Title](URL)
```

## Anti-patterns

- splitting into many subagents before validating a single-agent baseline
- overlapping specialist responsibilities
- tool descriptions that are vague or duplicated
- hidden ownership of the final answer
- no stop conditions or budget limits
- no eval loop after architecture changes

## References

Read only when needed:

- [trusted-sources.md](references/trusted-sources.md)

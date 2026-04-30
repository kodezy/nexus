# Trusted Sources For Subagent Creation

Use these sources as primary references for up-to-date best practices.

## Primary sources

- OpenAI: [Orchestration and handoffs](https://developers.openai.com/api/docs/guides/agents/orchestration)
- OpenAI: [A practical guide to building agents](https://openai.com/business/guides-and-resources/a-practical-guide-to-building-ai-agents)
- Anthropic: [Building effective agents](https://www.anthropic.com/index/building-effective-agents)
- Anthropic: [How we built our multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system)
- Google Cloud: [Choose a design pattern for your agentic AI system](https://cloud.google.com/architecture/choose-design-pattern-agentic-ai-system)
- Google ADK: [Multi-agent systems](https://google.github.io/adk-docs/agents/multi-agents/)
- Microsoft Learn: [AI agent orchestration patterns](https://learn.microsoft.com/en-us/azure/architecture/ai-ml/guide/ai-agent-design-patterns)

## What to extract from each source

- when to keep a single agent
- criteria for splitting into subagents
- orchestration pattern trade-offs
- role boundaries and tool contracts
- safety guardrails and approval gates
- observability and evaluation guidance

## Source quality checks

Before using a source as evidence:

1. Confirm it is an official vendor or official framework document
2. Verify it describes concrete patterns, not generic opinions
3. Prefer pages with explicit trade-offs and operational guidance
4. Cross-check key claims in at least one other trusted source

## Practical synthesis rule

When sources disagree:

1. Prefer official API/runtime documentation over marketing summaries
2. Prefer architecture guidance that includes cost, latency, and failure modes
3. Recommend the smallest architecture that satisfies constraints

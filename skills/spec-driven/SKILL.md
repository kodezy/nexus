---
name: spec-driven
description: Use when defining a feature, user flow, UI, or behavior whose scope, states, content, or acceptance criteria need to be agreed before implementation.
---

# Spec Driven

Turn intent into a small, testable product specification. Keep the artifact proportional: a small feature needs a short decision record, not ceremony.

## Workflow

1. Capture the user goal, audience, and non-goals.
2. Define the primary flow, each UI state (loading, empty, error, success when relevant), and the data/actions required.
3. Specify visible copy as title, label, and value first. Add helper text only for an actionable constraint or consequence.
4. Set acceptance criteria that can be observed in the product, including responsive and accessibility requirements for UI work.
5. Resolve material ambiguities with the user before implementation.

Use the approved specification as the input to planning and implementation. An optional planning plugin can supply a deeper process when it fits the task and the authority order permits it; this skill supplies the product requirements for any resulting artifacts.

## Frontend Requirements

For a React UI, specify:

- target user and primary task;
- screen or route, primary action, and states;
- data source and mutation/error behavior;
- content that is necessary to act, with no explanatory duplicate;
- small and large viewport behavior;
- keyboard and assistive-technology expectations;
- acceptance criteria for the intended flow.

Do not select a component library, state library, or visual style without a requirement that justifies it. Preserve existing project conventions.

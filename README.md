# Agent Lab

Personal workspace for my agent skills and related material.

This repository keeps reusable instructions, patterns, and workflows for agent work. It stays tool-agnostic: the content should work across different agent clients when possible.

## Skills

- `architect`: simple structure and naming for modules, packages, and features.
- `code-style`: readable, consistent code style.
- `frontend`: React/Next.js and Dash frontend guidance.
- `github-assistant`: commit message suggestions from Git diffs.
- `log-writer`: logging levels, messages, and structure.
- `playwright`: browser automation with Playwright CLI.
- `readme-writer`: practical README writing.

## Structure

```text
.
|-- AGENTS.md
`-- skills/
    |-- architect/
    |-- code-style/
    |-- frontend/
    |-- github-assistant/
    |-- log-writer/
    |-- playwright/
    `-- readme-writer/
```

## Usage

Edit skills in:

```text
skills/<skill-name>/SKILL.md
```

If a skill needs supporting material, keep it close to the skill:

```text
skills/<skill-name>/docs/
skills/<skill-name>/scripts/
skills/<skill-name>/assets/
skills/<skill-name>/references/
```

## Conventions

- Keep everything in English.
- Keep instructions short and operational.
- Prefer rules that change the agent's real behavior.
- Keep skills tool-agnostic unless a tool dependency is required.
- Avoid long names, broad abstractions, and vague guidance.

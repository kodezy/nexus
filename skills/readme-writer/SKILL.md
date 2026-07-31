---
name: readme-writer
description: Write and refactor README documentation that is clear, simple, and practical. Use when creating or updating `README.md` files or other Markdown docs (`*.md`), especially for sections like installation, configuration, usage, architecture, API docs, and contributor guidance.
---

# README Writer

## Objective

Write documentation that is clear, direct, and practical. Keep README files short, easy to scan, and easy to maintain.

## Build The README In This Order

Use this default order only for sections the reader needs. Omit empty, obvious, or low-value sections.

1. Title and brief description
2. Features
3. Requirements
4. Installation
5. Configuration
6. Usage
7. Architecture (if relevant)
8. API, Contributing, or License (only when relevant)

## Write With This Style

- Use direct, action-oriented language.
- Use simple, everyday English.
- Use present tense.
- Use active voice.
- Use specific versions and concrete details.
- Keep sentences short and focused (one idea per sentence).
- Prefer bullet points over long paragraphs.
- State each fact once. Link to deeper documentation instead of repeating it.

## Apply Naming And Formatting Rules

- Prefer a single, familiar word for each section header: `## Install`, `## Configure`, `## Usage`, `## API`.
- Keep related content under one section; add a subsection only when it improves scanning.
- Do not shorten a heading into an unclear abbreviation or forced label.
- Use fenced code blocks for commands, snippets, and file paths.
- Use inline code for single terms such as `main.py`, `pyproject.toml`, and `uv sync`.
- Use bold only for high-signal emphasis such as **required** and **optional**.
- Use emojis sparingly and consistently, or avoid them entirely.
- Mark required vs optional items explicitly.

## Provide Executable Code Blocks

- Use language tags (`bash`, `python`, `json`, `yaml`).
- Include complete commands, not fragments.
- Include expected output only when it adds practical clarity.
- Keep `$` prefix usage consistent if chosen.
- Never include secrets, credentials, or real tokens.

## Validate Links

- Verify every link before adding or retaining it, including relative paths and anchors.
- Never leave a dead link, placeholder URL, empty target, or `TODO`/`TBD` link in a README.
- If a link cannot be verified, ask the user for the confirmed destination or omit the link.

## Prefer Concrete Examples

- Show minimal working examples.
- Cover common use cases first.
- Add advanced examples only when they help.
- Keep each example focused and short.

## Section Guidelines

### Title And Description

- Describe the project in one factual sentence.
- Avoid marketing language.

### Features

- Include only capabilities that help a reader decide or get started.
- Keep one capability per bullet.
- Start with action verbs when practical.

### Requirements

- List exact versions when critical.
- Separate required and optional dependencies.
- Keep prerequisites explicit and testable.

### Installation

- Use numbered steps.
- Keep one action per step.
- Include verification steps when useful.
- For Python projects: document the repo's real tool (**uv**, Poetry, or pip-only). Prefer documenting **uv** for greenfield harness defaults; do not invent a second package manager.

### Configuration

- Show a real example config (`.env`, `yaml`, or `json`).
- Explain critical settings.
- Mark defaults and required fields clearly.

### Usage

- Show basic usage first.
- Add common options and flags.
- Include `--help` patterns when CLI exists.

### Architecture

- Include only when structure matters to onboarding.
- Use a short tree view with concise annotations.

### Additional Sections

- Add a section only when it answers a likely reader question.
- Prefer one-word names such as `API`, `Contributing`, or `License`.
- Keep secondary details in linked documentation when possible.

## Keep Visual Organization Scannable

- Keep heading levels consistent (`##` then `###`).
- Add blank lines between sections.
- Use horizontal rules (`---`) only when they improve scanning.
- Keep lists and examples compact.

## Avoid These Problems

- Avoid long, dense narrative blocks.
- Avoid unexplained jargon.
- Avoid outdated or unverified instructions.
- Avoid mixing installation methods without clear separation.
- Avoid vague terms such as “soon” or “sometimes”.
- Avoid duplicated content across sections.
- Avoid sensitive data in any example.
- Avoid creating sections just to follow a template.
- Avoid “coming soon” links and links that must be filled in later.

## Maintenance Checklist

Before finishing README edits:

- Update docs when behavior or commands change.
- Remove outdated sections.
- Validate commands locally when possible.
- Verify links and references.
- Confirm every retained link resolves; ask the user when verification is not possible.
- Confirm version numbers are current.
- Remove sections and examples that do not help the primary reader.

---
name: readme-writer
description: Write and refactor README documentation that is clear, simple, and practical. Use when creating or updating `README.md` files or other Markdown docs (`*.md`), especially for sections like installation, configuration, usage, architecture, API docs, and contributor guidance.
---

# README Writer

## Objective

Write documentation that is clear, simple, and practical. Keep README files easy to understand, maintain, and evolve.

## Build The README In This Order

Use this default section order unless the project has an explicit existing standard:

1. Title and brief description
2. Features
3. Requirements
4. Installation
5. Configuration
6. Usage
7. Architecture (if relevant)
8. Additional sections (API docs, contributing, license, etc.)

## Write With This Style

- Use direct, action-oriented language.
- Use simple, everyday English.
- Use present tense.
- Use active voice.
- Use specific versions and concrete details.
- Keep sentences short and focused (one idea per sentence).
- Prefer bullet points over long paragraphs.

## Apply Naming And Formatting Rules

- Use clear section headers such as `## Installation`, `## Configuration`, `## Usage`.
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

- Use 5 to 10 bullets when possible.
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
- For Python projects that use this harness default: document **uv** (`uv sync`, `uv run`), not bare `pip install`, unless the repo is pip-only.

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

## Maintenance Checklist

Before finishing README edits:

- Update docs when behavior or commands change.
- Remove outdated sections.
- Validate commands locally when possible.
- Verify links and references.
- Confirm version numbers are current.

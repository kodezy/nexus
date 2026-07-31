---
name: frontend-quality
description: Use when reviewing or finalizing a React UI, page, component, or frontend flow for responsive behavior, accessibility, visual consistency, and concise UX.
---

# Frontend Quality

Review the completed UI before closeout. Fix supported issues; report uncertainties instead of guessing.

## Review

1. Confirm that every visible element supports the primary task. Remove duplicate descriptions, decorative controls, and repeated status information.
2. Check narrow and wide viewports. Content must remain readable, controls reachable, and primary actions clear without horizontal overflow.
3. Check semantic elements, explicit input labels, visible focus, keyboard operation, contrast, and accessible names for icon-only controls.
4. Check loading, empty, error, disabled, and success states that the feature can reach. Keep messages short and actionable.
5. Check Tailwind usage: use shared tokens/CSS variables, a consistent spacing and type scale, and no inline layout styles unless values are dynamic.

## Components and Libraries

Use existing project primitives first. For a new accessible primitive, shadcn/ui or Radix may be appropriate when their API fits the requirement; do not add either library merely for visual polish.

## Validation

Use `playwright` for a runnable UI flow when the task can be exercised in a browser. Inspect the primary flow at a narrow and wide viewport and check keyboard navigation where interactive controls are involved.

When the project already has browser/UI tests, or the user authorizes adding them, run an axe-core accessibility check for the rendered states. Automated checks supplement manual review; they do not prove accessibility.

Do not create test files solely for this review when the project contract forbids new automated tests.

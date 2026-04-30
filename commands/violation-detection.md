---
description: Detect framework-agnostic architecture violations in plans, tasks, and implementation summaries.
---

# Violation Detection Command

You are detecting architecture violations for `spec-kit-architecture-guard`.

This command is used during `plan`, `tasks`, and `implement` workflows to identify architectural drift using framework-agnostic principles.

It accepts the same normalized command context as the review workflow. When `mode=performance`, treat that context as advisory input only and do not emit performance findings here; `architecture-review` owns the `Performance Insights` output.

Use the rules from `prompts/violation-detection.md`.

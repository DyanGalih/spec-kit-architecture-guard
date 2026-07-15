# init-brownfield

## Ponytail Core Contract

Before continuing, you **MUST** read and apply `.specify/extensions/architecture-guard/templates/ponytail_core.md`. In the extension source checkout, use `templates/ponytail_core.md`. Treat that shared contract as authoritative; phase-specific instructions may narrow its application but must not weaken its safety or verification floor.

Brownfield-first project initialization for existing codebases.

Use this command when the repository already contains application code and you want to understand the current system before proposing structure, governance, or refactor work. After the current state is mapped, move to `/speckit.architecture-guard.init` if you need to define or refine constitutions before continuing into planning or implementation.

## Goal

Create a reliable current-state baseline before any architectural or delivery guidance is drafted.

## What it should do

1. Identify the actual application root and primary entrypoints.
2. Map the existing architecture, boundaries, and integration points.
3. Note any current conventions, constraints, and risky areas.
4. Capture known gaps between the current codebase and the desired governance model.
5. Identify existing pragmatic patterns (Ponytail principles: YAGNI, standard library preference, minimal abstractions) to preserve in the constitution.
6. Produce an initial brownfield plan instead of assuming a greenfield setup.

## Good outputs

- Current-state summary
- System boundaries and dependency map
- Existing conventions and exceptions
- Migration or refactor candidates
- First-pass plan for bringing the project under governance

## Guidance

- Prefer observation over assumption.
- Treat existing code as the source of truth.
- Keep the first pass lightweight and non-destructive.
- Ask for confirmation before suggesting broad refactors.

## When to use

- The repo already has production or prototype code.
- You need to onboard an existing project into Spec Kit governance.
- You want brownfield discovery before any greenfield-style scaffolding.

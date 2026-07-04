# Workflows

This document covers the governed planning, task, and implementation flows used by Architecture Guard.

## Governed Specification Workflow

Architecture Guard can orchestrate specification workflows across `flash-mem`, Security Review, and Architecture Guard validation when companion extensions are installed.

The orchestrated workflow is:

1. Memory synthesis: scoped retrieval of historical decisions before broader file reads
2. Specification generation: Spec Kit spec generation using that synthesis, enforcing Ponytail minimalism
3. Clarification: resolve ambiguities with architecture context in mind
4. Architecture validation: detect drift, bloat, and security-architecture conflicts
5. Governance summary: final overview of architecture and security risks
6. Interactive Auto-Fix Loop: option to automatically revise the specification if architectural gaps are found

### Example Orchestration

```text
/speckit.architecture-guard.governed-spec
```

## Governed Planning Workflow

Architecture Guard can orchestrate planning workflows across `flash-mem`, Security Review, and Architecture Guard validation when companion extensions are installed.

The orchestrated workflow is:

1. Memory synthesis: scoped retrieval of historical decisions before broader file reads
2. Plan generation: Spec Kit technical planning using that synthesis, enforcing Ponytail minimalism
3. Security validation: review the plan against trust boundaries
4. Architecture validation: detect drift, bloat, and security-architecture conflicts
5. Governance summary: final overview of architecture and security risks

### Example Orchestration

```text
/speckit.architecture-guard.governed-plan
```

## Governed Task Workflow

Architecture Guard can orchestrate governance checks throughout task generation when companion extensions are installed.

Flow:

memory synthesis -> tasks (with Ponytail minimalism) -> security task review -> architecture refactor generation -> analysis -> automatic analyst loop -> task governance summary

```text
/speckit.architecture-guard.governed-tasks
```

## Governed Implementation Workflow

Architecture Guard can orchestrate governance checks during implementation when companion extensions are installed.

Flow:

memory synthesis -> implement (with Ponytail pragmatism) -> security review -> architecture review (with Ponytail Audit) -> refactor or fix recommendations

```text
/speckit.architecture-guard.governed-implement
```

> Companion extensions are optional. Architecture Guard degrades gracefully and does not require `flash-mem` or Security Review to function. It orchestrates workflows only when companion artifacts or extensions are available.

## Practical Quick Flow

Choose the path that matches the repository state.

### Brownfield

1. Install the extension.
2. Run `/speckit.architecture-guard.init-brownfield`.
3. Review the current-state findings.
4. Run `/speckit.architecture-guard.architecture-workflow`.
5. Apply approved refactors into plan and task artifacts.

If you are specifically cleaning up duplicated logic, follow the [DRY Cleanup Guide](dry-cleanup.md) after the brownfield mapping pass.

### Greenfield

1. Install the extension.
2. Run `/speckit.architecture-guard.init`.
3. Review the constitution output.
4. Run `/speckit.architecture-guard.architecture-workflow`.
5. Apply approved refactors into plan and task artifacts.

This keeps architecture concerns visible throughout the delivery lifecycle instead of concentrating them at the end.

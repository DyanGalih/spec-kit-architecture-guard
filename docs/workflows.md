# Workflows

This document covers the governed planning, task, and implementation flows used by Architecture Guard.

## Governed Planning Workflow

Architecture Guard can orchestrate planning workflows across Memory Hub, Security Review, and Architecture Guard validation when companion extensions are installed.

The orchestrated workflow is:

1. Memory synthesis: scoped retrieval of historical decisions before broader file reads
2. Plan generation: Spec Kit technical planning using that synthesis first
3. Security validation: review the plan against trust boundaries
4. Architecture validation: detect drift and security-architecture conflicts
5. Governance summary: final overview of architecture and security risks

### Example Orchestration

```text
/speckit.architecture-guard.governed-plan
```

## Governed Task Workflow

Architecture Guard can orchestrate governance checks throughout task generation when companion extensions are installed.

Flow:

memory synthesis -> tasks -> security task review -> architecture refactor generation -> task governance summary

```text
/speckit.architecture-guard.governed-tasks
```

## Governed Implementation Workflow

Architecture Guard can orchestrate governance checks during implementation when companion extensions are installed.

Flow:

memory synthesis -> implement -> security review -> architecture review -> refactor or fix recommendations

```text
/speckit.architecture-guard.governed-implement
```

> Companion extensions are optional. Architecture Guard degrades gracefully and does not require Memory Hub or Security Review to function. It orchestrates workflows only when companion artifacts or extensions are available.

## Practical Quick Flow

1. Install the extension.
2. Initialize your constitutions.
3. Run an architecture review.
4. Review the findings.
5. Apply approved refactors into plan and task artifacts.

This keeps architecture concerns visible throughout the delivery lifecycle instead of concentrating them at the end.


# Architecture Review Adapters

Adapters are completely optional companion extensions that refine `architecture-guard` for a specific framework, platform, or architectural style.

You can use the core extension by itself. Add an adapter only when you want framework-specific vocabulary or conventions layered on top.

`architecture-guard` is the generic core extension, and `architecture-guard-<framework>` is the optional framework-specific adapter layered on top of it.

## Adapter Scope

Adapters add framework-aware context without changing the core architecture rules.

They may:

- Add framework-specific vocabulary.
- Map generic architecture concepts to framework primitives.
- Add examples that match a known stack.
- Refine detection logic using framework conventions.
- Extend prompts with framework-specific context.

They must not:

- Duplicate core rules.
- Replace the Constitution as the source of truth.
- Make the core extension depend on a framework.
- Convert the review into a linter or static analyzer.
- Introduce blocking behavior unless the Constitution requires it.

## When To Add One

Use an adapter when a rule depends on framework primitives and the generic core rules are not specific enough.

Examples:

- Laravel: controllers, form requests, resources, actions, services, repositories, Eloquent conventions.
- NestJS: controllers, providers, modules, DTOs, pipes, guards, repositories.
- Next.js: server actions, route handlers, pages, layouts, client and server components.
- Django: views, serializers, forms, models, services, querysets.
- Express: routers, middleware, handlers, service modules, validators.

Keep the rule in the core extension when it applies across stacks.

Examples of core rules:

- Entry points should not own business decisions.
- External input should be validated before application or domain logic.
- Shared boundaries should use explicit contracts.
- Modules should not depend on another module's internals.
- Comparable outputs should use consistent shapes.

## Prompt Pattern

Adapter prompts should extend, not replace, the core prompts.

Use this shape:

```text
Use the core architecture review rules first.

When reviewing <framework>, map generic concepts as follows:
- Entry boundary:
- Validation boundary:
- Contract boundary:
- Application boundary:
- Domain boundary:
- Data boundary:
- Integration boundary:
- Presentation boundary:

Additional framework-specific signals:
- ...

Do not report a framework convention as a violation unless it conflicts with the Constitution or core architecture principles.
```

## Naming And Packaging

Recommended adapter names:

- `architecture-guard-laravel`
- `architecture-guard-nestjs`
- `architecture-guard-nextjs`
- `architecture-guard-django`
- `architecture-guard-express`

Recommended package structure:

```text
architecture-guard-<framework>/
├── README.md
├── extension.yml
└── commands/
    └── adapter-guidance.md
```

## Compatibility

Adapters should declare compatibility with:

- `architecture-guard`
- Spec Kit prompt-based workflows
- The same phases: `specify`, `plan`, `tasks`, `implement`

Adapters should be optional and safe to remove.

## Example Refinements

Core rule:

```text
Business logic should not live in request entry points.
```

NestJS refinement:

```text
In NestJS, controllers should usually validate, map, and delegate. Business workflows should live in providers, application services, or domain services according to the project's Constitution.
```

Laravel refinement:

```text
In Laravel, controllers should usually coordinate request validation, mapping, and response creation. Business workflows may live in actions, services, jobs, or domain classes depending on the project's Constitution.
```

## How To Use One

There are two common ways to use an adapter:

1. Install an existing adapter extension alongside the core extension.
2. Create your own adapter if your framework or team conventions are not covered yet.

### Install An Existing Adapter

Install the core extension first, then install the adapter extension for your framework.

```text
specify extension add architecture-guard
specify extension add <adapter-name>
```

Use the adapter's own README or manifest to see the exact package name, namespace, and command set it provides.

### Create Your Own Adapter

Create a separate extension for the adapter with its own:

- `extension.yml`
- `commands/`

Then:

- Set the adapter `id` to something framework-specific, like `architecture-guard-nestjs`.
- Keep the core rules in `architecture-guard`.
- Put framework-specific examples and conventions in the adapter commands.
- Make the adapter safe to remove so the core extension still works on its own.

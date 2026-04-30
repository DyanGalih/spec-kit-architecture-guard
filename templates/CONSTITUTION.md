# Project Constitution

> This is the foundational document that Architecture Guard reviews against.
> Fill in each section with the architectural rules for your project.
> If a section does not apply, mark it as "Not applicable" rather than deleting it.

## Project Identity

- **Name**: [Your project name]
- **Type**: [Monolith / Modular Monolith / Microservices / Full-stack / Library / Other]
- **Primary Stack**: [e.g., Laravel + Vue, NestJS + React, Django + HTMX]

## Architectural Principles

> List the non-negotiable rules that shape how the system is structured.

1. [e.g., Business logic must not live in controllers, routes, or UI components.]
2. [e.g., All external input must cross a validation boundary before reaching application logic.]
3. [e.g., Modules must not depend on another module's internal implementation.]
4. [e.g., All API responses must use the standard envelope: `{ data, meta, errors }`.]
5. [e.g., Data access must go through a repository or gateway abstraction.]

## Module Boundaries

> Define which modules exist and what they own.

| Module | Owns | Must Not |
| --- | --- | --- |
| [e.g., Orders] | [Order creation, pricing, fulfillment] | [Access billing tables directly] |
| [e.g., Billing] | [Invoicing, payment processing] | [Own order business rules] |
| [e.g., Auth] | [Authentication, session management] | [Own product authorization rules] |

## Contract Conventions

> Define what contracts look like in your project.

- **Request contracts**: [e.g., DTOs / Form Requests / Zod schemas / interfaces]
- **Response contracts**: [e.g., Resource classes / response DTOs / typed interfaces]
- **Event contracts**: [e.g., Event classes / message schemas]
- **Shared types**: [e.g., enums for status values, shared value objects]

## Layering Rules

> Define which layers exist and what they may depend on.

| Layer | May Depend On | Must Not Depend On |
| --- | --- | --- |
| [Entry / Controller] | [Application, Contracts] | [Domain internals, Persistence] |
| [Application / Service] | [Domain, Contracts, Data abstractions] | [Entry points, UI] |
| [Domain] | [Nothing external] | [Framework, Database, HTTP] |
| [Data / Repository] | [Domain contracts, Persistence drivers] | [Entry points, Application logic] |

## Accepted Deviations

> List intentional exceptions to the rules above. Without this section, Architecture Guard will flag them as violations.

- [e.g., The `reports` module uses direct SQL queries because the ORM cannot express the required aggregations. This is accepted.]
- [e.g., The `admin` module bypasses the standard response envelope for CSV exports.]

## Blocking vs Non-Blocking Rules

> By default, all architecture violations are non-blocking (they generate refactor tasks, not errors).
> List any rules that MUST block implementation:

- [e.g., P0: No module may directly access another module's database tables.]
- [e.g., P0: All public API endpoints must validate input before processing.]

## Notes

- This Constitution is versioned alongside the codebase.
- Update it through a Constitution Update Proposal when patterns evolve.
- Architecture Guard uses this document as its primary source of truth.

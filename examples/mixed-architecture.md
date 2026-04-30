# Mixed Architecture Example

## Context

A full-stack feature adds subscription status to both an API service and a web UI.

Existing architecture expectations:

- Backend responses use explicit contracts.
- Frontend consumes generated or documented API-facing types.
- Business status values must be consistent across API, UI, and background events.
- Module boundaries should not depend on another service's internals.

## Implementation Snapshot

```text
API:
- Returns subscription status as `active`, `past_due`, or `cancelled`.
- Uses an inline response literal.
- Reads billing provider data directly in the subscription handler.

UI:
- Expects status as `ACTIVE`, `PAST_DUE`, or `CANCELED`.
- Maps unknown values to `inactive`.
- Shows renewal messaging based on local component logic.

Background job:
- Emits `subscription_cancelled` events with a third status spelling: `canceled`.
```

## Architecture Review

```text
Architecture Review

Constitution Alignment:
- Status: Misaligned
- Notes: The feature crosses API, UI, and event boundaries without a shared subscription status contract.

Violations:
- Type: Inconsistent Data Contract
  Severity: High
  Location: Subscription status across API, UI, and background event
  Description: The same business concept uses incompatible status values and spellings across system boundaries.
  Evidence: API returns `cancelled`, UI expects `CANCELED`, and the background job emits `canceled`.
  Principle: Shared cross-boundary concepts should use explicit and consistent contracts.

- Type: Missing Data Contract
  Severity: High
  Location: Subscription API response
  Description: The API response is represented as an inline literal rather than a documented contract.
  Evidence: The UI and background event each infer their own status representation.
  Principle: API and event boundaries should expose stable request/response/message contracts.

- Type: Direct Data Access Without Abstraction
  Severity: Medium
  Location: Subscription handler billing provider access
  Description: The subscription handler reads billing provider data directly instead of using an integration boundary.
  Evidence: Billing provider access is performed inside the subscription entry/application flow without a gateway or client abstraction.
  Principle: External integrations should be isolated behind an approved integration abstraction.

- Type: Business Logic In Entry Boundary
  Severity: Medium
  Location: Subscription UI renewal messaging
  Description: Renewal messaging rules are implemented directly in the UI component.
  Evidence: The component decides messaging from raw status values instead of consuming a normalized view model or feature rule.
  Principle: Presentation boundaries should not own reusable product rules.

Refactor Tasks:
[Refactor Task]
Title: Define a shared subscription status contract
Reason: API, UI, and background events currently use incompatible values for the same business concept.
Scope: Subscription API response, UI consumer, and subscription event payload.
Priority: P1
Suggested Fix: Define canonical subscription status values in a DTO, schema, interface, event contract, or equivalent, then update producers and consumers to use the same values.

[Refactor Task]
Title: Add an explicit subscription response contract
Reason: The API response shape is currently inline, allowing downstream consumers to invent incompatible assumptions.
Scope: Subscription status API response and UI-facing type.
Priority: P1
Suggested Fix: Create a documented response contract and map provider-specific values into the canonical contract before returning data.

[Refactor Task]
Title: Isolate billing provider access behind an integration boundary
Reason: The subscription handler directly depends on provider data access, making provider behavior leak into subscription logic.
Scope: Subscription handler and billing provider access path.
Priority: P2
Suggested Fix: Introduce or reuse a billing gateway, client, adapter, or equivalent integration abstraction that returns canonical subscription data.

[Refactor Task]
Title: Move renewal messaging decision out of the UI component
Reason: The component owns a reusable product rule and depends on raw status values.
Scope: Subscription UI component and subscription feature logic.
Priority: P2
Suggested Fix: Provide a normalized view model or feature-level helper that maps canonical subscription status to renewal messaging.

Consistency Notes:
- Modules: Subscription, billing, and UI modules need one canonical contract for status.
- Services: Subscription service should map provider-specific values before exposing them.
- Handlers/Controllers: API response boundary should return a documented contract.
- Data Contracts: Status values must be aligned across API response, UI consumer, and event payload.

Summary:
- Overall Risk: High
- Recommended Next Step: Prioritize the shared status contract before adding more subscription states or consumers.
```


# Generic Frontend Example

## Context

A frontend feature adds a customer profile screen.

Existing architecture expectations:

- UI components render state and delegate business rules.
- API responses are mapped through shared contracts.
- State transitions live in feature-level state or application logic.
- Components should not duplicate domain rules.

## Implementation Snapshot

```text
CustomerProfile component:
- Fetches customer data.
- Infers account eligibility from raw fields.
- Mutates nested response objects directly.
- Builds UI-specific error messages from raw API errors.
- Uses a different customer shape than other profile screens.
```

## Architecture Review

```text
Architecture Review

Constitution Alignment:
- Status: Partially aligned
- Notes: The UI delivers the feature but mixes presentation, state transformation, and business rules inside a component boundary.

Violations:
- Type: Business Logic In Entry Boundary
  Severity: Medium
  Location: CustomerProfile component
  Description: Account eligibility is inferred directly inside the rendering component.
  Evidence: The component reads raw customer fields and makes product eligibility decisions before rendering.
  Principle: Presentation boundaries should delegate business rules to feature logic, application logic, or domain helpers.

- Type: Inconsistent Data Contract
  Severity: Medium
  Location: Customer data mapping
  Description: The component uses a different customer shape than nearby profile screens.
  Evidence: Other profile screens consume a normalized customer contract, while this component depends on raw API fields.
  Principle: Shared data consumed across UI modules should be normalized through a stable contract.

- Type: Missing Validation Boundary
  Severity: Low
  Location: API response handling
  Description: Raw API error structures are transformed directly in the component.
  Evidence: The component builds user-facing error messages from unnormalized API errors.
  Principle: External outputs should be mapped at a boundary before presentation code consumes them.

Refactor Tasks:
[Refactor Task]
Title: Move customer eligibility logic out of the profile component
Reason: The component currently owns a product decision, which makes the rule harder to reuse and test consistently.
Scope: CustomerProfile component and customer feature logic.
Priority: P2
Suggested Fix: Extract eligibility calculation into a feature service, selector, domain helper, or equivalent application boundary and pass the result into the component.

[Refactor Task]
Title: Normalize customer API data before rendering
Reason: The component depends on a raw API shape that differs from the customer contract used by nearby screens.
Scope: Customer API response mapping and CustomerProfile data input.
Priority: P2
Suggested Fix: Reuse or introduce a normalized customer view contract and map API responses before they reach presentation code.

[Refactor Task]
Title: Centralize customer error mapping
Reason: The component transforms raw API errors directly, which may create inconsistent user-facing output.
Scope: Customer API boundary and profile error display.
Priority: P3
Suggested Fix: Map API errors into a consistent feature-level error contract before rendering.

Consistency Notes:
- Modules: Customer profile diverges from nearby profile screen data contracts.
- Services: Feature-level logic should own eligibility and mapping decisions.
- Handlers/Controllers: Not applicable for this frontend-only review.
- Data Contracts: Customer view contract should be aligned with existing screens.

Summary:
- Overall Risk: Medium
- Recommended Next Step: Keep the screen implementation moving, then extract eligibility and mapping before duplicating the pattern in more UI surfaces.
```


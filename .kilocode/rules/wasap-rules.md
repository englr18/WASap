# wasap-rules.md


**WASap — Engineering Rules & Implementation Contract**

---

## 1. Core Principles

### 1.1 Strict Separation of Concerns

Each layer must have a clearly bounded responsibility:

* **Domain** → Pure business logic (no framework dependencies)
* **Data** → External interactions (storage, launcher, etc.)
* **Presentation** → UI + state orchestration

**Violation is not allowed** (e.g., UI calling services directly).

---

### 1.2 Offline-First Guarantee

* All features must work without internet access
* No runtime dependency on external APIs

---

### 1.3 Deterministic Logic

Phone number normalization must be:

* Deterministic
* Idempotent
* Independent from external state

---

## 2. Architecture Rules

### 2.1 Dependency Direction

```
presentation → domain ← data
```

* Presentation depends only on **use cases**
* Data implements **repository interfaces**
* Domain must not depend on any external layer

---

### 2.2 Domain Constraints

#### Allowed:

* Pure Dart code
* Entities and value objects
* Business rules

#### Forbidden:

* Flutter SDK
* SharedPreferences
* url_launcher
* Any IO or platform-specific logic

---

### 2.3 Use Case Standard

Each use case must:

* Be stateless
* Have a single responsibility
* Return strongly typed results (no `dynamic`)

Example:

```dart
class NormalizePhoneNumber {
  String call(String input);
}
```

---

## 3. State Management Rules (Riverpod)

### 3.1 Controller Responsibilities

Controllers may:

* Orchestrate use cases
* Manage UI state

Controllers must NOT:

* Contain business logic
* Access storage/services directly

---

### 3.2 State Shape Standard

Use explicit immutable state models:

```dart
class PhoneState {
  final String input;
  final String? normalized;
  final bool isValid;
  final bool isLoading;
  final String? error;
}
```

---

### 3.3 Provider Rules

* Use `@riverpod` annotations
* No global mutable state
* All dependencies must be injected via providers

---

## 4. Phone Number Normalization Rules

### 4.1 Canonical Output Format

Output must always be:

```
62XXXXXXXXX
```

* No `+`
* No spaces
* Digits only

---

### 4.2 Normalization Pipeline (Strict Order)

1. Remove all non-digit characters
2. Apply rules:

   * Starts with `62` → keep as-is
   * Starts with `0` → replace `0` with `62`
   * Starts with `8` → prepend `62`
   * Otherwise → prepend `62`

---

### 4.3 Validation Rules

A number is considered valid if:

* Length ≥ 10 digits
* Starts with `62`

---

### 4.4 Idempotency Rule

```
normalize(normalize(x)) == normalize(x)
```

This must always hold true.

---

## 5. WhatsApp Launch Rules

### 5.1 URL Contract

```
https://wa.me/{number}?text=
```

* No alternative formats allowed
* Use proper URI builders (no manual string concatenation errors)

---

### 5.2 Failure Handling

On failure:

* Do not crash
* Emit an error state
* UI must display feedback

---

### 5.3 Loading Behavior

The WhatsApp button must:

* Be disabled when input is invalid
* Show loading state during launch

---

## 6. Storage Rules

### 6.1 SharedPreferences Scope

Allowed usage:

* App settings
* Recent numbers

Not allowed:

* Complex state persistence
* Large data storage

---

### 6.2 Recent Numbers Policy

* Maximum: **20 entries**
* FIFO (First In, First Out)
* No duplicates
* Most recent item appears first

---

## 7. UI/UX Consistency Rules

### 7.1 Design System Compliance

* Must follow **Material Design 3**
* No inconsistent custom styling

---

### 7.2 Input Behavior

* Normalization must happen **in real-time**
* Preview must update immediately (no delay)

---

### 7.3 Error Handling UI

Errors must be:

* Visible
* Contextual
* Non-blocking

---

### 7.4 Empty State Rules

* Recent list empty → show empty state
* Blank UI is not allowed

---

## 8. Performance Constraints

* Normalization latency: < 100ms
* No blocking operations on UI thread
* Minimize unnecessary widget rebuilds

---

## 9. Testing Rules

### 9.1 Mandatory Unit Tests

Required for:

* Normalization logic
* Use cases

---

### 9.2 Minimum Test Coverage

| Case          | Expected Result |
| ------------- | --------------- |
| `0812...`     | `62812...`      |
| `+62812...`   | `62812...`      |
| `812...`      | `62812...`      |
| invalid input | error           |

---

### 9.3 Idempotency Test

```dart
expect(normalize(normalize(x)), normalize(x));
```

---

## 10. Code Quality Rules

### 10.1 Lint Compliance

* Must follow `flutter_lints`
* Zero warnings allowed in CI

---

### 10.2 File Size Constraint

* Maximum 300 lines per file
* Split files when necessary

---

### 10.3 Naming Conventions

| Element  | Convention |
| -------- | ---------- |
| Class    | PascalCase |
| Variable | camelCase  |
| File     | snake_case |

---

## 11. CI/CD Enforcement

Pipeline must:

* Run static analysis
* Run all tests
* Fail on:

  * Any lint issue
  * Any test failure

---

## 12. Definition of Done (DoD)

A feature is considered complete when:

* [ ] Fully aligned with PRD
* [ ] Complies with rules.md
* [ ] Unit tests exist and pass
* [ ] No lint warnings
* [ ] UI matches design specification
* [ ] Edge cases handled

---

## 13. Forbidden Anti-Patterns

* Business logic inside UI
* Direct SharedPreferences usage in controllers
* Hardcoded strings without localization
* Async code without error handling
* Duplicate normalization logic

---

## 14. Extensibility Rules

* Phone logic must be reusable for future multi-country support
* Avoid scattering Indonesia-specific assumptions
* Centralize formatting logic

---

## 15. Documentation Rules

* Every use case must include docstrings
* Public APIs must clearly define input/output behavior



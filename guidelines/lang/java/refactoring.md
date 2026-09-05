## Refactoring — Java

Bindings for `refactoring.md`.

- **No defensive type checks.** `x instanceof T t ? t : new T(x)` means the callers disagree. Fix the callers.
- **Watch for re-nulling fallbacks.** `optional.orElse(null)` converts an absent value back to `null`, breaking the null-object pattern. Pass the `Optional` through, or resolve it to a domain default.
- **No coercion in constructors.** A record constructor that accepts the raw primitive and wraps it hides the call sites that should have been updated. Reject, don't convert.

## Refactoring Principles

### Type propagation

When replacing a primitive (`str`, `String`) with a domain type across a codebase, map blast radius before starting:

- **No coercion validators.** Do not add auto-convert hacks that mask call sites that should be explicitly updated. If validation rejects a value, the caller is wrong — fix the caller.
- **Push wrapping to the origin.** Wrap at the point the value is created (factory, JSON parse boundary, external response), not at every intermediate consumer. If a factory returns the domain type, downstream code should never need to re-wrap.
- **No defensive `isinstance` checks.** Code like `label if isinstance(label, DomainType) else DomainType(label)` is a symptom of inconsistent callers. Fix the callers to always pass the right type.
- **Domain methods over string extraction.** Add methods to the type instead of extracting the raw value and calling string methods.
- **Validate at construction, not at use.** Add construction-time validation to reject invalid values (e.g., double-wrapping) so bugs surface immediately at the construction site, not at some distant consumer.
- **Separate name generation from typed generation.** If a factory is used for both typed values and non-typed unique names, split it into separate factories.
- **Serialization at the boundary.** Convert to primitives only at JSON serialization, display, and string-keyed dict boundaries. Never convert in the middle of a pipeline just to feed it back into the domain type.
- **File issues for the next ring.** After propagating the type into the immediate adjacents, file issues for the next ring of types that still use primitives. Don't try to do everything in one session.
- **Search for bare-primitive comparisons before committing.** Domain types that return `NotImplemented` from `__eq__` for primitives cause silent failures. Always search for comparison patterns against the migrated field.
- **`or None` defeats null-object sentinels.** Patterns like `result or None` convert a falsy sentinel back to `None`, breaking the null-object pattern. Replace with direct pass-through.
- **Bridge removal is a separate commit.** Migrate all callers first, verify all tests pass, then remove the bridge conversion in a follow-up commit. This isolates failures.
- **Dict-literal kwargs are a separate migration surface.** Dict literals in test fixtures are not caught by the same search as keyword arguments. JSON fixture dicts that feed serialization must keep primitive values; dicts that feed direct API calls need domain types.
- **Domain types are not JSON-serializable.** Every serialization path needs primitive conversion at the boundary. Check all serialization paths after migration.

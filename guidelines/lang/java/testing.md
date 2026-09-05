## Testing — Java

Bindings for `testing.md`.

- **JUnit 5.** Do not use JUnit 4 unless maintaining legacy code.
- **AssertJ** over Hamcrest or raw JUnit assertions.
- **`@TempDir`** for filesystem tests.
- **Constructor injection or test-specific factories** for test doubles. No `@MockBean`, no inline `Mockito.mock()`, no reflection-based injection — wire fakes through the same DI path as production code.
- **Test trees**: unit tests under `src/test/java/.../unit/`, integration tests under `src/test/java/.../integration/`.
- **Expected failures** use `@Disabled` with a reason and an issue reference, or an assumption that documents the gap.

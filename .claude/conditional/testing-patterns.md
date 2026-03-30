## Testing Patterns

- **TDD:** Write failing tests first. For every bug fix, write a test that fails without the fix.
- **Review assertions after writing tests.** After writing tests, review every assertion for specificity. Replace weak assertions (`assert x is not None`, `assert "name" in result`, `assert len(items) > 0`) with concrete value assertions (`assert result == 30`, `assert items == [1, 2, 3]`). If a concrete assertion isn't possible, document why.
- **Unit vs integration:** Unit tests (no I/O) in `tests/unit/`. Integration tests (LLMs, databases, external repos) in `tests/integration/`.
- **Fixtures:** Use test framework fixtures and temp directories for filesystem tests.
- **No mocking:** Do not use monkey-patching or mock.patch. Use dependency injection with mock objects.
- **Assertions are sacred:** Do not modify test assertions unless certain the change is valid. Do not remove assertions without review.
- **No implementation hacks for tests:** Never add special behavior just to make tests pass. Document hard-to-implement behavior or ask for guidance.
- **xfail for known gaps:** If a feature isn't handled yet, write the real test with correct assertions, mark it as expected failure with a reason and issue reference. Don't rename tests or write fallback programs.
- **Both unit and integration tests** for every new feature. Unit tests verify structure (correct shape, no placeholders). Integration tests execute end-to-end and assert on **concrete output values**. This applies even when verifying suspected already-working features — "it probably works" is not a substitute for a test that proves it.

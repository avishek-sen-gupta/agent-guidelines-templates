# Python-Specific Claude Code Instructions

## Project Context

- Primary languages: Python (main codebase), TypeScript/JavaScript (tooling/web), Markdown (docs).
- When editing Python, always run `black` formatting before committing. When test counts are mentioned (e.g., 'all 625 tests passing'), verify that count hasn't regressed.
- When you are generating a new run, for every output directory, please attach time stamp and the technique used.

## Build

- Before committing anything, run `poetry run black` on every Python file touched in the change. The CI pipeline enforces Black formatting and will fail if this is skipped.

## Testing Patterns

- Use `pytest` with fixtures for test setup.
- Do not patch with `unittest.mock.patch`. Use proper dependency injection, and then inject mock objects.
- Use `tmp_path` fixture for filesystem tests.

## Programming Patterns

- When importing, use fully qualified module names. Do not use relative imports.
- Parameters in functions, if they must have default values, must have those values as empty structures corresponding to the non-empty types (empty dictionaries, lists, etc.). Categorically, do not use None.
- If a function has a non-None return type, never return None.
- If a function returns a non-None type in its signature, but cannot return an object of that type because of some condition, use null object pattern. Do not return None.
- Favour one class per file, dataclass or otherwise.

## Dependencies

- Python 3.13+
- Poetry for dependency management
- Universal CTags (external) for code symbol extraction
- Neo4j (optional) for graph persistence

## Notes

- Use `poetry run` prefix for all Python commands.
- If Talisman detects a potential secret, stop what you are doing, prompt me for what needs to be done, and only then should you update the `.talismanrc` file.
- Potential secrets in files trigger Talisman pre-commit hook - add to `.talismanrc` if needed. Don't overwrite existing `.talismanrc` entries, add at the end.
- Integration tests depend on local repo paths (`~/code/mojo-lsp`, `~/code/smojol`).

# Python-Specific Claude Code Instructions

The Python layer. Everything language-agnostic lives in the topic files
(`guardrails.md`, `workflow.md`, `testing.md`, and the rest) — this file holds only
what changes because the language is Python.

## Typing

- **Pyright runs in strict mode and must pass with zero errors.**
- **`Any` is banned** — no `from typing import Any`, no `: Any`, no `dict[str, Any]`. Where a type is hard to express use a `Protocol`, a `TypeVar`, or a union; where it is genuinely unknown at a boundary, parse it into a Pydantic model there.
- **No `object`, and no JSON-blob aliases.** `object`, `JsonValue`, `JsonDict`, `JsonObject` and hand-rolled recursive JSON aliases are `Any` with extra steps.
- **Every generic is parameterised**: `dict[str, int]` not `dict`, `list[Node]` not `list`, `tuple[int, str]` not `tuple` — `Sequence`, `Mapping`, `set`, `frozenset` and `Iterable` alike. Pyright strict enforces this via `reportMissingTypeArgument`.
- **A class implementing a `Protocol` inherits it**, even though structural typing would accept it silently. Inheriting puts the error on the broken class rather than the distant list where the objects meet the annotation, and makes implementations navigable from the protocol. Contracts satisfied by types outside the codebase — a shape matching `subprocess.Popen`, say — stay structural.

## Text as a boundary

JSON exists only as text in files. On entering Python it becomes a Pydantic model via `model_validate_json`.

- Model and API output meets `model_validate_json` first.
- Serialise with `model_dump_json` / `model_json_schema` in the adapter, at the last possible moment.
- Anything read from a JSON file becomes a model immediately. Never index a parsed dict.
- Where the model class is generated at runtime, the containing type is **generic** (`Container[InT]`) and the class is resolved by import before validation — late-bound, not unknown.

## Build

- Use the `uv run` prefix for all Python commands. On Poetry-managed projects substitute `poetry run`.
- Before committing, run `uv run black` on every file touched, then `uv run pyright`. Zero errors is the only acceptable count.

## Testing

- `pytest` with fixtures; `tmp_path` for filesystem tests.
- No `unittest.mock.patch`. Inject fakes — a `FakeLLM` with scripted replies, an injected clock, an injected spawner.
- Unit tests in `tests/unit/`, integration tests in `tests/integration/`.

## Programming patterns

- Fully qualified module names on import. No relative imports.
- Dataclasses must be `frozen=True`. No exceptions.
- Never `None` as a default parameter — use empty structures. Never return `None` from a non-`None` return type; use the null object pattern.
- `Sequence` and `Mapping` from `collections.abc` for parameters the function does not mutate.
- One class per file, dataclass or otherwise.
- Logging via the `logging` module, never `print`.

## Introspection

- Write temporary scripts to the scratchpad directory and run them with `uv run python <path>`. Clean up afterwards.
- Do not use `python -c` with multiline strings.

## Dependencies

- Python 3.13+
- uv for dependency management
- Pyright (strict) for type checking
- Black for formatting
- Pydantic for boundary parsing and validation

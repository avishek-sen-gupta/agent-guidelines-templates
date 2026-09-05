## Workflow — Python

Bindings for `workflow.md`.

### Build tool

Use the `uv run` prefix for all Python commands. On Poetry-managed projects
substitute `poetry run`.

### Verification gate

Substitute for the placeholders in `workflow.md`:

```bash
uv run black .            # formatter
uv run pyright            # strict mode, zero errors
uv run pytest tests/      # ALL tests, unit and integration
```

### Introspection

- Write temporary scripts to the scratchpad directory and run them with `uv run python <path>`. Clean up afterwards.
- Do not use `python -c` with multiline strings.

# AI Engineering Primitives

Principles and practices for AI-assisted coding, with a focus on Claude Code.

## Contents

- [PHILOSOPHY.md](PHILOSOPHY.md) — Core project philosophy: toolkit-first, anti-vendor, engineer-owned.
- [AGENT_GUIDELINES.general.md](AGENT_GUIDELINES.general.md) — Language-agnostic guidelines for AI coding agents: workflow, testing patterns, programming patterns, and build rules.
- [AGENT_GUIDELINES.python.md](AGENT_GUIDELINES.python.md) — Python-specific guidelines: Black formatting, pytest, Poetry, dependency management.
- [AGENT_GUIDELINES.java.md](AGENT_GUIDELINES.java.md) — Java-specific guidelines: Gradle, JUnit 5, AssertJ, records, sealed interfaces.
- [AGENT_GUIDELINES.example.python.md](AGENT_GUIDELINES.example.python.md) — A complete example combining general + Python guidelines (sourced from a real project).
- [AGENT_GUIDELINES.example.java.md](AGENT_GUIDELINES.example.java.md) — A complete example combining general + Java guidelines.

## How It Works

The guidelines follow a layered composition model:

1. **Start with the general guidelines.** [`AGENT_GUIDELINES.general.md`](AGENT_GUIDELINES.general.md) captures language-agnostic principles — workflow, testing philosophy, programming patterns, and build discipline. These apply to any project regardless of language or toolchain.

2. **Add a language-specific layer.** Files like [`AGENT_GUIDELINES.python.md`](AGENT_GUIDELINES.python.md) and [`AGENT_GUIDELINES.java.md`](AGENT_GUIDELINES.java.md) contain rules that only make sense in the context of a specific language: formatters, test frameworks, null-handling idioms, collection APIs, etc.

3. **Merge into a final file.** Ask an LLM to merge the general and language-specific guidelines into a single file (e.g., [`AGENT_GUIDELINES.example.java.md`](AGENT_GUIDELINES.example.java.md)). Sections that exist in both layers are merged, with language-specific rules layered on top. This merged file is what you'd drop into your project as `CLAUDE.md`.

```
AGENT_GUIDELINES.general.md    (universal principles)
        +
AGENT_GUIDELINES.<lang>.md     (language-specific rules)
        =
CLAUDE.md                      (final file for your project)
```

## Usage

1. Copy `AGENT_GUIDELINES.general.md` as your starting point.
2. Pick (or create) a language-specific file for your stack.
3. Merge the two into a single `CLAUDE.md` and drop it into your project root.
4. Customise further with project-specific rules (repo paths, CI pipelines, team conventions).

See the `example` files for what the merged result looks like.

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE.md) file for details.

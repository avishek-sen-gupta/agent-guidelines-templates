# AI Engineering Primitives

Principles and practices for AI-assisted coding, with a focus on Claude Code.

## Contents

- [PHILOSOPHY.md](PHILOSOPHY.md) — Core project philosophy: toolkit-first, anti-vendor, engineer-owned.
- [AGENT_GUIDELINES.general.md](AGENT_GUIDELINES.general.md) — Language-agnostic guidelines for AI coding agents: workflow, testing patterns, programming patterns, and build rules.
- [AGENT_GUIDELINES.python.md](AGENT_GUIDELINES.python.md) — Python-specific guidelines: Black formatting, pytest, Poetry, dependency management.
- [AGENT_GUIDELINES.java.md](AGENT_GUIDELINES.java.md) — Java-specific guidelines: Gradle, JUnit 5, AssertJ, records, sealed interfaces.
- [AGENT_GUIDELINES.example.python.md](AGENT_GUIDELINES.example.python.md) — A complete example combining general + Python guidelines (sourced from a real project).
- [AGENT_GUIDELINES.example.java.md](AGENT_GUIDELINES.example.java.md) — A complete example combining general + Java guidelines.
- [CLAUDE.md](CLAUDE.md) — Root agent instructions using `#import` directives.
- [.claude/](.claude/) — Hook infrastructure for conditional invariant injection.

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

## Hook Infrastructure — Conditional Invariant Injection

The `.claude/` directory contains a two-layer system for context-aware agent instructions:

### Architecture

```
CLAUDE.md                          (#import directives → core files)
.claude/
├── settings.json                  (SessionStart + UserPromptSubmit hooks)
├── classify-prompt.sh             (keyword classifier → conditional injection)
├── core/                          (always loaded on session start)
│   ├── project-context.md
│   ├── workflow.md
│   ├── implementation.md
│   └── tools-search.md
└── conditional/                   (injected based on prompt keywords)
    ├── design-principles.md       (implement, refactor keywords)
    ├── testing-patterns.md        (test, tdd, coverage keywords)
    ├── code-review.md             (review, pr, diff keywords)
    ├── refactoring.md             (refactor, rename, migrate keywords)
    └── tools-skills.md            (implement, refactor, verify keywords)
```

### How it works

1. **SessionStart hook** — `cat .claude/core/*.md` loads all core files into context on every session start, resume, clear, or compact.
2. **UserPromptSubmit hook** — `classify-prompt.sh` reads the user's prompt, matches keywords case-insensitively, and injects only the relevant conditional files. A prompt like "add a new feature" triggers design-principles, testing-patterns, refactoring, and tools-skills. A prompt like "review the diff" triggers only code-review.

This keeps the agent's context lean — instructions are injected only when relevant, rather than loading everything upfront.

### Setting up in your project

1. Copy `.claude/` into your project root.
2. Edit `.claude/core/project-context.md` with your project's tech stack and dependencies.
3. Edit `.claude/core/workflow.md` verification gate with your project's actual commands.
4. Customise keyword triggers in `classify-prompt.sh` if needed.
5. Add a `CLAUDE.md` with `#import` directives pointing to your core files.

## Static Guidelines (Alternative Approach)

If you prefer a single-file approach without hooks:

1. Copy `AGENT_GUIDELINES.general.md` as your starting point.
2. Pick (or create) a language-specific file for your stack.
3. Merge the two into a single `CLAUDE.md` and drop it into your project root.
4. Customise further with project-specific rules (repo paths, CI pipelines, team conventions).

See the `example` files for what the merged result looks like.

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE.md) file for details.

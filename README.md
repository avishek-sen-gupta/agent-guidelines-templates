# AI Engineering Primitives

Reusable context injection infrastructure and guidelines for AI coding agents, with a focus on Claude Code.

## Quick Start

```bash
# Bootstrap context injection into your project
./setup.sh /path/to/your-repo

# Then customise:
# 1. .claude/core/project-context.md  — your language, purpose, dependencies
# 2. .claude/core/workflow.md          — your formatter, linter, test runner
# 3. CLAUDE.md                         — your project name
```

To enable keyword-based conditional injection, install [context-injector](https://github.com/avishek-sen-gupta/context-injector) and configure it to point at the `.claude/conditional/` directory.

## Repository Structure

```
.claude/                           # Copy-ready hook infrastructure
├── core/                          # Always loaded on session start
│   ├── project-context.md         #   Language, purpose, dependencies (template)
│   ├── workflow.md                #   Phases, verification gate, commit rules
│   ├── implementation.md          #   Scoping, interaction style, Talisman
│   └── tools-search.md            #   ast-grep, code-review-graph guidance
├── conditional/                   # Injected based on prompt keywords
│   ├── design-principles.md       #   (implement, refactor keywords)
│   ├── testing-patterns.md        #   (test, tdd, coverage keywords)
│   ├── code-review.md             #   (review, pr, diff keywords)
│   ├── refactoring.md             #   (refactor, rename, migrate keywords)
│   └── tools-skills.md            #   (implement, refactor, verify keywords)
├── hooks/                         # Git hooks (pre-commit verification gate)
│   └── pre-commit                 #   Talisman + Black + import-linter + pytest
└── skills/                        # Reusable custom skills
    ├── audit-asserts/SKILL.md
    ├── documentation/SKILL.md
    └── migration-planner/SKILL.md

guidelines/                        # Reference material (not copied by setup.sh)
├── AGENT_GUIDELINES.general.md    #   Language-agnostic principles
├── AGENT_GUIDELINES.python.md     #   Python-specific rules
├── AGENT_GUIDELINES.java.md       #   Java-specific rules
├── AGENT_GUIDELINES.example.python.md  # Merged example (general + Python)
└── AGENT_GUIDELINES.example.java.md    # Merged example (general + Java)

CLAUDE.md                          # Thin #import file (copied by setup.sh)
PHILOSOPHY.md                      # Core philosophy (immutable)
setup.sh                           # Bootstraps .claude/ into a target repo
```

## How It Works

### Two-layer context injection

1. **SessionStart hook** — `cat .claude/core/*.md` loads all core files into context on every session start, resume, clear, or compact.

2. **UserPromptSubmit hook** — a keyword classifier reads the user's prompt, matches keywords case-insensitively, and injects only the relevant conditional files from `.claude/conditional/`. A prompt like "add a new feature" triggers design-principles, testing-patterns, refactoring, and tools-skills. A prompt like "review the diff" triggers only code-review.

This keeps the agent's context lean — instructions are injected only when relevant.

> **Note:** The `settings.json` and `classify-prompt.sh` hook scripts that wire up this two-layer injection are provided by the [context-injector](https://github.com/avishek-sen-gupta/context-injector) project. Install that separately and point it at the `.claude/conditional/` directory in this repo.

### Keyword triggers

| Category | Files injected | Trigger keywords |
|----------|---------------|-----------------|
| implement | design-principles, testing-patterns, refactoring, tools-skills | implement, add, build, create, fix, feature, bug, write, migrate, hook, extend... |
| test | testing-patterns | test, tdd, assert, coverage, xfail, fixture, "integration test"... |
| refactor | design-principles, refactoring, tools-skills | refactor, rename, extract, split, merge, simplify, restructure... |
| review | code-review | review, pr, diff, check, feedback, critique, approve |
| verify | testing-patterns, tools-skills | verify, audit, scan, lint, validate, ensure, gate... |

### Static guidelines (alternative)

If you prefer a single-file approach without hooks:

1. Copy `guidelines/AGENT_GUIDELINES.general.md` as your starting point.
2. Pick (or create) a language-specific file for your stack.
3. Merge the two into a single `CLAUDE.md` and drop it into your project root.

See the `example` files in `guidelines/` for what the merged result looks like.

## Philosophy

See [PHILOSOPHY.md](PHILOSOPHY.md) — engineer-owned, toolkit-first, anti-vendor, infrastructure-neutral.

## License

MIT — see [LICENSE.md](LICENSE.md).

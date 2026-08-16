# AI Engineering Primitives

Reusable guidelines for AI coding agents, with a focus on Claude Code.

Guidance is cut into atomic topic files. A thin `CLAUDE.md` `#import`s the ones you want, so a project chooses its own subset rather than inheriting one monolithic document.

## Quick Start

```bash
# From inside the project you want to set up
cd /path/to/your-repo && /path/to/agent-guidelines-templates/setup.sh

# ...or name the target explicitly, and bring the custom skills along too
./setup.sh /path/to/your-repo --with-skills

# Then customise:
# 1. guidelines/project-context.md  — your language, purpose, dependencies
# 2. guidelines/workflow.md         — your formatter, type checker, linter, test runner
# 3. CLAUDE.md                      — your project name, and which topics to import
```

For keyword-based conditional injection — loading a topic only when the prompt calls for it — install [context-injector](https://github.com/avishek-sen-gupta/context-injector) and point it at your `guidelines/` directory.

## Repository Structure

```
guidelines/                        # Atomic topic files — the source of truth
├── project-context.md             #   Language, purpose, dependencies (fill-in template)
├── guardrails.md                  #   Non-negotiables: no gold plating, full typing, text-as-boundary
├── workflow.md                    #   Phases, complexity classification, verification gate, commits
├── design-principles.md           #   What to reach for before writing new code
├── programming-patterns.md        #   Code style, types and values, architecture
├── testing.md                     #   TDD, unit vs integration, assertion quality
├── refactoring.md                 #   Primitive-to-type migration, working across a codebase
├── code-review.md                 #   Self-review checklist, severity ladder
├── interaction-style.md           #   Response shape, interruptions, common mistakes
├── code-search-tools.md           #   ast-grep, knowledge graph, skills and agents
├── data-security.md               #   External codebase leakage, Talisman
│
│                                  # Language layers (not copied by setup.sh)
├── AGENT_GUIDELINES.python.md     #   Python-specific rules
└── AGENT_GUIDELINES.java.md       #   Java-specific rules

skills/                            # Reusable custom skills (copy into your own .claude/skills/)
├── audit-asserts/SKILL.md
├── documentation/SKILL.md
└── migration-planner/SKILL.md

CLAUDE.md                          # Thin #import file (copied by setup.sh)
PHILOSOPHY.md                      # Core philosophy (immutable)
setup.sh                           # Bootstraps the guideline set into a target repo
```

## How It Works

### Composition

`CLAUDE.md` is a list of `#import` lines and nothing else:

```markdown
# My Project — Agent Instructions

#import guidelines/project-context.md
#import guidelines/guardrails.md
#import guidelines/workflow.md
```

Claude Code resolves the imports on session start. Drop a line to drop a topic — a docs-only repo has no use for `programming-patterns.md`, and a repo with no external code under analysis has no use for `data-security.md`.

### Conditional injection (optional)

Because each topic is its own file, [context-injector](https://github.com/avishek-sen-gupta/context-injector) can load them on demand instead: a `UserPromptSubmit` hook matches prompt keywords and injects only the relevant files. Keep the always-on topics in `CLAUDE.md` and let the injector handle the rest.

Suggested mapping:

| Category | Topics injected | Trigger keywords |
|----------|----------------|-----------------|
| implement | design-principles, programming-patterns, testing, refactoring | implement, add, build, create, fix, feature, bug, write, migrate, extend... |
| test | testing | test, tdd, assert, coverage, xfail, fixture, "integration test"... |
| refactor | design-principles, refactoring, code-search-tools | refactor, rename, extract, split, merge, simplify, restructure... |
| review | code-review | review, pr, diff, check, feedback, critique, approve |
| verify | testing, workflow | verify, audit, scan, lint, validate, ensure, gate... |

### Language layers

The topic files are language-agnostic. `AGENT_GUIDELINES.python.md` and `AGENT_GUIDELINES.java.md` hold only the delta for a given stack — the strict type checker's actual flags, the real serialisation library, the idiomatic collection types.

To use one, copy it into your project's `guidelines/` directory alongside the topics and add it to the `#import` list. If you'd rather have a single document than a directory of topics, concatenate the files you want in import order — the topic split is for composition, not something the agent depends on.

## Philosophy

See [PHILOSOPHY.md](PHILOSOPHY.md) — engineer-owned, toolkit-first, anti-vendor, infrastructure-neutral.

## License

MIT — see [LICENSE.md](LICENSE.md).

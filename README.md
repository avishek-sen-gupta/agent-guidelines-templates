# AI Engineering Primitives

Reusable guidelines for AI coding agents, with a focus on Claude Code.

Guidance is cut into atomic topic files. A thin `CLAUDE.md` `#import`s the ones you want, so a project chooses its own subset rather than inheriting one monolithic document.

## Quick Start

```bash
# From inside the project you want to set up
cd /path/to/your-repo && /path/to/agent-guidelines-templates/setup.sh

# ...or name the target explicitly, add a language layer, and bring the skills along
./setup.sh /path/to/your-repo --lang java --with-skills

# Then customise:
# 1. guidelines/project-context.md  — your language, purpose, dependencies
# 2. guidelines/workflow.md         — your formatter, type checker, linter, test runner
#                                     (a language layer supplies these already)
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
└── lang/                             # Language layers (installed by --lang)
    ├── java/                         #   Filenames mirror the core topics above
    │   ├── guardrails.md             #     Object banned, -Werror, Jackson
    │   ├── workflow.md               #     Gradle wrapper, spotlessApply
    │   ├── programming-patterns.md   #     records, sealed interfaces, var
    │   ├── testing.md                #     JUnit 5, AssertJ, @TempDir
    │   ├── refactoring.md            #     instanceof and orElse(null) fallbacks
    │   └── project-context.md        #     Suggested Java stack
    └── python/
        ├── guardrails.md             #     Any banned, Pyright strict, Pydantic
        ├── workflow.md               #     uv run, black, pyright, scratchpad
        ├── programming-patterns.md   #     frozen dataclasses, collections.abc
        ├── testing.md                #     pytest, tmp_path, xfail
        ├── refactoring.md            #     isinstance and `or None` fallbacks
        └── project-context.md        #     Suggested Python stack

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

Suggested mapping. Because overlay filenames mirror core filenames, each category injects the core topic and its `lang/<language>/` counterpart as one unit:

| Category | Topics injected | Trigger keywords |
|----------|----------------|-----------------|
| implement | design-principles, programming-patterns, testing, refactoring | implement, add, build, create, fix, feature, bug, write, migrate, extend... |
| test | testing | test, tdd, assert, coverage, xfail, fixture, "integration test"... |
| refactor | design-principles, refactoring, code-search-tools | refactor, rename, extract, split, merge, simplify, restructure... |
| review | code-review | review, pr, diff, check, feedback, critique, approve |
| verify | testing, workflow | verify, audit, scan, lint, validate, ensure, gate... |

### Language layers

The topic files are language-agnostic. `lang/<language>/` holds only the delta for a given stack — the strict type checker's actual flags, the real serialisation library, the idiomatic collection types.

**Every overlay filename mirrors a core topic filename.** `lang/java/testing.md` specialises `testing.md` and nothing else. Four rules keep the layers from collapsing into each other:

1. **Core states the rule and its rationale in neutral terms.** Core never names a language token, a library, or a CLI command. `guardrails.md` says "the language's *any* type is banned", not `Any`.
2. **An overlay does exactly one of two things**: bind a neutral rule to a concrete name (`the language's "any"` → `Object`, → `Any`), or add a rule that exists only because the language has that feature (sealed interfaces, `frozen=True`).
3. **An overlay never restates a core rule it doesn't specialise.** The test: delete the concrete binding from the line. If what remains reads like core, delete the line.
4. **No overlay without a core parent.** Wanting a new overlay topic means the corresponding core rule is missing — write that first.

`setup.sh --lang java` installs the layer and generates a `CLAUDE.md` that imports each overlay immediately after the topic it specialises, so the delta reads next to the rule it modifies:

```markdown
#import guidelines/testing.md
#import guidelines/lang/java/testing.md
```

If you'd rather have a single document than a directory of topics, concatenate the files in import order — the topic split is for composition, not something the agent depends on.

## Philosophy

See [PHILOSOPHY.md](PHILOSOPHY.md) — engineer-owned, toolkit-first, anti-vendor, infrastructure-neutral.

## License

MIT — see [LICENSE.md](LICENSE.md).

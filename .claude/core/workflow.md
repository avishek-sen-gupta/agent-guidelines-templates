## Workflow

### Phases (mandatory, in order)

Every non-trivial task goes through these phases. Do not skip. Do not start implementing before completing brainstorm.

1. **Brainstorm** — Read the relevant code. Check how the existing system handles similar cases. Identify at least two approaches and their trade-offs. Ask: "does the system already have infrastructure for this?" Consider whether an open-source project already solves the problem.
2. **Plan** — Choose an approach. For features spanning multiple modules, identify independently-committable units and their order. For Heavy tasks, write the design down before proceeding.
3. **Test first** — Write failing tests that define the expected behavior. No implementation code until at least one test exists.
4. **Implement** — Write the minimum code to make the tests pass.
5. **Self-review** — Before running the verification gate, review your own diff (`git diff`). Check against the Design Principles and Programming Patterns sections. Look for: workaround guards, mutation in loops, missing test coverage, weak assertions, leaked abstractions, stale docs.
6. **Verify** — Run the full verification gate (see below). All checks must pass.
7. **Commit** — One logical unit per commit. Push to remote.

When asked to audit or show issues, only report findings — do not fix unless explicitly asked.

### Complexity classification

Classify before starting. This determines how much ceremony is needed.

- **Light** (< 50 lines, single file, no new abstractions) — brief brainstorm. Example: adding an entry to a dispatch table.
- **Standard** (50–300 lines, 2–5 files, follows existing patterns) — brainstorm identifies the pattern being followed.
- **Heavy** (300+ lines, new abstractions, multiple subsystems) — brainstorm must produce a written design with trade-offs before any code. Break into independently-committable units. Do not attempt in a single pass. Re-read actual code before each phase — design documents can anchor you to a flawed model.

### Verification gate

Run all checks before every commit. Adapt these to your project's tooling:

```bash
# formatting (e.g., black, prettier, google-java-format)
<formatter> .

# architectural contracts (e.g., import-linter, eslint boundaries)
<linter>

# ALL tests (unit + integration)
<test-runner> tests/
```

Do not commit if any check fails. Fix, then re-run all checks. Non-negotiable.

### Commits and state

- One logical unit per commit. Each commit must have its own tests.
- Push to `main` unless otherwise instructed.
- Update README and other living docs (ADRs, design docs, etc.) if the diff changes public behavior, adds features, or modifies architecture. This is part of the commit, not a follow-up.
- Leave the working directory clean. No uncommitted files.
- Prefer a committed partial result over an uncommitted complete attempt. If a session may end, commit what's done with a `WIP:` prefix and file an issue for the remainder.
- When generating output directories, attach a timestamp and technique used.

### Documentation

- Record salient architectural decisions as timestamped ADRs.
- Update living documentation (README, design docs, etc.) instead of letting them go stale.

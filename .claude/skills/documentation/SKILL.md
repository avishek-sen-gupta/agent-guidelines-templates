---
name: documentation
description: Use when the user invokes /documentation or asks to update project docs. Updates README, ADRs, and living documentation to reflect current codebase state.
---

# Documentation Update

Update all living project docs to reflect current codebase state.

## Docs to Update

Work through these in order. For each: read the current doc, read the relevant source, then update only what has changed.

### 1. README.md (repo root)
- Feature list and capabilities
- Project structure and directory layout
- Setup instructions and prerequisites
- Any new features or major changes since last update

### 2. ADRs (Architectural Decision Records)
- Add a new timestamped ADR for any architectural change not yet recorded
- Check git log since the last ADR date for clues: `git log --oneline --since="<last ADR date>"`
- ADR format: `## YYYY-MM-DD — Title` followed by Context, Decision, Consequences
- Store in `docs/` or project-appropriate location

### 3. Other living docs
- Scan for any `.md` files in `docs/` that reference code structure or features
- Update only sections where content is stale relative to current code

## Rules

- **Read before writing.** Always read the current doc before editing.
- **Minimal diffs.** Only update sections where content is stale. Don't rewrite for style.
- **Source of truth is code.** Verify claims against source before writing them.
- **No new files.** Update existing docs; do not create new ones unless adding a new ADR entry.

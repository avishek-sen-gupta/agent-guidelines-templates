#!/bin/bash
# setup.sh — Bootstrap the Claude Code context injection infrastructure into a target repo.
#
# Usage:
#   ./setup.sh /path/to/target-repo
#
# What it does:
#   1. Copies .claude/ (core, conditional, hooks, classifier) into the target repo
#   2. Copies CLAUDE.md (thin #import file) into the target repo root
#   3. Reminds you to customise project-context.md and the verification gate

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_CLAUDE="$SCRIPT_DIR/.claude"
SOURCE_CLAUDE_MD="$SCRIPT_DIR/CLAUDE.md"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <target-repo-path>"
  exit 1
fi

TARGET="$1"

if [ ! -d "$TARGET" ]; then
  echo "Error: $TARGET is not a directory"
  exit 1
fi

TARGET_CLAUDE="$TARGET/.claude"

# Copy .claude/ directory (core, conditional, classify-prompt.sh, settings.json)
# Exclude settings.local.json (machine-specific), skills (project-specific), worktrees
echo "Copying .claude/ infrastructure..."
mkdir -p "$TARGET_CLAUDE/core" "$TARGET_CLAUDE/conditional"

cp "$SOURCE_CLAUDE/settings.json" "$TARGET_CLAUDE/settings.json"
cp "$SOURCE_CLAUDE/classify-prompt.sh" "$TARGET_CLAUDE/classify-prompt.sh"
chmod +x "$TARGET_CLAUDE/classify-prompt.sh"

for f in "$SOURCE_CLAUDE/core/"*.md; do
  cp "$f" "$TARGET_CLAUDE/core/"
done

for f in "$SOURCE_CLAUDE/conditional/"*.md; do
  cp "$f" "$TARGET_CLAUDE/conditional/"
done

# Copy CLAUDE.md
echo "Copying CLAUDE.md..."
cp "$SOURCE_CLAUDE_MD" "$TARGET/CLAUDE.md"

echo ""
echo "Done. Next steps:"
echo ""
echo "  1. Edit $TARGET_CLAUDE/core/project-context.md"
echo "     Fill in your project's language, purpose, and dependencies."
echo ""
echo "  2. Edit $TARGET_CLAUDE/core/workflow.md"
echo "     Replace <formatter>, <linter>, <test-runner> in the verification gate"
echo "     with your project's actual commands."
echo ""
echo "  3. (Optional) Edit $TARGET_CLAUDE/conditional/ files"
echo "     Customise design principles, testing patterns, etc. for your project."
echo ""
echo "  4. (Optional) Edit $TARGET_CLAUDE/classify-prompt.sh"
echo "     Add or remove keyword triggers for your workflow."
echo ""
echo "  5. Update the project name in $TARGET/CLAUDE.md"
echo "     Change 'AI Engineering Primitives' to your project name."

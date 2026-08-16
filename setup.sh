#!/bin/bash
# setup.sh — Bootstrap the agent guideline set into a target repo.
#
# Usage:
#   ./setup.sh /path/to/target-repo [--with-skills]
#   ./setup.sh --with-skills /path/to/target-repo
#
# What it does:
#   1. Copies the atomic guideline topic files into <target>/guidelines/
#   2. Backs up any existing CLAUDE.md to CLAUDE.md.old, then copies ours in
#   3. Optionally copies skills/ into <target>/.claude/skills/
#   4. Reminds you to customise project-context.md and the verification gate

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_GUIDELINES="$SCRIPT_DIR/guidelines"
SOURCE_SKILLS="$SCRIPT_DIR/skills"
SOURCE_CLAUDE_MD="$SCRIPT_DIR/CLAUDE.md"

usage() {
  cat <<EOF
Usage: $0 [target-repo-path] [--with-skills]

Installs this repo's agent guidelines into another repository.

Arguments:
  [target-repo-path]  The repository that should receive the guidelines.
                      Defaults to the current directory, so you can cd into
                      your project and run this with no arguments.
                      Order-independent with the options.

Options:
  --with-skills       Also install the custom skills (audit-asserts,
                      documentation, migration-planner).
  -h, --help          Show this message.

Writes into <target-repo-path>:
  guidelines/*.md     the guideline topic files
  CLAUDE.md           thin #import file listing those topics; any existing
                      CLAUDE.md is first backed up to CLAUDE.md.old
  .claude/skills/     the custom skills (only with --with-skills)

Examples:
  cd ~/code/my-project && $0
  $0 ~/code/my-project --with-skills
EOF
}

TARGET=""
WITH_SKILLS=0

for arg in "$@"; do
  case "$arg" in
    --with-skills)
      WITH_SKILLS=1
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    -*)
      echo "Error: unknown option $arg"
      usage
      exit 1
      ;;
    *)
      if [ -n "$TARGET" ]; then
        echo "Error: more than one target path given ($TARGET, $arg)"
        exit 1
      fi
      TARGET="$arg"
      ;;
  esac
done

if [ -z "$TARGET" ]; then
  TARGET="$PWD"
fi

if [ ! -d "$TARGET" ]; then
  echo "Error: $TARGET is not a directory"
  exit 1
fi

TARGET="$(cd "$TARGET" && pwd)"

if [ "$TARGET" = "$SCRIPT_DIR" ]; then
  echo "Error: $TARGET is this template repo itself."
  echo "       cd into the project you want to set up, or pass its path."
  exit 1
fi

echo "Installing into $TARGET"

TARGET_GUIDELINES="$TARGET/guidelines"

# Copy the atomic topic files. The AGENT_GUIDELINES.* files are the language
# layers — pick one by hand, so they are deliberately not copied.
echo "Copying guideline topic files..."
mkdir -p "$TARGET_GUIDELINES"

for f in "$SOURCE_GUIDELINES"/*.md; do
  base="$(basename "$f")"
  case "$base" in
    AGENT_GUIDELINES.*) continue ;;
  esac
  cp "$f" "$TARGET_GUIDELINES/"
done

if [ -f "$TARGET/CLAUDE.md" ]; then
  echo "Backing up existing CLAUDE.md to CLAUDE.md.old..."
  cp "$TARGET/CLAUDE.md" "$TARGET/CLAUDE.md.old"
fi

echo "Copying CLAUDE.md..."
cp "$SOURCE_CLAUDE_MD" "$TARGET/CLAUDE.md"

if [ "$WITH_SKILLS" -eq 1 ]; then
  echo "Copying skills..."
  mkdir -p "$TARGET/.claude/skills"
  cp -R "$SOURCE_SKILLS/." "$TARGET/.claude/skills/"
fi

echo ""
echo "Done. Next steps:"
echo ""
echo "  1. Edit $TARGET_GUIDELINES/project-context.md"
echo "     Fill in your project's language, purpose, and dependencies."
echo ""
echo "  2. Edit $TARGET_GUIDELINES/workflow.md"
echo "     Replace <formatter>, <type-checker>, <linter>, <test-runner> in the"
echo "     verification gate with your project's actual commands."
echo ""
echo "  3. Trim the #import list in $TARGET/CLAUDE.md"
echo "     Drop topics that don't apply to your project."
echo ""
echo "  4. Update the project name in $TARGET/CLAUDE.md"
echo "     Change 'AI Engineering Primitives' to your project name."
echo ""
echo "  5. (Optional) Add a language layer"
echo "     Copy guidelines/AGENT_GUIDELINES.<language>.md from this repo into"
echo "     $TARGET_GUIDELINES/ and add it to the #import list."

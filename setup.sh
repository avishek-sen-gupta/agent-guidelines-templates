#!/bin/bash
# setup.sh — Bootstrap the agent guideline set into a target repo.
#
# Usage:
#   ./setup.sh /path/to/target-repo [--lang <language>] [--with-skills]
#   ./setup.sh --with-skills /path/to/target-repo
#
# What it does:
#   1. Copies the atomic guideline topic files into <target>/guidelines/
#   2. With --lang, copies guidelines/lang/<language>/ too and pairs each
#      overlay with its core topic in the generated CLAUDE.md
#   3. Backs up any existing CLAUDE.md to CLAUDE.md.old, then writes ours
#   4. Optionally copies skills/ into <target>/.claude/skills/
#   5. Reminds you to customise project-context.md and the verification gate

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_GUIDELINES="$SCRIPT_DIR/guidelines"
SOURCE_SKILLS="$SCRIPT_DIR/skills"
SOURCE_CLAUDE_MD="$SCRIPT_DIR/CLAUDE.md"

AVAILABLE_LANGS="$(cd "$SOURCE_GUIDELINES/lang" && ls -d */ 2>/dev/null | tr -d / | tr '\n' ' ')"

usage() {
  cat <<EOF
Usage: $0 [target-repo-path] [--lang <language>] [--with-skills]

Installs this repo's agent guidelines into another repository.

Arguments:
  [target-repo-path]  The repository that should receive the guidelines.
                      Defaults to the current directory, so you can cd into
                      your project and run this with no arguments.
                      Order-independent with the options.

Options:
  --lang <language>   Also install the language layer for <language> and
                      import each of its files after the core topic it
                      specialises. Available: $AVAILABLE_LANGS
  --with-skills       Also install the custom skills (audit-asserts,
                      documentation, migration-planner).
  -h, --help          Show this message.

Writes into <target-repo-path>:
  guidelines/*.md     the guideline topic files
  guidelines/lang/<language>/*.md
                      the language layer (only with --lang)
  CLAUDE.md           thin #import file listing those topics; any existing
                      CLAUDE.md is first backed up to CLAUDE.md.old
  .claude/skills/     the custom skills (only with --with-skills)

Examples:
  cd ~/code/my-project && $0
  $0 ~/code/my-project --lang java --with-skills
EOF
}

TARGET=""
WITH_SKILLS=0
LANG_LAYER=""
EXPECT_LANG=0

for arg in "$@"; do
  if [ "$EXPECT_LANG" -eq 1 ]; then
    LANG_LAYER="$arg"
    EXPECT_LANG=0
    continue
  fi
  case "$arg" in
    --with-skills)
      WITH_SKILLS=1
      ;;
    --lang)
      EXPECT_LANG=1
      ;;
    --lang=*)
      LANG_LAYER="${arg#--lang=}"
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

if [ "$EXPECT_LANG" -eq 1 ]; then
  echo "Error: --lang needs a language. Available: $AVAILABLE_LANGS"
  exit 1
fi

if [ -n "$LANG_LAYER" ] && [ ! -d "$SOURCE_GUIDELINES/lang/$LANG_LAYER" ]; then
  echo "Error: no language layer for '$LANG_LAYER'. Available: $AVAILABLE_LANGS"
  exit 1
fi

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

# Copy the language-agnostic topic files. The lang/ subdirectory is a layer,
# installed only when --lang asks for it.
echo "Copying guideline topic files..."
mkdir -p "$TARGET_GUIDELINES"

for f in "$SOURCE_GUIDELINES"/*.md; do
  cp "$f" "$TARGET_GUIDELINES/"
done

if [ -n "$LANG_LAYER" ]; then
  echo "Copying the $LANG_LAYER language layer..."
  mkdir -p "$TARGET_GUIDELINES/lang/$LANG_LAYER"
  cp "$SOURCE_GUIDELINES/lang/$LANG_LAYER"/*.md "$TARGET_GUIDELINES/lang/$LANG_LAYER/"
fi

if [ -f "$TARGET/CLAUDE.md" ]; then
  echo "Backing up existing CLAUDE.md to CLAUDE.md.old..."
  cp "$TARGET/CLAUDE.md" "$TARGET/CLAUDE.md.old"
fi

# CLAUDE.md is the single source of the topic list. Each core import is echoed
# through unchanged; where the chosen layer specialises that topic, its import
# follows immediately, so the delta reads next to the rule it modifies.
echo "Writing CLAUDE.md..."
: >"$TARGET/CLAUDE.md"
while IFS= read -r line || [ -n "$line" ]; do
  printf '%s\n' "$line" >>"$TARGET/CLAUDE.md"
  case "$line" in
    '#import guidelines/'*.md)
      [ -n "$LANG_LAYER" ] || continue
      topic="${line#\#import guidelines/}"
      overlay="lang/$LANG_LAYER/$topic"
      if [ -f "$SOURCE_GUIDELINES/$overlay" ]; then
        printf '#import guidelines/%s\n' "$overlay" >>"$TARGET/CLAUDE.md"
      fi
      ;;
  esac
done <"$SOURCE_CLAUDE_MD"

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
if [ -n "$LANG_LAYER" ]; then
  echo "     The $LANG_LAYER layer suggests defaults in"
  echo "     $TARGET_GUIDELINES/lang/$LANG_LAYER/project-context.md."
  echo ""
  echo "  2. Check $TARGET_GUIDELINES/lang/$LANG_LAYER/workflow.md"
  echo "     It supplies the verification gate commands. Adjust if your build"
  echo "     tool differs from the default."
else
  echo ""
  echo "  2. Edit $TARGET_GUIDELINES/workflow.md"
  echo "     Replace <formatter>, <type-checker>, <linter>, <test-runner> in the"
  echo "     verification gate with your project's actual commands."
  echo ""
  echo "     Or re-run with --lang <language> to have a language layer supply them."
fi
echo ""
echo "  3. Trim the #import list in $TARGET/CLAUDE.md"
echo "     Drop topics that don't apply to your project."
echo ""
echo "  4. Update the project name in $TARGET/CLAUDE.md"
echo "     Change 'AI Engineering Primitives' to your project name."

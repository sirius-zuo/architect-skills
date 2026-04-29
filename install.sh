#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

install_to() {
  local target_dir="$1"
  mkdir -p "$target_dir"
  cp -r "$SCRIPT_DIR/architect-design-review" "$target_dir/"
  cp -r "$SCRIPT_DIR/architect-codebase-review" "$target_dir/"
  cp -r "$SCRIPT_DIR/architect-shared" "$target_dir/"
  echo "Installed to $target_dir"
  echo "  ✓ architect-design-review"
  echo "  ✓ architect-codebase-review"
  echo "  ✓ architect-shared"
}

AGENT="${1:-}"

case "$AGENT" in
  claude)
    install_to "$HOME/.claude/skills"
    echo ""
    echo "Claude Code: add this line to ~/.claude/CLAUDE.md:"
    echo ""
    echo "  After superpowers:brainstorming writes and the user approves the spec,"
    echo "  always invoke architect-design-review before invoking writing-plans."
    ;;
  "")
    echo "Usage: ./install.sh [claude|<path>]"
    echo ""
    echo "  claude     Install to ~/.claude/skills/ (Claude Code global)"
    echo "  <path>     Install to a custom path (e.g. .claude/skills for project-local)"
    echo ""
    echo "For Cursor, Windsurf, Copilot, Codex CLI, and Gemini CLI, see README.md"
    echo "for the manual cat commands that inline all skill content into a single file."
    ;;
  *)
    install_to "$AGENT"
    ;;
esac

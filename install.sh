#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

detect_agent() {
  if command -v claude &>/dev/null && [ -d "$HOME/.claude" ]; then
    echo "claude"
  elif [ -d "$HOME/.agents" ]; then
    echo "codex"
  else
    echo "unknown"
  fi
}

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

AGENT="${1:-$(detect_agent)}"

case "$AGENT" in
  claude)
    install_to "$HOME/.claude/skills"
    echo ""
    echo "Claude Code: add this line to ~/.claude/CLAUDE.md:"
    echo ""
    echo "  After superpowers:brainstorming writes and the user approves the spec,"
    echo "  always invoke architect-design-review before invoking writing-plans."
    ;;
  codex)
    install_to "$HOME/.agents/skills"
    echo ""
    echo "Codex: add the equivalent workflow hook to your agent config."
    ;;
  *)
    echo "Usage: ./install.sh [claude|codex|<path>]"
    echo ""
    echo "  claude     Install to ~/.claude/skills/ (Claude Code)"
    echo "  codex      Install to ~/.agents/skills/ (Codex)"
    echo "  <path>     Install to a custom path"
    ;;
esac

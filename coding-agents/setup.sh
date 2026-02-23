#!/usr/bin/env bash
set -euo pipefail

TOOL="${1:-all}"
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  echo "Usage: $(basename "$0") [opencode|claude|all]"
  exit 1
}

link() {
  local src="$1"
  local dst="$2"

  if git -C "$DOTFILES" check-ignore -q "$src" 2>/dev/null; then
    echo "  skip (gitignored): $(basename "$src")"
    return
  fi

  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "  skip: $dst already exists and is not a symlink"
    return
  fi

  ln -sf "$src" "$dst"
  echo "  linked: $dst -> $src"
}

setup_opencode() {
  local target="$HOME/.config/opencode"

  if [ -L "$target" ]; then
    rm "$target"
    echo "  removed existing symlink: $target"
  fi

  mkdir -p "$target"
  echo "Configuring opencode -> $target"

  for item in "$DOTFILES/opencode"/*; do
    link "$item" "$target/$(basename "$item")"
  done

  link "$DOTFILES/skills" "$target/skills"
}

setup_claude() {
  local target="$HOME/.claude"
  mkdir -p "$target"
  echo "Configuring claude -> $target"

  for item in "$DOTFILES/claude"/*; do
    link "$item" "$target/$(basename "$item")"
  done

  link "$DOTFILES/skills" "$target/skills"
}

case "$TOOL" in
  opencode) setup_opencode ;;
  claude)   setup_claude ;;
  all)
      setup_opencode 
      setup_claude ;;
  *)        usage ;;
esac

echo "Done."

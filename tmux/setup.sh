#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
TARGET_DIR="$CONFIG_HOME/tmux"
TARGET="$TARGET_DIR/tmux.conf"

link() {
  local src="$1"
  local dst="$2"

  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "  skip: $dst already exists and is not a symlink"
    return
  fi

  ln -sf "$src" "$dst"
  echo "  linked: $dst -> $src"
}

echo "Configuring tmux -> $TARGET"
mkdir -p "$TARGET_DIR"
link "$DOTFILES/tmux.conf" "$TARGET"

echo "Done."

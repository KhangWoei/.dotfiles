#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
ZSH_DIR="$CONFIG_HOME/zsh"

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

echo "Configuring zsh -> $ZSH_DIR"
mkdir -p "$ZSH_DIR"

for item in "$DOTFILES"/*.zsh; do
  link "$item" "$ZSH_DIR/$(basename "$item")"
done

# Ensure ~/.zshrc sources main.zsh
ZSHRC="$HOME/.zshrc"
SOURCE_LINE="source \"$ZSH_DIR/main.zsh\""

if [ ! -f "$ZSHRC" ] || ! grep -qF "$SOURCE_LINE" "$ZSHRC"; then
  echo "$SOURCE_LINE" >> "$ZSHRC"
  echo "  updated: $ZSHRC to source main.zsh"
else
  echo "  skip: $ZSHRC already sources main.zsh"
fi

echo "Done."

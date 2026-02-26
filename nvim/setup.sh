#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
TARGET="$CONFIG_HOME/nvim"

echo "Configuring nvim -> $TARGET"

if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
  echo "  skip: $TARGET already exists and is not a symlink"
  exit 0
fi

ln -sfn "$DOTFILES" "$TARGET"
echo "  linked: $TARGET -> $DOTFILES"

echo "Done."

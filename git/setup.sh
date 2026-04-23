#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

DESTINATION="${XDG_CONFIG_HOME:-$HOME}"

echo "Configuring git -> $DESTINATION/.gitconfig"
link "$DOTFILES/.gitconfig" "$DESTINATION/.gitconfig"

echo "Done."

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

echo "Configuring git -> $HOME/.gitconfig"
link "$DOTFILES/.gitconfig" "$HOME/.gitconfig"

echo "Done."

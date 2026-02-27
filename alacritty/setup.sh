#!/usr/bin/env bash

DOTFILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link () {
  local src="$1"
  local dst="$2"

  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "  skip: $dst already exists and is not a symlink"
    return
  fi

  ln -sf "$src" "$dst"
  echo "  linked: $dst -> $src"
}

echo "Configuring alacritty -> $HOME/.config/alacritty/alacritty.toml"
link "$DOTFILE/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

echo "Done."

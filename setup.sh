#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUBDIRS=(nvim git coding-agents rider tmux)

usage() {
  echo "Usage: $(basename "$0") [$(IFS='|'; echo "${SUBDIRS[*]}")|all]"
  exit 1
}

run_setup() {
  local subdir="$1"
  local script="$DOTFILES/$subdir/setup.sh"

  if [ ! -f "$script" ]; then
    echo "  warning: no setup.sh found for '$subdir', skipping"
    return
  fi

  bash "$script"
}

ARG="${1:-all}"

case "$ARG" in
  all)
    for subdir in "${SUBDIRS[@]}"; do
      run_setup "$subdir"
    done
    ;;
  nvim|git|coding-agents|rider|tmux)
    run_setup "$ARG"
    ;;
  *)
    usage
    ;;
esac

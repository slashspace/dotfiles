#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
PACKAGES=(
  aerospace
  ghostty
  karabiner
  sketchybar
  starship
  zsh
)

usage() {
  cat <<'EOF'
Usage:
  stow-packages.sh --dry-run
  stow-packages.sh --apply
  stow-packages.sh --delete

Description:
  Safely manage the supported Stow packages for this dotfiles repo.
EOF
}

if [ $# -ne 1 ]; then
  usage
  exit 1
fi

case "$1" in
  --dry-run)
    stow -d "$DOTFILES_DIR" -t "$HOME" -nv "${PACKAGES[@]}"
    ;;
  --apply)
    stow -d "$DOTFILES_DIR" -t "$HOME" "${PACKAGES[@]}"
    ;;
  --delete)
    stow -d "$DOTFILES_DIR" -t "$HOME" -D "${PACKAGES[@]}"
    ;;
  *)
    usage
    exit 1
    ;;
esac

#!/bin/bash
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
# Source theme-generated colors (exported by sketchybar renderer)
if [[ -f "$DOTFILES_DIR/system/themes/generated/sketchybar-colors.sh" ]]; then
  source "$DOTFILES_DIR/system/themes/generated/sketchybar-colors.sh"
fi

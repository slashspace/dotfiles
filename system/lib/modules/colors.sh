#!/usr/bin/env bash

# Theme: last `dotfiles theme apply` (generated), else schema defaults
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
THEME_ENV_FILE="$DOTFILES_DIR/system/themes/generated/theme-env.sh"
if [[ -f "$THEME_ENV_FILE" ]]; then
  # shellcheck source=/dev/null
  source "$THEME_ENV_FILE"
else
  # First-boot fallback: load the default palette so shells always have THEME_*.
  set -a
  # shellcheck source=/dev/null
  source "$DOTFILES_DIR/system/themes/palettes/catppuccin-purple.sh"
  set +a
fi

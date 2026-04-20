#!/usr/bin/env bash

# Terminal ANSI colors (theme-independent)
boldGreen="\033[1;32m"
boldYellow="\033[1;33m"
boldRed="\033[1;31m"
boldPurple="\033[1;35m"
boldBlue="\033[1;34m"
noColor="\033[0m"

# Theme: last `dotfiles theme apply` (generated), else palette defaults
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
THEME_ENV_FILE="$DOTFILES_DIR/system/themes/generated/theme-env.sh"
if [[ -f "$THEME_ENV_FILE" ]]; then
  # shellcheck source=/dev/null
  source "$THEME_ENV_FILE"
else
  # shellcheck source=/dev/null
  source "$DOTFILES_DIR/system/themes/palette.sh"
  export THEME_SUCCESS_HEX="${THEME_GREEN:-#37f499}"
  export THEME_ERROR_HEX="${THEME_RED:-#f16c75}"
  export THEME_FOREGROUND_HEX="${THEME_TEXT:-#ffffff}"
  export THEME_BACKGROUND_HEX="${THEME_BASE:-#0D1116}"
fi

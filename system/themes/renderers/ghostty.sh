#!/bin/bash
# Renderer: Ghostty theme mapping
# Maps dotfiles theme names to Ghostty built-in theme names.

set -euo pipefail

GHOSTTY_CONFIG="$HOME/.config/ghostty/config"

if [[ ! -f "$GHOSTTY_CONFIG" ]]; then
  echo "Ghostty config not found: $GHOSTTY_CONFIG" >&2
  exit 0
fi

# Map dotfiles theme names to Ghostty built-in themes
case "${THEME_NAME:-}" in
  catppuccin-mocha)    ghostty_theme="catppuccin-mocha" ;;
  catppuccin-macchiato) ghostty_theme="catppuccin-macchiato" ;;
  dracula)             ghostty_theme="dracula" ;;
  gruvbox-dark)        ghostty_theme="gruvbox-dark" ;;
  tokyo-night)         ghostty_theme="tokyo-night" ;;
  kanagawa)            ghostty_theme="kanagawa" ;;
  nord)                ghostty_theme="nord" ;;
  rose-pine)           ghostty_theme="rose-pine" ;;
  everforest)          ghostty_theme="everforest" ;;
  solarized-dark)      ghostty_theme="solarized-dark" ;;
  retro-phosphor)      ghostty_theme="retro-phosphor" ;;
  *)                   ghostty_theme="catppuccin-mocha" ;;
esac

# Replace theme line in Ghostty config
if grep -q "^theme\s*=" "$GHOSTTY_CONFIG" 2>/dev/null; then
  sed -i '' "s|^theme\s*=.*|theme = $ghostty_theme|" "$GHOSTTY_CONFIG"
else
  # If no theme line exists, add one at the top
  sed -i '' "1i\\
theme = $ghostty_theme" "$GHOSTTY_CONFIG"
fi

echo "Set Ghostty theme: $ghostty_theme"

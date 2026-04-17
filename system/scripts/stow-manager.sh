#!/usr/bin/env bash
# Backward compatibility wrapper — delegates to 'dotfiles stow'
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
if command -v dotfiles &>/dev/null; then
  exec dotfiles stow "$@"
elif [[ -x "$DOTFILES_DIR/system/bin/dotfiles" ]]; then
  exec "$DOTFILES_DIR/system/bin/dotfiles" stow "$@"
else
  echo "Error: 'dotfiles' CLI not found. Please run 'dotfiles stow apply --core'." >&2
  exit 1
fi

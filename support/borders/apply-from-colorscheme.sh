#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

ACTIVE_FILE="$DOTFILES_DIR/support/colorscheme/active/active-colorscheme.sh"
AS_CONFIG="$DOTFILES_DIR/aerospace/.config/aerospace/aerospace.toml"

_die() { echo "borders-theme: $*" >&2; exit 1; }

command -v /opt/homebrew/bin/borders >/dev/null 2>&1 || _die "missing /opt/homebrew/bin/borders"
[ -f "$ACTIVE_FILE" ] || _die "missing $ACTIVE_FILE"

# shellcheck disable=SC1090
source "$ACTIVE_FILE"

hex="${linkarzu_color02:-}"
[[ "$hex" =~ ^#?[0-9a-fA-F]{6}$ ]] || _die "invalid linkarzu_color02='$hex'"
hex="${hex#\#}"
# macOS /bin/bash is often 3.2, so avoid ${var,,} lowercase substitution.
hex="$(printf '%s' "$hex" | tr '[:upper:]' '[:lower:]')"
active_argb="0xff${hex}"

# Keep inactive_color/width in sync with aerospace.toml when present
inactive_argb="0xffe1e3e4"
width="8.0"
if [ -f "$AS_CONFIG" ]; then
  if grep -q "inactive_color=" "$AS_CONFIG"; then
    inactive_argb="$(grep -Eo "inactive_color=0x[0-9a-fA-F]{8}" "$AS_CONFIG" | head -1 | cut -d= -f2 || true)"
    [ -n "$inactive_argb" ] || inactive_argb="0xffe1e3e4"
  fi
  if grep -q "width=" "$AS_CONFIG"; then
    width="$(grep -Eo "width=[0-9]+(\.[0-9]+)?" "$AS_CONFIG" | head -1 | cut -d= -f2 || true)"
    [ -n "$width" ] || width="8.0"
  fi
fi

# Restart borders with new colors
pkill -x borders >/dev/null 2>&1 || true
nohup /opt/homebrew/bin/borders "active_color=$active_argb" "inactive_color=$inactive_argb" "width=$width" >/dev/null 2>&1 &


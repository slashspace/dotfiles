#!/usr/bin/env bash
# Shared theme-application helper.
# Sourced by `dotfiles theme switch` (picker) and `dotfiles bootstrap`.

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
THEMES_DIR="$DOTFILES_DIR/system/themes"
GENERATED_DIR="$THEMES_DIR/generated"
CURRENT_FILE="$GENERATED_DIR/.current-theme"

# shellcheck source=./log.sh
source "$DOTFILES_DIR/system/lib/log.sh"
# shellcheck source=./reload.sh
source "$DOTFILES_DIR/system/lib/reload.sh"

# Run all renderers for a palette name.
# Usage: theme_apply <name>
theme_apply() {
  local theme_name="$1"
  local theme_file="$THEMES_DIR/palettes/${theme_name}.sh"

  if [[ ! -f "$theme_file" ]]; then
    log_error "Theme not found: $theme_name"
    return 1
  fi

  log_info "Applying theme: $theme_name"

  # shellcheck disable=SC1090
  set -a
  source "$theme_file"
  set +a
  mkdir -p "$GENERATED_DIR"
  export THEME_NAME="$theme_name"

  for renderer in "$THEMES_DIR"/renderers/*.sh; do
    if [[ "$(basename "$renderer")" == "borders.sh" ]]; then
      "$renderer" --apply
    else
      "$renderer"
    fi
  done

  # gitmux.conf must live at $HOME (gitmux has no XDG support)
  local gitmux_src="$GENERATED_DIR/gitmux.conf"
  if [[ -f "$gitmux_src" ]]; then
    local gitmux_dst="$HOME/.gitmux.conf"
    [[ -L "$gitmux_dst" ]] && rm -f "$gitmux_dst"
    install -m 0644 "$gitmux_src" "$gitmux_dst"
  fi

  echo "$theme_name" > "$CURRENT_FILE"

  reload_sketchybar
  reload_tmux
  reload_ghostty
  print_restart_hints

  log_ok "Theme '$theme_name' applied"
}

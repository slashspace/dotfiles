#!/usr/bin/env bash
# Reload helpers for the theme system.
#
# Each function reloads one tool to pick up new theme colors. They are safe to
# call when the tool isn't installed/running (no-op + return 0).
#
# Sourced by `dotfiles-theme` after rendering. Tested by re-applying a theme
# and observing live changes in the relevant app.

# shellcheck source=./log.sh
source "${DOTFILES_DIR:-$HOME/dotfiles}/system/lib/log.sh"

reload_sketchybar() {
  command -v sketchybar &>/dev/null || return 0
  log_step "Reloading sketchybar"
  sketchybar --reload 2>/dev/null || true
}

reload_ghostty() {
  command -v ghostty &>/dev/null || return 0
  log_step "Ghostty config updated (reload on next launch)"
}

# tmux / catppuccin requires clearing cached `set -ogqF` values before re-sourcing
# the plugin config — otherwise theme changes don't propagate to status modules.
reload_tmux() {
  command -v tmux &>/dev/null || return 0
  tmux has-session 2>/dev/null || return 0
  log_step "Reloading tmux colors"

  local generated="${DOTFILES_DIR:-$HOME/dotfiles}/system/themes/generated/tmux-colors.conf"
  tmux source-file "$generated" 2>/dev/null || true

  local opt
  for opt in \
    @catppuccin_directory_color \
    @catppuccin_gitmux_color \
    @catppuccin_date_time_color \
    @catppuccin_status_directory_icon_bg \
    @catppuccin_status_gitmux_icon_bg \
    @catppuccin_status_date_time_icon_bg \
    @catppuccin_status_directory_icon_fg \
    @catppuccin_status_gitmux_icon_fg \
    @catppuccin_status_date_time_icon_fg \
    @catppuccin_status_directory_text_fg \
    @catppuccin_status_gitmux_text_fg \
    @catppuccin_status_date_time_text_fg \
    @catppuccin_status_directory_text_bg \
    @catppuccin_status_gitmux_text_bg \
    @catppuccin_status_date_time_text_bg \
    @catppuccin_status_directory \
    @catppuccin_status_gitmux \
    @catppuccin_status_date_time; do
    tmux set -gu "$opt" 2>/dev/null || true
  done

  local catppuccin_root="$HOME/.config/tmux/plugins/tmux"
  [[ -f "$catppuccin_root/catppuccin_options_tmux.conf" ]] && \
    tmux source-file "$catppuccin_root/catppuccin_options_tmux.conf" 2>/dev/null || true
  [[ -f "$catppuccin_root/catppuccin_tmux.conf" ]] && \
    tmux source-file "$catppuccin_root/catppuccin_tmux.conf" 2>/dev/null || true

  local tmux_conf="${DOTFILES_DIR:-$HOME/dotfiles}/core/tmux/tmux.conf"
  [[ -f "$tmux_conf" ]] && tmux source-file "$tmux_conf" 2>/dev/null || true

  # Floax reads these from tmux global env; refresh on theme apply.
  tmux setenv -g FLOAX_BORDER_COLOR "${THEME_PRIMARY:-}" 2>/dev/null || true
  tmux setenv -g FLOAX_TEXT_COLOR "${THEME_FG:-}" 2>/dev/null || true
  tmux refresh-client -S 2>/dev/null || true
}

# Print the post-apply banner with manual-restart hints.
print_restart_hints() {
  log_step ""
  log_step "To see all changes take effect:"
  log_step "  - Restart shell: exec zsh"
  command -v tmux &>/dev/null && log_step "  - Restart tmux server: tmux kill-server"
  command -v ghostty &>/dev/null && log_step "  - Restart Ghostty (or open a new window)"
}

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

reload_borders() {
  command -v borders &>/dev/null || return 0
  local generated="${DOTFILES_DIR:-$HOME/dotfiles}/system/themes/generated/borders-colors.sh"
  [[ -f "$generated" ]] || return 0
  # shellcheck disable=SC1090
  source "$generated"
  /usr/bin/pkill -x borders >/dev/null 2>&1 || true
  nohup borders \
    "active_color=$BORDERS_ACTIVE_COLOR" \
    "inactive_color=$BORDERS_INACTIVE_COLOR" \
    "width=$BORDERS_WIDTH" >/dev/null 2>&1 &
  log_step "borders restarted"
}

reload_ghostty() {
  command -v ghostty &>/dev/null || return 0
  # Trigger Ghostty's built-in reload_config action via Cmd+Shift+,
  osascript -e '
    tell application "System Events"
      if exists process "Ghostty" then
        tell process "Ghostty"
          keystroke "," using {command down, shift down}
        end tell
      end if
    end tell' 2>/dev/null || true
  log_step "Ghostty config reloaded"
}

# tmux: re-source the generated colors file and the tmux conf so any catppuccin
# `set -ogqF` cached values get re-evaluated against the new THEME_* env. We
# avoid hard-coding the catppuccin option list by killing the catppuccin cache
# (an empty `set -gu` over a glob is not supported, so we let the plugin reload
# regenerate values via tmux source-file).
reload_tmux() {
  command -v tmux &>/dev/null || return 0
  tmux has-session 2>/dev/null || return 0
  log_step "Reloading tmux colors"

  local generated="${DOTFILES_DIR:-$HOME/dotfiles}/system/themes/generated/tmux-colors.conf"
  [[ -f "$generated" ]] && tmux source-file "$generated" 2>/dev/null || true

  # Re-export THEME_* into tmux's global env so plugins that read them via
  # `#{?#{e|>:...}}` style expansions see fresh values.
  local var
  for var in $(compgen -v THEME_); do
    tmux setenv -g "$var" "${!var}" 2>/dev/null || true
  done

  # catppuccin/tmux caches expanded status modules in @catppuccin_status_*.
  # Re-source whichever plugin path TPM installed so module badge colors rebuild
  # from the fresh @thm_* and @catppuccin_* values.
  local catppuccin_plugin
  for catppuccin_plugin in \
    "$HOME/.config/tmux/plugins/tmux/catppuccin.tmux" \
    "$HOME/.config/tmux/plugins/catppuccin-tmux/catppuccin.tmux"
  do
    [[ -f "$catppuccin_plugin" ]] && tmux source-file "$catppuccin_plugin" 2>/dev/null || true
  done

  # Re-source the user tmux.conf — this re-runs catppuccin's setup with the
  # refreshed THEME_* env, so we don't need to enumerate every @catppuccin_* opt.
  local tmux_conf="${DOTFILES_DIR:-$HOME/dotfiles}/core/tmux/tmux.conf"
  [[ -f "$tmux_conf" ]] && tmux source-file "$tmux_conf" 2>/dev/null || true

  # Source generated colors one last time so any theme-owned overrides of
  # @catppuccin_status_* survive tmux.conf / TPM reinitialization order.
  [[ -f "$generated" ]] && tmux source-file "$generated" 2>/dev/null || true

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

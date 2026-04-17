#!/usr/bin/env bash
# Dotfiles health check: verify dependencies, configs, and references
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
# shellcheck source=../lib/log.sh
source "$DOTFILES_DIR/system/lib/log.sh"

passed=0
failed=0

check() {
  local desc="$1"
  shift
  if "$@" &>/dev/null; then
    log_info "✓ $desc"
    ((passed++)) || true || true
  else
    log_error "✗ $desc"
    ((failed++)) || true
  fi
}

log_step "Checking dependencies"
check "Homebrew installed" command -v brew
check "GNU stow installed" command -v stow
check "zsh installed" command -v zsh
check "fzf installed" command -v fzf
check "fd installed" command -v fd
check "bat installed" command -v bat
check "nvim installed" command -v nvim
check "tmux installed" command -v tmux
check "sketchybar installed" command -v sketchybar

log_step "Checking config files"
check "~/.zshrc exists" test -f "$HOME/.zshrc"
check "~/.gitconfig exists" test -f "$HOME/.gitconfig"
check "~/.config/starship/starship.toml exists" test -f "$HOME/.config/starship/starship.toml"
check "~/.config/tmux/tmux.conf exists" test -f "$HOME/.config/tmux/tmux.conf"
check "~/.config/nvim/init.lua exists" test -f "$HOME/.config/nvim/init.lua"
check "~/.config/aerospace/aerospace.toml exists" test -f "$HOME/.config/aerospace/aerospace.toml"

log_step "Checking theme"
if [[ -f "$DOTFILES_DIR/system/themes/generated/.current-theme" ]]; then
  current_theme=$(cat "$DOTFILES_DIR/system/themes/generated/.current-theme")
  log_info "✓ Theme active: $current_theme"
  ((passed++)) || true
else
  log_warn "⚠ No theme applied"
fi

check "Generated starship theme exists" test -f "$DOTFILES_DIR/system/themes/generated/starship.toml"
check "Generated tmux theme exists" test -f "$DOTFILES_DIR/system/themes/generated/tmux-colors.conf"
check "Generated sketchybar theme exists" test -f "$DOTFILES_DIR/system/themes/generated/sketchybar-colors.sh"

log_step "Checking references"
check "trigger_workspace_sketchybar.sh exists" test -f "$DOTFILES_DIR/modules/sketchybar/plugins/trigger_workspace_sketchybar.sh"

log_step ""
if [[ $failed -eq 0 ]]; then
  log_info "All $passed checks passed"
else
  log_error "$failed check(s) failed out of $((passed + failed))"
  exit 1
fi

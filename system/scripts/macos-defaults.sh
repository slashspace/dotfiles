#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
source "$DOTFILES_DIR/system/lib/log.sh"

log_info "Setting macOS defaults"

# Keyboard: fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Dock: auto-hide, remove delay
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.5

# Disable Dock bouncing
defaults write com.apple.dock launchanim -bool false

# Show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Save screenshots to Downloads
defaults write com.apple.screencapture location -string "$HOME/Downloads"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

log_info "macOS defaults set. Some changes require logout/restart."

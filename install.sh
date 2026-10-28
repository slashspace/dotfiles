#!/usr/bin/env bash
# One-time setup: Homebrew, Stow, macOS defaults.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This installer supports macOS only."
  exit 1
fi

if ! xcode-select -p &>/dev/null; then
  xcode-select --install
  echo "Complete the Xcode install dialog and re-run this script."
  exit 0
fi

if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Installing packages..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

if command -v sheldon &>/dev/null; then
  echo "Locking Sheldon plugins..."
  sheldon lock --update
fi

echo "Stowing packages..."
stow -R -t "$HOME" \
  zsh git sheldon nvim starship herdr opencode \
  ghostty aerospace karabiner sketchybar borders zed \
  fastfetch atuin cliamp mactop

echo "Applying macOS defaults..."
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.5
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock tilesize -int 44
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mru-spaces -bool false

defaults write com.apple.menuextra.battery ShowPercent -string "YES"

defaults write com.apple.screencapture location -string "$HOME/Downloads"
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture include-date -bool true

killall Finder Dock SystemUIServer 2>/dev/null || true

echo "Done. Restart the shell with: exec zsh"

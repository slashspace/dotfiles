#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
cd "$DOTFILES_DIR"

source "$DOTFILES_DIR/system/lib/log.sh"
source "$DOTFILES_DIR/system/lib/platform.sh"
source "$DOTFILES_DIR/system/lib/package.sh"

log_info "Dotfiles bootstrap starting"
log_info "Repository: $DOTFILES_DIR"
log_info "Platform: $(platform_os) $(platform_arch)"

# 1. Xcode CLI
if ! xcode-select -p &>/dev/null; then
  log_info "Installing Xcode Command Line Tools"
  xcode-select --install
  log_warn "Complete the Xcode install dialog and re-run this script."
  exit 0
fi

# 2. Homebrew
if ! command -v brew &>/dev/null; then
  log_info "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# 3. Brew bundle
log_info "Installing packages"
pkg_bundle "$DOTFILES_DIR/system/packages/Brewfile"

# 4. Zinit
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  log_info "Installing zinit"
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# 5. Stow core
log_info "Stowing core packages"
"$DOTFILES_DIR/system/scripts/stow-manager.sh" apply --core

# 6. Apply default theme
log_info "Applying default theme (darkppuccin)"
"$DOTFILES_DIR/system/themes/bin/theme" apply darkppuccin

log_info "Bootstrap complete!"
log_info "Run these commands to finish setup:"
echo ""
echo "  # Install macOS modules (optional):"
echo "  $DOTFILES_DIR/system/scripts/install-modules.sh"
echo ""
echo "  # Set macOS defaults (optional):"
echo "  $DOTFILES_DIR/system/scripts/macos-defaults.sh"
echo ""
echo "  # Restart your shell:"
echo "  exec zsh"

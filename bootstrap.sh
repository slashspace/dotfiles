#!/usr/bin/env bash
# Bootstrap dotfiles: ensure Xcode CLI, Homebrew, brew bundle, then stow.
# Run from repo root: ./bootstrap.sh
# Or: DOTFILES_DIR=/path/to/repo bash /path/to/repo/bootstrap.sh

set -euo pipefail

REPO_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)}"
cd "$REPO_DIR"

echo "==> Dotfiles repo: $REPO_DIR"

# 1. Xcode Command Line Tools
if ! command -v xcode-select &>/dev/null || ! xcode-select -p &>/dev/null; then
  echo "==> Installing Xcode Command Line Tools (required for Homebrew)."
  echo "    A dialog may appear; complete the install and re-run this script."
  xcode-select --install
  exit 0
fi

# 2. Homebrew
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Ensure brew is on PATH for this session (Apple Silicon)
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# 3. Brew bundle
if [ -f "$REPO_DIR/Brewfile" ]; then
  echo "==> Running: brew bundle --file=$REPO_DIR/Brewfile"
  brew bundle --file="$REPO_DIR/Brewfile"
else
  echo "==> No Brewfile found at $REPO_DIR/Brewfile; skipping brew bundle."
fi

# 4. Oh My Zsh (optional; zsh/.zshrc may expect it)
if [ ! -d "${ZSH:-$HOME/.oh-my-zsh}" ]; then
  echo "==> Oh My Zsh not found. Install with: sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
  echo "    Re-run this script after installing if you use the zsh package."
fi

# 5. Stow (dry-run then apply)
if [ -f "$REPO_DIR/support/scripts/stow-packages.sh" ]; then
  echo "==> Stow dry-run:"
  DOTFILES_DIR="$REPO_DIR" bash "$REPO_DIR/support/scripts/stow-packages.sh" --dry-run
  echo "==> Stow apply:"
  DOTFILES_DIR="$REPO_DIR" bash "$REPO_DIR/support/scripts/stow-packages.sh" --apply
else
  echo "==> Stow packages (fallback):"
  stow -d "$REPO_DIR" -t "$HOME" -nv aerospace ghostty karabiner nvim sketchybar starship zsh
  stow -d "$REPO_DIR" -t "$HOME" aerospace ghostty karabiner nvim sketchybar starship zsh
fi

echo "==> Bootstrap done. Restart the shell or run: source ~/.zshrc"

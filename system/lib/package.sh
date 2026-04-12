#!/usr/bin/env bash
# Package management abstraction layer
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

# Detect current package manager
pkg_manager() {
  if command -v brew &>/dev/null; then
    echo "brew"
  elif command -v apt &>/dev/null; then
    echo "apt"
  elif command -v pacman &>/dev/null; then
    echo "pacman"
  else
    echo "unknown"
  fi
}

# Install a single package
pkg_install() {
  local pkg="$1"
  case "$(pkg_manager)" in
    brew)   brew install "$pkg" ;;
    apt)    sudo apt install -y "$pkg" ;;
    pacman) sudo pacman -S --noconfirm "$pkg" ;;
    *)      echo "Unsupported package manager" >&2; return 1 ;;
  esac
}

# Install all packages from a bundle file
pkg_bundle() {
  local bundle_file="$1"
  case "$(pkg_manager)" in
    brew)   brew bundle --file="$bundle_file" ;;
    apt)    xargs -a "$bundle_file" sudo apt install -y ;;
    pacman) xargs -a "$bundle_file" sudo pacman -S --noconfirm ;;
    *)      echo "Unsupported package manager" >&2; return 1 ;;
  esac
}

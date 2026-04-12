#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
source "$DOTFILES_DIR/system/lib/log.sh"
source "$DOTFILES_DIR/system/lib/platform.sh"

log_info "Installing platform modules for $(platform_os)"

if [[ "$(platform_os)" != "macos" ]]; then
  log_error "Only macOS is supported in this version"
  exit 1
fi

log_info "Stowing macOS modules"
"$DOTFILES_DIR/system/scripts/stow-manager.sh" apply --modules

log_info "macOS modules installed!"

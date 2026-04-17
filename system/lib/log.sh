#!/usr/bin/env bash
# Logging utilities
set -euo pipefail

# Colors (only if stdout is a terminal)
if [[ -t 1 ]]; then
  _BOLD="\033[1m"
  _GREEN="\033[32m"
  _YELLOW="\033[33m"
  _RED="\033[31m"
  _CYAN="\033[36m"
  _NC="\033[0m"
else
  _BOLD=""
  _GREEN=""
  _YELLOW=""
  _RED=""
  _CYAN=""
  _NC=""
fi

log_info()   { printf "  📝 %s\n" "$*"; }
log_ok()     { printf "\033[32m✓\033[0m  %s\n" "$*"; }
log_warn()   { printf "\033[33m⚠\033[0m  %s\n" "$*" >&2; }
log_error()  { printf "\033[31m✗\033[0m  %s\n" "$*" >&2; }
log_step()   { printf "  %s\n" "$*"; }

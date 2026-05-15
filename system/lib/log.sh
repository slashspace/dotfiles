#!/usr/bin/env bash
# Logging utilities
set -euo pipefail

log_info()   { printf "  📝 %s\n" "$*"; }
log_ok()     { printf "\033[32m✓\033[0m  %s\n" "$*"; }
log_warn()   { printf "\033[33m⚠\033[0m  %s\n" "$*" >&2; }
log_error()  { printf "\033[31m✗\033[0m  %s\n" "$*" >&2; }
log_step()   { printf "  %s\n" "$*"; }

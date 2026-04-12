#!/usr/bin/env bash
# Logging utilities
set -euo pipefail

log_info()  { echo "==> $*"; }
log_warn()  { echo "Warning: $*" >&2; }
log_error() { echo "Error: $*" >&2; }
log_step()  { echo "  -> $*"; }

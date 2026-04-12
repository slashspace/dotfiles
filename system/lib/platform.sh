#!/usr/bin/env bash
# Platform detection utilities
set -euo pipefail

platform_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)  echo "linux" ;;
    *)      echo "unknown" ;;
  esac
}

platform_distro() {
  if [[ "$(platform_os)" != "linux" ]]; then
    echo ""
    return
  fi
  if [[ -f /etc/os-release ]]; then
    # shellcheck disable=SC1091
    source /etc/os-release
    echo "${ID}"
  elif command -v lsb_release &>/dev/null; then
    lsb_release -is | tr '[:upper:]' '[:lower:]'
  else
    echo "unknown"
  fi
}

platform_arch() {
  case "$(uname -m)" in
    arm64|aarch64) echo "arm64" ;;
    x86_64|amd64)  echo "x86_64" ;;
    *)             echo "unknown" ;;
  esac
}

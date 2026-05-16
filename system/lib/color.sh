#!/usr/bin/env bash
# Color helpers for the theme system.
#
# All functions echo their result; nothing mutates global state.
# Hex inputs accept "#RRGGBB" or "RRGGBB" (case-insensitive).
#
#   color_hex_to_rgb  "#ff8800"        → 255,136,0
#   color_hex_to_argb "#ff8800"        → 0xffff8800       (alpha defaults to ff)
#   color_hex_to_argb "#ff8800" 80     → 0x80ff8800       (alpha as hex byte)
#   color_with_alpha  "#ff8800" 128    → 0x80ff8800       (alpha as decimal 0..255)

color_strip_hash() {
  local hex="${1#\#}"
  printf '%s' "$hex" | tr '[:upper:]' '[:lower:]'
}

# Alias: returns the hex without leading '#', case-preserved.
# Useful for renderers that need bare RRGGBB (starship, gitmux, nvim).
color_no_hash() {
  printf '%s' "${1#\#}"
}

color_hex_to_rgb() {
  local hex
  hex=$(color_strip_hash "$1")
  if [[ ! "$hex" =~ ^[0-9a-f]{6}$ ]]; then
    printf 'color_hex_to_rgb: invalid hex %q\n' "$1" >&2
    return 1
  fi
  printf '%d,%d,%d' "$((16#${hex:0:2}))" "$((16#${hex:2:2}))" "$((16#${hex:4:2}))"
}

color_hex_to_argb() {
  local hex alpha
  hex=$(color_strip_hash "$1")
  alpha="${2:-ff}"
  if [[ ! "$hex" =~ ^[0-9a-f]{6}$ ]]; then
    printf 'color_hex_to_argb: invalid hex %q\n' "$1" >&2
    return 1
  fi
  if [[ ! "$alpha" =~ ^[0-9a-fA-F]{2}$ ]]; then
    printf 'color_hex_to_argb: alpha must be 2 hex chars, got %q\n' "$2" >&2
    return 1
  fi
  printf '0x%s%s' "$(printf '%s' "$alpha" | tr '[:upper:]' '[:lower:]')" "$hex"
}

color_with_alpha() {
  local hex="$1"
  local alpha_dec="${2:-255}"
  if [[ ! "$alpha_dec" =~ ^[0-9]+$ ]] || (( alpha_dec < 0 || alpha_dec > 255 )); then
    printf 'color_with_alpha: alpha must be decimal 0..255, got %q\n' "$2" >&2
    return 1
  fi
  color_hex_to_argb "$hex" "$(printf '%02x' "$alpha_dec")"
}

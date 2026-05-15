#!/usr/bin/env bash
# Theme schema — declares the THEME_* contract every palette must export.
#
# Inspired by mango-waybar's two-layer model:
#   - Semantic layer:  what the color *means* (bg, primary, error...)
#   - ANSI layer:      raw 16-color terminal palette (BLACK..WHITEB)
#   - Metadata layer:  per-tool routing hints (Ghostty built-in name, etc.)
#
# Renderers read these vars from the environment and never reach back into
# palette internals. To add a new palette, copy any file in palettes/ and
# override every variable below.
#
# Sourcing this file (with no palette applied) loads sane defaults so shells
# that boot before any `dotfiles theme apply` still have THEME_FG / THEME_BG
# available.

# ─── Semantic layer ────────────────────────────────────────────────────────
# THEME_BG          # Main background
# THEME_BG_ALT      # Alternate / inactive background
# THEME_SHADOW      # Deepest background (drop-shadows, gutters)
# THEME_FG          # Main foreground / body text
# THEME_PRIMARY     # Brand color (active window, current item)
# THEME_SECONDARY   # Secondary accent (links, functions)
# THEME_TERTIARY    # Tertiary accent (info, modes)
# THEME_ACCENT      # Decorative accent (badges, separators)
# THEME_HOVER       # Hover / focused-but-not-selected state
# THEME_SURFACE     # Raised surface (panes, popups)
# THEME_OUTLINE     # Borders, separators, comments
# THEME_SUCCESS     # Positive state
# THEME_WARNING     # Cautious state
# THEME_ERROR       # Error / destructive state
# THEME_ORANGE      # Numbers / constants (kept distinct from WARNING)

# ─── ANSI 16 (terminal palette) ────────────────────────────────────────────
# THEME_BLACK / THEME_BLACKB
# THEME_RED   / THEME_REDB
# THEME_GREEN / THEME_GREENB
# THEME_YELLOW/ THEME_YELLOWB
# THEME_BLUE  / THEME_BLUEB
# THEME_MAGENTA / THEME_MAGENTAB
# THEME_CYAN  / THEME_CYANB
# THEME_WHITE / THEME_WHITEB

# ─── Metadata (all optional; renderers fall back gracefully) ───────────────
# THEME_DISPLAY_NAME            # Pretty name for picker (default: filename)
# THEME_GHOSTTY_BUILTIN         # If set, Ghostty uses this built-in theme
# THEME_NVIM_COLORSCHEME        # nvim plugin name (fallback: gruvbox)
# THEME_NVIM_STYLE              # nvim variant ("dark", "mocha", ...)
# THEME_BORDERS_INACTIVE_COLOR  # 0xAARRGGBB (default 0x00000000 = invisible)
# THEME_BORDERS_WIDTH           # float (default 5.0)

# ─── Defaults: catppuccin-purple-ish (used when nothing has been applied) ──
if [[ -z "${THEME_BG:-}" ]]; then
  THEME_BG="#1e1e2e"
  THEME_BG_ALT="#181825"
  THEME_SHADOW="#11111b"
  THEME_FG="#cdd6f4"
  THEME_PRIMARY="#cba6f7"
  THEME_SECONDARY="#89b4fa"
  THEME_TERTIARY="#94e2d5"
  THEME_ACCENT="#b4befe"
  THEME_HOVER="#f5c2e7"
  THEME_SURFACE="#313244"
  THEME_OUTLINE="#45475a"
  THEME_SUCCESS="#a6e3a1"
  THEME_WARNING="#f9e2af"
  THEME_ERROR="#f38ba8"
  THEME_ORANGE="#fab387"

  THEME_BLACK="#45475a";   THEME_BLACKB="#585b70"
  THEME_RED="#f38ba8";     THEME_REDB="#f38ba8"
  THEME_GREEN="#a6e3a1";   THEME_GREENB="#a6e3a1"
  THEME_YELLOW="#f9e2af";  THEME_YELLOWB="#f9e2af"
  THEME_BLUE="#89b4fa";    THEME_BLUEB="#89b4fa"
  THEME_MAGENTA="#cba6f7"; THEME_MAGENTAB="#cba6f7"
  THEME_CYAN="#94e2d5";    THEME_CYANB="#94e2d5"
  THEME_WHITE="#bac2de";   THEME_WHITEB="#cdd6f4"

  export THEME_BG THEME_BG_ALT THEME_SHADOW THEME_FG \
    THEME_PRIMARY THEME_SECONDARY THEME_TERTIARY THEME_ACCENT THEME_HOVER \
    THEME_SURFACE THEME_OUTLINE \
    THEME_SUCCESS THEME_WARNING THEME_ERROR THEME_ORANGE \
    THEME_BLACK THEME_BLACKB THEME_RED THEME_REDB \
    THEME_GREEN THEME_GREENB THEME_YELLOW THEME_YELLOWB \
    THEME_BLUE THEME_BLUEB THEME_MAGENTA THEME_MAGENTAB \
    THEME_CYAN THEME_CYANB THEME_WHITE THEME_WHITEB
fi

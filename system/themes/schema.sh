#!/usr/bin/env bash
# Theme schema — declares the THEME_* contract every palette must export.
#
# This file is documentation-only (no executable defaults). Renderers and
# `lib/modules/colors.sh` source the active theme directly; first-boot
# fallback uses palettes/catppuccin-purple.sh.
#
# Inspired by mango-waybar's two-layer model:
#   - Semantic layer:  what the color *means* (bg, primary, error...)
#   - ANSI layer:      raw 16-color terminal palette (BLACK..WHITEB)
#   - Metadata layer:  per-tool routing hints (Ghostty built-in name, etc.)
#
# To add a new palette, copy any file in palettes/ and override every
# variable below.

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

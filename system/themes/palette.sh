#!/usr/bin/env bash
# Semantic color palette definition
# Inspired by Catppuccin style guide: https://catppuccin.com/docs/style-guide
#
# Each theme file must export all variables below.
# Renderers read these variables and generate tool-specific configs.

# --- Background layers (darkest to lightest for dark themes) ---
# THEME_CRUST        # Deepest background
# THEME_MANTLE       # Deep background
# THEME_BASE         # Main background / terminal bg
# THEME_SURFACE0     # Surface elements (code blocks, etc.)
# THEME_SURFACE1     # Raised surface (inactive panes, etc.)
# THEME_SURFACE2     # Highest surface (cursor line, etc.)

# --- Overlay layers ---
# THEME_OVERLAY0     # Dim overlay
# THEME_OVERLAY1     # Mid overlay (comments, etc.)
# THEME_OVERLAY2     # Bright overlay (line numbers, etc.)

# --- Text layers ---
# THEME_TEXT          # Primary text / body copy
# THEME_SUBTEXT1     # Secondary text (sub-headlines, labels)
# THEME_SUBTEXT0     # Tertiary text (subtle, dimmed)

# --- Accent colors ---
# THEME_ROSEWATER    # Warm pink (cursor, accent)
# THEME_FLAMINGO     # Light pink (selected text)
# THEME_PINK         # Pink
# THEME_MAUVE        # Purple (keywords, headlines)
# THEME_RED          # Red (errors, symbols)
# THEME_MAROON       # Dark red
# THEME_PEACH        # Orange (constants, numbers)
# THEME_YELLOW       # Yellow (warnings, classes)
# THEME_GREEN        # Green (strings, success)
# THEME_TEAL         # Teal (information)
# THEME_SKY          # Light blue
# THEME_SAPPHIRE     # Blue-green
# THEME_BLUE         # Blue (links, functions)
# THEME_LAVENDER     # Soft purple (active elements)

# --- Special ---
# THEME_CURSOR       # Cursor color

# Default: catppuccin-mocha (if no theme is applied)
if [[ -z "${THEME_BASE:-}" ]]; then
  THEME_CRUST="#181825"
  THEME_MANTLE="#1e1e2e"
  THEME_BASE="#1e1e2e"
  THEME_SURFACE0="#313244"
  THEME_SURFACE1="#45475a"
  THEME_SURFACE2="#585b70"
  THEME_OVERLAY0="#6c7086"
  THEME_OVERLAY1="#7f849c"
  THEME_OVERLAY2="#9399b2"
  THEME_TEXT="#cdd6f4"
  THEME_SUBTEXT1="#bac2de"
  THEME_SUBTEXT0="#a6adc8"
  THEME_ROSEWATER="#f5e0dc"
  THEME_FLAMINGO="#f2cdcd"
  THEME_PINK="#f5c2e7"
  THEME_MAUVE="#cba6f7"
  THEME_RED="#f38ba8"
  THEME_MAROON="#eba0ac"
  THEME_PEACH="#fab387"
  THEME_YELLOW="#f9e2af"
  THEME_GREEN="#a6e3a1"
  THEME_TEAL="#94e2d5"
  THEME_SKY="#89dceb"
  THEME_SAPPHIRE="#74c7ec"
  THEME_BLUE="#89b4fa"
  THEME_LAVENDER="#b4befe"
  THEME_CURSOR="#f5e0dc"

  export THEME_CRUST THEME_MANTLE THEME_BASE \
    THEME_SURFACE0 THEME_SURFACE1 THEME_SURFACE2 \
    THEME_OVERLAY0 THEME_OVERLAY1 THEME_OVERLAY2 \
    THEME_TEXT THEME_SUBTEXT1 THEME_SUBTEXT0 \
    THEME_ROSEWATER THEME_FLAMINGO THEME_PINK \
    THEME_MAUVE THEME_RED THEME_MAROON \
    THEME_PEACH THEME_YELLOW THEME_GREEN \
    THEME_TEAL THEME_SKY THEME_SAPPHIRE \
    THEME_BLUE THEME_LAVENDER \
    THEME_CURSOR
fi

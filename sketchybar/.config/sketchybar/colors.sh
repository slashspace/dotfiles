#!/bin/bash

# Catppuccin Latte Color Palette
# Reference: https://catppuccin.com/palette/

# Pure colors
export PURE_WHITE=0xffffffff
export PURE_BLACK=0xff000000
export TRANSPARENT=0x00000000

# Catppuccin Latte - Accent Colors
export ROSEWATER=0xffdc8a78
export FLAMINGO=0xffdd7878
export PINK=0xffea76cb
export MAUVE=0xff8839ef
export RED=0xffd20f39
export MAROON=0xffe64553
export PEACH=0xfffe640b
export YELLOW=0xffdf8e1d
export GREEN=0xff40a02b
export TEAL=0xff179299
export SKY=0xff04a5e5
export SAPPHIRE=0xff209fb5
export BLUE=0xff1e66f5
export LAVENDER=0xff7287fd

# Catppuccin Latte - Text Colors
export TEXT=0xff4c4f69
export SUBTEXT_1=0xff5c5f77
export SUBTEXT_0=0xff6c6f85
export OVERLAY_2=0xff7c7f93
export OVERLAY_1=0xff8c8fa1
export OVERLAY_0=0xff9ca0b0

# Catppuccin Latte - Surface Colors
export SURFACE_2=0xffacb0be
export SURFACE_1=0xffbcc0cc
export SURFACE_0=0xffccd0da
export BASE=0xffeff1f5
export MANTLE=0xffe6e9ef
export CRUST=0xffdce0e8

# Legacy color aliases for compatibility
export BLACK=$TEXT
export WHITE=$BASE
export GREY=$OVERLAY_2
export ORANGE=$PEACH
export MAGENTA=$MAUVE

# Background colors with transparency
export BG0=$BASE
export BG1=0x60$SURFACE_1
export BG2=0x60$SURFACE_2

# Battery Colors (using Latte palette)
export BATTERY_1=$GREEN
export BATTERY_2=$YELLOW
export BATTERY_3=$PEACH
export BATTERY_4=$MAROON
export BATTERY_5=$RED

# General bar colors
export BAR_COLOR=$BG0
export BAR_BORDER_COLOR=$BG2
export BACKGROUND_1=$BG1
export BACKGROUND_2=$BG2
export ICON_COLOR=$TEXT
export LABEL_COLOR=$TEXT
export POPUP_BACKGROUND_COLOR=$BAR_COLOR
export POPUP_BORDER_COLOR=$TEXT
export SHADOW_COLOR=$BLACK

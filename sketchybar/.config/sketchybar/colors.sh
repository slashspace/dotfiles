#!/bin/bash

export PURE_WHITE=0xffffffff
export PURE_BLACK=0xff000000

export BAR_COLOR=0x40000000
export ITEM_BG_COLOR=0x33000000
export ACCENT_COLOR=0x33ffffff

# Shared Polycarbonate neutrals: midpoint of sha1, Ayu, Gruvbox, and One Dark.
# Text stays gray. Status hues are the midpoint of the same four palettes.
export BLACK=0xff1d1e1f
export WHITE=0xffc5c2b7
export GREY=0xff8c8a87
export RED=0xfff2764a
export GREEN=0xff9bd085
export BLUE=0xff6bb5df
export YELLOW=0xfff6b956
export ORANGE=0xfff49850
export MAGENTA=0xffca92da
export TRANSPARENT=0x00000000
export BG0=0xff000000
export BG1=0x601d1e1f
export BG2=0x608c8a87

# Battery Colors
export BATTERY_1=$GREEN
export BATTERY_2=$YELLOW
export BATTERY_3=$YELLOW
export BATTERY_4=$ORANGE
export BATTERY_5=$RED

# General bar colors
export BAR_COLOR=$BG0
export BAR_BORDER_COLOR=$BG2
export BACKGROUND_1=$BG1
export BACKGROUND_2=$BG2
export ICON_COLOR=$WHITE # Color of all icons
export LABEL_COLOR=$WHITE # Color of all labels
export POPUP_BACKGROUND_COLOR=$BAR_COLOR
export POPUP_BORDER_COLOR=$WHITE
export SHADOW_COLOR=$BLACK

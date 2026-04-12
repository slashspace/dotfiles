#!/bin/bash
# SketchyBar 模块加载：active / experimental 边界见 items/README.md
# 由 sketchybarrc 在设置好 CONFIG_DIR、ITEM_DIR 后 source 本文件

###############################################################################
# Active — 当前启用的模块（与 items/README.md 一致）
###############################################################################
source "$ITEM_DIR/apple.sh"
source "$ITEM_DIR/spaces.sh"
source "$ITEM_DIR/spotify.sh"
source "$ITEM_DIR/calendar.sh"
source "$ITEM_DIR/brew.sh"
source "$ITEM_DIR/dnd.sh"
source "$ITEM_DIR/github.sh"
source "$ITEM_DIR/wifi.sh"
source "$ITEM_DIR/battery.sh"
source "$ITEM_DIR/volume.sh"
# source "$ITEM_DIR/memory.sh"
# source "$ITEM_DIR/cpu.sh"

###############################################################################
# Experimental — 可选模块，需要时取消下面注释
###############################################################################
# source "$ITEM_DIR/front_app.sh"
# source "$ITEM_DIR/mic.sh"
# source "$ITEM_DIR/media.sh"
# source "$ITEM_DIR/timer.sh"

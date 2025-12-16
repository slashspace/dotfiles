#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

# 获取当前激活的workspace
if [ -n "$FOCUSED_WORKSPACE" ]; then
    active_workspace="$FOCUSED_WORKSPACE"
else
    active_workspace=$(aerospace list-workspaces --focused 2>/dev/null | head -1)
fi

if [ -n "$active_workspace" ]; then
    sketchybar --set space.active \
        icon="$active_workspace" \
        icon.color=$YELLOW \
        background.border_color=$RED
else
    sketchybar --set space.active \
        icon.color=$GREY \
        background.border_color=$BACKGROUND_2
fi

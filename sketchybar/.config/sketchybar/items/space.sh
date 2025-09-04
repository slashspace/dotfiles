#!/bin/bash

# 通过 aerospace --help 获取所有相关命令
# aerospace list-workspaces --all (获取所有工作区  1 2 3 4 5 6 7 8 9 10)
# aerospace list-windows --workspace 1 (获取工作区 1 的窗口)
  # 11881 | Cursor | Command.ts — tcpro
  # 14519 | Cursor | space.sh — dotfiles

backgroundBorderWidth=1
# aerospace 工作区 1 2 3 4 5 6 7 8 9 10
for sid in $(aerospace list-workspaces --all); do
  monitor=$(aerospace list-windows --workspace "$sid" --format "%{monitor-appkit-nsscreen-screens-id}")

  if [ -z "$monitor" ]; then
    monitor="1"
  fi

  if [ "$sid" = "1" ]; then
    icon=" "
    iconColor="$GREEN"
  elif [ "$sid" = "2" ]; then
    icon=" "
    iconColor="$BLUE"
  elif [ "$sid" = "3" ]; then
    icon=" "
    iconColor="$YELLOW"
  elif [ "$sid" = "4" ]; then
    icon="󰹕"
    iconColor="$ORANGE"
  elif [ "$sid" = "5" ]; then
    icon="💬"
    iconColor="$RED"
  else 
    icon=""
    iconColor="$ICON_COLOR"
    backgroundBorderWidth=0
  fi




  sketchybar --add item space."$sid" left \
    --subscribe space."$sid" aerospace_workspace_change display_change system_woke mouse.entered mouse.exited \
    --set space."$sid" \
    display="$monitor" \
    padding_right=0 \
    icon="$icon" \
    icon.padding_left=4 \
    icon.padding_right=4 \
    icon.color="$iconColor" \
    background.drawing=on \
    background.color="$PURE_BLACK" \
    background.corner_radius=5 \
    background.height=25 \
    background.border_width="$backgroundBorderWidth" \
    background.border_color="$SUBTEXT_1" \
    label.padding_right=7 \
    label.drawing=on \
    click_script="aerospace workspace $sid" \
    script="$PLUGIN_DIR/aerospace.sh $sid"
done




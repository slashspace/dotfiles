#!/bin/bash

source "$CONFIG_DIR/icons.sh"

apple_logo=(
  icon="$APPLE"
  icon.font="$FONT:Bold:16.0"
  icon.color="$GREEN"
  icon.padding_left=8
  icon.padding_right=8
  label.drawing=off
  background.drawing=off
  padding_left=4
  padding_right=6
  click_script="$PLUGIN_DIR/apple.sh"
  popup.align=left
  popup.y_offset=6
  popup.height=28
  popup.background.color="$BAR_COLOR"
  popup.background.border_color="$WHITE"
  popup.background.border_width=2
  popup.background.corner_radius=9
)

apple_row=(
  icon.font="$FONT:Bold:14.0"
  icon.color="$WHITE"
  icon.padding_left=12
  label.font="$FONT:Bold:13.0"
  label.color="$WHITE"
  label.padding_right=14
  background.drawing=off
)

sketchybar --add item apple.logo left \
           --set apple.logo "${apple_logo[@]}" \
           --add item apple.prefs popup.apple.logo \
           --set apple.prefs "${apple_row[@]}" icon="$PREFERENCES" label="系统设置" \
                 click_script="open -a 'System Settings'; sketchybar --set apple.logo popup.drawing=off" \
           --add item apple.activity popup.apple.logo \
           --set apple.activity "${apple_row[@]}" icon="$ACTIVITY" label="活动监视器" \
                 click_script="open -a 'Activity Monitor'; sketchybar --set apple.logo popup.drawing=off" \
           --add item apple.lock popup.apple.logo \
           --set apple.lock "${apple_row[@]}" icon="$LOCK" label="锁定屏幕" \
                 click_script="pmset displaysleepnow; sketchybar --set apple.logo popup.drawing=off" \
           --add item apple.bluetooth popup.apple.logo \
           --set apple.bluetooth "${apple_row[@]}" icon="$BLUETOOTH" label="蓝牙" \
                 click_script="$PLUGIN_DIR/apple.sh bluetooth" \
           --add item apple.restart popup.apple.logo \
           --set apple.restart "${apple_row[@]}" icon="$RESTART" label="重新启动" \
                 click_script="$PLUGIN_DIR/apple.sh restart"

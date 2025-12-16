#!/bin/bash
sketchybar --add event aerospace_workspace_change

# 获取当前激活的workspace作为初始值
# active_workspace=$(aerospace list-workspaces --focused 2>/dev/null | head -1)

# 只创建一个item来显示当前激活的workspace
sketchybar --add item space.active left \
  --subscribe space.active aerospace_workspace_change \
  --set space.active \
  padding_left=2 \
  padding_right=2 \
  icon="$FOCUSED_WORKSPACE" \
  icon.padding_left=10 \
  icon.padding_right=10 \
  icon.highlight_color=$RED \
  icon.color=$YELLOW \
  label.color=$GREY \
  label.highlight_color=$WHITE \
  label.font="$FONT:Regular:16.0" \
  background.color=$BACKGROUND_1 \
  background.border_color=$RED \
  script="$PLUGIN_DIR/space.sh"

space_creator=(
  icon=􀆊
  icon.font="$FONT:Heavy:16.0"
  padding_left=8
  padding_right=8
  label.drawing=off
  display=active
  script="$PLUGIN_DIR/space_windows.sh"
  icon.color=$WHITE
  click_script="sketchybar --trigger aerospace_workspace_change"
)

sketchybar --add item space_creator left               \
           --set space_creator "${space_creator[@]}"   \
           --subscribe space_creator aerospace_workspace_change

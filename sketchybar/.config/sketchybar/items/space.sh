#!/bin/bash


# aerospace 模式
aerospace_mode=(
  icon=""
  icon.color="$ORANGE"
  background.color="$PURE_BLACK"
  icon.padding_left=4
  script="$PLUGIN_DIR/aerospace_mode.sh"
)
sketchybar --add item aerospace_mode left \
  --subscribe aerospace_mode aerospace_mode_change \
  --set aerospace_mode "${aerospace_mode[@]}"


# aerospace 工作区
for sid in $(aerospace list-workspaces --all); do
  monitor=$(aerospace list-windows --workspace "$sid" --format "%{monitor-appkit-nsscreen-screens-id}")

  if [ -z "$monitor" ]; then
    monitor="1"
  fi

  sketchybar --add item space."$sid" left \
    --subscribe space."$sid" aerospace_workspace_change display_change system_woke mouse.entered mouse.exited \
    --set space."$sid" \
    display="$monitor" \
    padding_right=0 \
    icon="$sid" \
    label.padding_right=7 \
    icon.padding_left=7 \
    icon.font="$FONT:Regular:19.0" \
    icon.padding_right=4 \
    background.drawing=on \
    background.color="$PURE_BLACK" \
    background.corner_radius=5 \
    background.height=25 \
    label.drawing=on \
    click_script="aerospace workspace $sid" \
    script="$PLUGIN_DIR/aerospace.sh $sid"
done



# 监听事件
sketchybar --add event aerospace_workspace_change
sketchybar --add event aerospace_mode_change

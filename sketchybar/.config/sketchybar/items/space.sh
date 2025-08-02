#!/bin/bash


# aerospace 工作区
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
  else 
    icon="$sid"
    iconColor="$ICON_COLOR"
  fi

  sketchybar --add item space."$sid" left \
    --subscribe space."$sid" aerospace_workspace_change display_change system_woke mouse.entered mouse.exited \
    --set space."$sid" \
    display="$monitor" \
    padding_right=0 \
    icon="$icon" \
    label.padding_right=7 \
    icon.padding_left=7 \
    icon.font="$FONT:Regular:19.0" \
    icon.padding_right=4 \
    icon.color="$iconColor" \
    background.drawing=on \
    background.color="$PURE_BLACK" \
    background.corner_radius=5 \
    background.height=25 \
    label.drawing=on \
    click_script="aerospace workspace $sid" \
    script="$PLUGIN_DIR/aerospace.sh $sid"
done




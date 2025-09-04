#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh
source "$CONFIG_DIR/colors.sh"

FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused --format "%{workspace}")

# if [ "$SENDER" == "mouse.entered" ]; then
#   if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
#     exit 0
#   fi
#   sketchybar --set "$NAME" \
#     background.drawing=on \
#     label.color="$LABEL_COLOR" \
#     background.color="$PURE_BLACK"
#   exit 0
# fi

# if [ "$SENDER" == "mouse.exited" ]; then
#   if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
#     exit 0
#   fi
#   sketchybar --set "$NAME" \
#     background.drawing=off \
#     label.color="$LABEL_COLOR" \
#     background.color="$PURE_BLACK"
#   exit 0
# fi

icons=""

APPS_INFO=$(aerospace list-windows --workspace "$1" --json --format "%{monitor-appkit-nsscreen-screens-id}%{app-name}")

IFS=$'\n'
for sid in $(echo "$APPS_INFO" | jq -r "map ( .\"app-name\" ) | .[]"); do
  # 如果 $icons 中不包含 $sid，则添加到 $icons 中
  if [[ ! "$icons" =~ $sid ]]; then
    icons+=$sid
    icons+=" "
  fi
done

for monitor_id in $(echo "$APPS_INFO" | jq -r "map ( .\"monitor-appkit-nsscreen-screens-id\" ) | .[]"); do
  monitor=$monitor_id
done

if [ -z "$monitor" ]; then
  monitor="1"
fi


if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar sin 10 \
    --set "$NAME" \
    y_offset=10 y_offset=0 \
    background.drawing=on

  sketchybar --set "$NAME" \
    display="$monitor" \
    drawing=on \
    label="$icons" \
    label.color="$PINK"
    icon.font.size=14 \
    background.color="$BAR_BORDER_COLOR"
    background.border_color="$SUBTEXT_1" \

else
  sketchybar --set "$NAME" \
    display="$monitor" \
    drawing=on \
    label="$icons" \
    label.color="$PURE_WHITE"
    background.drawing=off \
    icon.font.size=14 \
    background.color="$BACKGROUND_1"
fi


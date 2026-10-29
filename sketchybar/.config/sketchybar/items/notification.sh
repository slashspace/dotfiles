#!/bin/bash

notification=(
  updates=on
  update_freq=30
  drawing=off
  icon.drawing=off
  label.drawing=on
  label.font="$FONT:Bold:13.0"
  label.color="$GREEN"
  label.padding_left=6
  label.padding_right=6
  background.drawing=off
  script="$PLUGIN_DIR/notification.sh"
)

sketchybar --add item notification right \
           --set notification "${notification[@]}"

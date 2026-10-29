#!/bin/bash

source "$CONFIG_DIR/colors.sh"

NOTE="${HOME}/.cache/sketchybar/notification.txt"
if [ -s "$NOTE" ]; then
  sketchybar --set notification drawing=on label="$(head -n 1 "$NOTE")" label.color="$GREEN" icon.drawing=off
else
  sketchybar --set notification drawing=off label=""
fi

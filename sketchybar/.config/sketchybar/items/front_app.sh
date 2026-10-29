#!/bin/bash

front_app=(
  icon.padding_left=15
  icon.padding_right=0
  label.padding_left=0
  label.padding_right=10
  label.y_offset=-7
  label.font="$FONT:Bold:14.0"
  label.drawing=off
  icon.background.drawing=on
  background.drawing=off
  padding_right=8
  display=active
  script="$PLUGIN_DIR/front_app.sh"
  click_script="open -a 'Mission Control'"
)

sketchybar --add item front_app left \
           --set front_app "${front_app[@]}" \
           --subscribe front_app front_app_switched aerospace_workspace_change

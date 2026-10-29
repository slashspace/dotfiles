#!/bin/bash

mic=(
  updates=on
  update_freq=10
  icon=
  icon.y_offset=0
  label.drawing=on
  label.font="$FONT:Regular:12.0"
  label.y_offset=4
  label.padding_right=2
  padding_right=4
  background.drawing=off
  script="$PLUGIN_DIR/mic.sh"
  click_script="$PLUGIN_DIR/mic_click.sh"
)

mic_output=(
  updates=off
  width=0
  icon.drawing=off
  label.drawing=on
  label.font="$FONT:Regular:8.0"
  label.color="$GREY"
  label.align=left
  label.y_offset=-8
  label.padding_left=0
  label.padding_right=0
  padding_left=-40
  padding_right=0
  background.drawing=off
  click_script="$PLUGIN_DIR/mic_click.sh"
)

sketchybar --add item mic left \
           --set mic "${mic[@]}" \
           --add item mic.output left \
           --set mic.output "${mic_output[@]}" \
           --subscribe mic volume_change

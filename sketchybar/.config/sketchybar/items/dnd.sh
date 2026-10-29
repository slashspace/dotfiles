#!/bin/bash

source "$CONFIG_DIR/icons.sh"

dnd=(
  updates=on
  update_freq=10
  drawing=off
  icon="$DND"
  icon.font="$FONT:Regular:13.0"
  icon.color="$ORANGE"
  label.drawing=on
  label.font="$FONT:Bold:10.0"
  label.color="$ORANGE"
  label.padding_left=2
  padding_left=4
  padding_right=2
  background.drawing=off
  script="$PLUGIN_DIR/dnd.sh"
)

sketchybar --add item dnd right \
           --set dnd "${dnd[@]}"

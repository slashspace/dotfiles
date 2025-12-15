#!/bin/bash

# Filename: ~/dotfiles/sketchybar/felixkratz-linkarzu/items/dnd.sh
# ~/dotfiles/sketchybar/felixkratz-linkarzu/items/dnd.sh

dnd=(
  updates=on
  label.font="$FONT:Regular:8.0"
  update_freq=10
  padding_left=10
  label.padding_left=4
  label.drawing=on
  script="$PLUGIN_DIR/dnd.sh"
)

# Add the DND item to the right side of the bar and set its properties
sketchybar --add item dnd right \
  --set dnd "${dnd[@]}"

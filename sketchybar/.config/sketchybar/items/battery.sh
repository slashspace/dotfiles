#!/bin/sh

battery=(
  script="$PLUGIN_DIR/battery.sh"
  click_script="$PLUGIN_DIR/close_popups.sh"
  icon.font="$FONT:Regular:15.0"
  icon.padding_left=4
  icon.padding_right=4
  padding_right=14
  padding_left=4
  update_freq=120
  updates=on
  background.drawing=off
)
sketchybar --add item battery right \
           --set battery "${battery[@]}" \
           --subscribe battery power_source_change system_woke

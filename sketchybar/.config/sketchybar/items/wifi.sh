#!/bin/bash

source "$CONFIG_DIR/icons.sh"

wifi=(
  padding_left=4
  padding_right=4
  label.width=0
  label.font="$FONT:Regular:12.0"
  label.color="$WHITE"
  label.padding_left=4
  label.padding_right=6
  icon="$WIFI_DISCONNECTED"
  icon.color="$GREY"
  icon.font="$FONT:Regular:14.0"
  background.drawing=off
  script="$PLUGIN_DIR/wifi.sh"
  click_script="$PLUGIN_DIR/close_popups.sh"
)

sketchybar --add item wifi right \
           --set wifi "${wifi[@]}" \
           --subscribe wifi wifi_change mouse.clicked

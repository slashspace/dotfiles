#!/bin/bash

# Filename: ~/dotfiles/sketchybar/felixkratz/plugins/front_app.sh

if [ "$SENDER" = "front_app_switched" ]; then
  # if [ "$INFO" = "kitty" ]; then
  #   ~/dotfiles/sketchybar/felixkratz-linkarzu/plugins/kitty_name.sh
  #   exit 0
  # fi
  sketchybar --set $NAME label="$INFO" icon.background.image="app.$INFO"
fi

#!/bin/bash

# Filename: ~/dotfiles/sketchybar/felixkratz-linkarzu/plugins/notification.sh
# ~/dotfiles/sketchybar/felixkratz-linkarzu/plugins/notification.sh

source "$CONFIG_DIR/colors.sh"

custom_notification="$HOME/dotfiles/custom-notification.txt"

if [ -f "$custom_notification" ]; then
  sketchybar -m --set notification label=" " icon="" icon.color=$GREEN label.color=$GREEN icon.drawing=on
else
  sketchybar -m --set notification label="" icon.drawing=off
fi

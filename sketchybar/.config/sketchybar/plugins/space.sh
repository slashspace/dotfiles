#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh
source "$CONFIG_DIR/colors.sh"
COLOR=$BACKGROUND_2
ICON_COLOR=$GREY
if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  COLOR=$RED
  ICON_COLOR=$YELLOW
fi
  sketchybar --set $NAME icon.color=$ICON_COLOR \
                         label.highlight=$ORANGE \
                         background.border_color=$COLOR

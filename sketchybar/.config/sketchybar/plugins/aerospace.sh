#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

source "$CONFIG_DIR/colors.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME \
        background.drawing=on \
        icon.color=$BLACK
else
    sketchybar --set $NAME \
        background.drawing=off \
        icon.color=$GREY
fi

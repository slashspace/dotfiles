#!/bin/bash

# Sits outside the capsule, between the battery percentage and the clock.
sketchybar --add item media.gap right \
           --set media.gap width=16 \
                         icon.drawing=off \
                         label.drawing=off \
                         background.drawing=off \
                         padding_left=0 \
                         padding_right=0

source "$ITEM_DIR/battery.sh"
source "$ITEM_DIR/wifi.sh"
source "$ITEM_DIR/volume.sh"

media_block=(
  background.color="$BACKGROUND_1"
  background.border_color="$BACKGROUND_2"
  background.border_width=2
  background.corner_radius=9
  background.height=32
  background.padding_left=0
  background.padding_right=0
)

sketchybar --add bracket media_block battery wifi volume_icon \
           --set media_block "${media_block[@]}"

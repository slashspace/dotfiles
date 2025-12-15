#!/bin/bash

memory_top=(
  label.font="$FONT:Semibold:7"
  label=MEM
  icon.drawing=off
  width=0
  padding_right=15
  y_offset=6
)

memory_item=(
  script="$PLUGIN_DIR/memory.sh"
  icon.drawing=off
  label.font="$FONT:Heavy:12"
  label=MEM
  y_offset=-8
  padding_right=15
  width=35
  update_freq=5
  updates=on
)

sketchybar --add item memory.top right              \
           --set memory.top "${memory_top[@]}"         \
                                                 \
           --add item memory.item right \
           --set memory.item "${memory_item[@]}"

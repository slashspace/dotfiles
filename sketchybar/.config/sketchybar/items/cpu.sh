#!/bin/bash

cpu=(
    icon=
    icon.color=$MAGENTA
    update_freq=3
    script="$PLUGIN_DIR/cpu.sh"
)

sketchybar --add item cpu right\
    --set cpu "${cpu[@]}" \
    background.color="$PURE_BLACK"
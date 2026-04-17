#!/bin/bash


if [ "$SENDER" = "front_app_switched" ]; then
  # if [ "$INFO" = "kitty" ]; then
  #   exit 0
  # fi
  sketchybar --set $NAME label="$INFO" icon.background.image="app.$INFO"
fi

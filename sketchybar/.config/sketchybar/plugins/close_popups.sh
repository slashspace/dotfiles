#!/bin/bash

rm -f "${HOME}/.cache/sketchybar/cliamp-popup.on"
sketchybar --set volume_icon popup.drawing=off \
           --set mic popup.drawing=off \
           --set cliamp.title popup.drawing=off

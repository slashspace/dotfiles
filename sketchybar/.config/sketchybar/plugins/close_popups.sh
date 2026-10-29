#!/bin/bash

rm -f "${HOME}/.cache/sketchybar/cliamp-popup.on" \
      "${HOME}/.cache/sketchybar/apple-popup.on"
sketchybar --set volume_icon popup.drawing=off \
           --set mic popup.drawing=off \
           --set cliamp.title popup.drawing=off \
           --set apple.logo popup.drawing=off \
           --set timer popup.drawing=off \
           --set cpu.graph popup.drawing=off \
           --set ram.graph popup.drawing=off \
           --set gpu.graph popup.drawing=off

#!/bin/bash
# AeroSpace workspace strip: fixed 0–9 slots; current workspace highlighted in place.
# Click a slot to switch to that workspace. Refreshes on workspace change.

sketchybar --add event aerospace_workspace_change

# Manager: runs on aerospace_workspace_change and updates all space.* items.
sketchybar --add item spaces.manager left \
  --set spaces.manager \
  script="$PLUGIN_DIR/aerospace_spaces_update.sh" \
  updates=on \
  drawing=off
sketchybar --subscribe spaces.manager aerospace_workspace_change front_app_switched

# One item per workspace digit 0–9 (left to right); icon and style set by plugin.
for i in 0 1 2 3 4 5 6 7 8 9; do
  sketchybar --add item "space.ws.${i}" left \
    --set "space.ws.${i}" \
    icon="" \
    icon.font="$FONT:Semibold:12.0" \
    icon.padding_left=6 \
    icon.padding_right=6 \
    label.drawing=off \
    background.drawing=on \
    background.height=20 \
    background.width=20 \
    background.corner_radius=6 \
    background.border_width=1 \
    background.padding_left=2 \
    background.padding_right=2 \
    drawing=off
done

# Current workspace apps: icon + label only (no item background/border).
for i in 1 2 3 4 5; do
  sketchybar --add item "space.app.${i}" left \
    --set "space.app.${i}" \
    padding_left=2 \
    padding_right=2 \
    label.padding_left=2 \
    label.padding_right=2 \
    label.font="$FONT:Regular:12.0" \
    label.highlight_color="$GREEN" \
    icon.background.drawing=on \
    icon.background.image.scale=0.6 \
    background.drawing=off \
    drawing=off
done

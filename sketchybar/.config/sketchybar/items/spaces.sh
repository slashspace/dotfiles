#!/bin/bash
# AeroSpace workspace strip: one item per workspace (0-9), states focused / occupied / empty.
# Click an item to switch to that workspace. Refreshes on workspace change.

sketchybar --add event aerospace_workspace_change

# Manager: runs on aerospace_workspace_change and updates all space.* items.
# updates=on ensures the script runs even when the item is not drawn (global default is updates=when_shown).
sketchybar --add item spaces.manager left \
  --set spaces.manager \
  script="$PLUGIN_DIR/aerospace_spaces_update.sh" \
  updates=on \
  drawing=off
sketchybar --subscribe spaces.manager aerospace_workspace_change

# One item per workspace (0-9); state and visibility set by aerospace_spaces_update.sh
for ws in 1 2 3 4 5 6 7 8 9 0; do
  sketchybar --add item "space.${ws}" left \
    --set "space.${ws}" \
    icon="${ws}" \
    icon.font="$FONT:Semibold:12.0" \
    icon.padding_left=4 \
    icon.padding_right=4 \
    label.drawing=off \
    background.drawing=on \
    background.height=20 \
    background.corner_radius=6 \
    background.border_width=1 \
    background.padding_left=2 \
    background.padding_right=2 \
    click_script="/opt/homebrew/bin/aerospace workspace ${ws} 2>/dev/null || /usr/local/bin/aerospace workspace ${ws}" \
    drawing=off
done

# Current workspace apps: each slot = front_app style (icon.background.image + label), max 5 slots; smaller icon via scale.
for i in 1 2 3 4 5; do
  sketchybar --add item "space.app.${i}" left \
    --set "space.app.${i}" \
    label.padding_left=4 \
    label.padding_right=10 \
    label.font="$FONT:Bold:14.0" \
    icon.background.drawing=on \
    icon.background.image.scale=0.72 \
    background.drawing=on \
    background.color="$BACKGROUND_2" \
    background.height=20 \
    background.corner_radius=6 \
    background.border_width=0 \
    drawing=off
done

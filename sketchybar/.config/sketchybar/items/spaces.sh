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

# Window icons for the focused workspace (updated by aerospace_spaces_update.sh only)
sketchybar --add item space.windows left \
  --set space.windows \
  icon="" \
  label.font="$FONT:Regular:11.0" \
  label.color="$GREY" \
  padding_left=8 \
  background.drawing=on \
  background.color="$BACKGROUND_2" \
  background.height=20 \
  background.corner_radius=6 \
  background.border_width=0

#!/bin/bash
# AeroSpace workspace strip: [inactive workspaces] | [active workspace] (active on the right).
# Click an inactive slot to switch to that workspace. Refreshes on workspace change.

sketchybar --add event aerospace_workspace_change

# Manager: runs on aerospace_workspace_change and updates all space.* items.
sketchybar --add item spaces.manager left \
  --set spaces.manager \
  script="$PLUGIN_DIR/aerospace_spaces_update.sh" \
  updates=on \
  drawing=off
sketchybar --subscribe spaces.manager aerospace_workspace_change front_app_switched

# Inactive slots (left): same square shape as active; icon and click_script set by plugin.
for i in 1 2 3 4 5 6 7 8 9; do
  sketchybar --add item "space.inactive.${i}" left \
    --set "space.inactive.${i}" \
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

# Separator: vertical line between inactive and active.
sketchybar --add item space.sep left \
  --set space.sep \
  icon=" " \
  icon.font="$FONT:Regular:12.0" \
  icon.padding_left=2 \
  icon.padding_right=2 \
  label.drawing=off \
  background.drawing=on \
  background.height=20 \
  background.width=2 \
  background.corner_radius=0 \
  drawing=off

# Active workspace (right): inverted style (light bg, dark number); same square shape.
sketchybar --add item space.active left \
  --set space.active \
  icon="" \
  icon.font="$FONT:Semibold:12.0" \
  icon.padding_left=6 \
  icon.padding_right=6 \
  label.drawing=off \
  background.drawing=on \
  background.height=20 \
  background.width=20 \
  background.corner_radius=6 \
  background.border_width=0 \
  background.padding_left=2 \
  background.padding_right=2 \
  drawing=off

# Current workspace apps: each slot = front_app style; focused app gets label.highlight + background highlight.
for i in 1 2 3 4 5; do
  sketchybar --add item "space.app.${i}" left \
    --set "space.app.${i}" \
    label.padding_left=4 \
    label.padding_right=10 \
    label.font="$FONT:Regular:11.0" \
    label.highlight_color="$YELLOW" \
    icon.background.drawing=on \
    icon.background.image.scale=0.72 \
    background.drawing=on \
    background.color="$BACKGROUND_2" \
    background.height=20 \
    background.corner_radius=6 \
    background.border_width=0 \
    drawing=off
done

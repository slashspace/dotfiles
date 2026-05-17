#!/usr/bin/env bash
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

# One item per workspace digit 0–9 (center to right). Plugin only swaps colors;
# size/shape/gap are fixed here so layout never shifts when switching workspaces.
for i in 0 1 2 3 4 5 6 7 8 9; do
  sketchybar --add item "space.ws.${i}" center \
    --set "space.ws.${i}" \
    icon="" \
    width=24 \
    icon.width=24 \
    icon.align=center \
    icon.font="$FONT:Bold:13.0" \
    icon.padding_left=0 \
    icon.padding_right=0 \
    label.drawing=off \
    background.drawing=on \
    background.height=20 \
    background.corner_radius=5 \
    background.border_width=0 \
    background.padding_left=2 \
    background.padding_right=2 \
    padding_right=3 \
    drawing=off
done

# 当前 workspace 应用列表：放在左侧
for i in 1 2 3 4 5; do
  sketchybar --add item "space.app.${i}" left \
    --set "space.app.${i}" \
    label.font="$FONT:Regular:14.0" \
    label.color="$WHITE" \
    label.highlight_color="$MAGENTA" \
    icon.background.drawing=on \
    icon.background.height=20 \
    icon.background.width=20 \
    icon.background.image.scale=0.65 \
    padding_left=5 \
    padding_right=5 \
    drawing=off
done

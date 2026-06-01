#!/usr/bin/env bash
# AeroSpace workspace strip: fixed 0–9 slots per display; current workspace
# highlighted in place. Click a slot to switch to that workspace.

sketchybar --add event aerospace_workspace_change

# Manager: runs on aerospace_workspace_change and updates all space.* items.
sketchybar --add item spaces.manager left \
  --set spaces.manager \
  script="$PLUGIN_DIR/aerospace_spaces_update.sh" \
  updates=on \
  drawing=off
sketchybar --subscribe spaces.manager aerospace_workspace_change front_app_switched

# Detect monitors from AeroSpace; fall back to 1 if unavailable.
MONITOR_IDS=()
if command -v aerospace &>/dev/null; then
  while IFS= read -r line; do
    mid=$(echo "$line" | awk '{print $1}')
    [[ -n "$mid" ]] && MONITOR_IDS+=("$mid")
  done < <(aerospace list-monitors 2>/dev/null)
fi
[[ ${#MONITOR_IDS[@]} -eq 0 ]] && MONITOR_IDS=(1)

# Per-display items: each monitor gets its own workspace strip + app list.
for m in "${MONITOR_IDS[@]}"; do
  # Workspace digits 0–9
  for i in 0 1 2 3 4 5 6 7 8 9; do
    sketchybar --add item "space.ws.${i}.m${m}" center \
      --set "space.ws.${i}.m${m}" \
      display="$m" \
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

  # Current workspace app list (up to 5 apps)
  for i in 1 2 3 4 5; do
    sketchybar --add item "space.app.${i}.m${m}" left \
      --set "space.app.${i}.m${m}" \
      display="$m" \
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
done

#!/usr/bin/env bash
# AeroSpace workspace strip: 0–9 in order; focused workspace highlighted in place.
# Updates on aerospace_workspace_change and front_app_switched.

export PATH="/usr/local/bin:/opt/homebrew/bin:$PATH"

source "$CONFIG_DIR/colors.sh"

ANIM="sin"
DUR="10"

# Only debounce workspace events (AeroSpace can lag slightly). App switches stay instant.
if [ "${SENDER:-}" = "aerospace_workspace_change" ]; then
  sleep 0.05
fi

focused_ws=$(aerospace list-workspaces --focused 2>/dev/null | head -1)
[ -z "$focused_ws" ] && focused_ws="${FOCUSED_WORKSPACE:-}"

on_monitor=""
if command -v aerospace &>/dev/null; then
  on_monitor=$(aerospace list-workspaces --monitor focused 2>/dev/null)
fi

# Full workspace strip refresh (skip on front_app_switched — only app highlight changes).
if [ "${SENDER:-}" != "front_app_switched" ]; then
  for w in 0 1 2 3 4 5 6 7 8 9; do
    click_script="/opt/homebrew/bin/aerospace workspace ${w} 2>/dev/null || /usr/local/bin/aerospace workspace ${w}"
    if echo "$on_monitor" | grep -q "^${w}$"; then
      if [ -n "$focused_ws" ] && [ "$w" = "$focused_ws" ]; then
        sketchybar --animate "$ANIM" "$DUR" --set "space.ws.${w}" \
          drawing=on \
          icon="$w" \
          icon.color="$BLACK" \
          background.color="$GREEN" \
          background.border_color="$BLACK" \
          background.corner_radius=4 \
          click_script="$click_script"
      else
        sketchybar --animate "$ANIM" "$DUR" --set "space.ws.${w}" \
          drawing=on \
          icon="$w" \
          icon.color="$GREY" \
          background.color="$BACKGROUND_2" \
          background.border_color="$BLACK" \
          background.corner_radius=4 \
          click_script="$click_script"
      fi
    else
      sketchybar --animate "$ANIM" "$DUR" --set "space.ws.${w}" drawing=off
    fi
  done
fi

# Focused app: prefer $INFO on front_app_switched (no CLI wait); else ask AeroSpace.
focused_app=""
if [ -n "${INFO:-}" ]; then
  focused_app=$(echo "$INFO" | xargs)
fi
if [ -z "$focused_app" ] && command -v aerospace &>/dev/null; then
  focused_app=$(aerospace list-windows --focused --format "%{app-name}" 2>/dev/null | head -1)
  focused_app=$(echo "$focused_app" | xargs)
  focused_app="${focused_app#:}"
fi

# space.app.1..5: each slot = front_app style (icon + name); highlight the focused app
apps_list=()
if [ -n "$focused_ws" ] && command -v aerospace &>/dev/null; then
  while read -r app; do
    app=$(echo "$app" | xargs)
    app="${app#:}"
    [ -z "$app" ] && continue
    apps_list+=("$app")
  done < <(aerospace list-windows --workspace "$focused_ws" --format "%{app-name}" 2>/dev/null)
  # unique by order of first occurrence
  seen=()
  for a in "${apps_list[@]}"; do
    if [[ " ${seen[*]} " != *" ${a} "* ]]; then
      seen+=("$a")
    fi
  done
  apps_list=("${seen[@]}")
fi

# No --animate here: highlight / label color should update immediately on app switch.
for i in 1 2 3 4 5; do
  idx=$((i - 1))
  if [ "$idx" -lt "${#apps_list[@]}" ]; then
    app_name="${apps_list[$idx]}"
    is_focused="off"
    [ -n "$focused_app" ] && [ "$app_name" = "$focused_app" ] && is_focused="on"
    sketchybar --set "space.app.${i}" \
      drawing=on \
      label="$app_name" \
      label.highlight="$is_focused" \
      icon.background.image="app.$app_name"
  else
    sketchybar --set "space.app.${i}" drawing=off
  fi
done

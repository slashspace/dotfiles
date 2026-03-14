#!/usr/bin/env bash
# AeroSpace workspace strip: [inactive 1..9] | [active]. Updates on aerospace_workspace_change.

export PATH="/usr/local/bin:/opt/homebrew/bin:$PATH"

source "$CONFIG_DIR/colors.sh"

ANIM="sin"
DUR="10"

sleep 0.15

focused_ws=$(aerospace list-workspaces --focused 2>/dev/null | head -1)
[ -z "$focused_ws" ] && focused_ws="${FOCUSED_WORKSPACE:-}"

on_monitor=""
if command -v aerospace &>/dev/null; then
  on_monitor=$(aerospace list-workspaces --monitor focused 2>/dev/null)
fi

# Build ordered list of workspaces on this monitor; put focused last (so it appears on the right).
inactive_list=()
for ws in 0 1 2 3 4 5 6 7 8 9; do
  echo "$on_monitor" | grep -q "^${ws}$" || continue
  [ "$ws" = "$focused_ws" ] && continue
  inactive_list+=("$ws")
done

# Inactive slots (left): dark grey bg, light grey border, light grey number; click switches workspace.
for i in 1 2 3 4 5 6 7 8 9; do
  idx=$((i - 1))
  if [ "$idx" -lt "${#inactive_list[@]}" ]; then
    w="${inactive_list[$idx]}"
    click_script="/opt/homebrew/bin/aerospace workspace ${w} 2>/dev/null || /usr/local/bin/aerospace workspace ${w}"
    sketchybar --animate "$ANIM" "$DUR" --set "space.inactive.${i}" \
      drawing=on \
      icon="$w" \
      icon.color="$GREY" \
      background.color="$BACKGROUND_2" \
      background.border_color="$GREY" \
      background.corner_radius=4 \
      click_script="$click_script"
  else
    sketchybar --animate "$ANIM" "$DUR" --set "space.inactive.${i}" drawing=off
  fi
done

# Separator: show only when there are inactives.
if [ "${#inactive_list[@]}" -gt 0 ]; then
  sketchybar --animate "$ANIM" "$DUR" --set space.sep drawing=on background.color="$GREY"
else
  sketchybar --animate "$ANIM" "$DUR" --set space.sep drawing=off
fi

# Active workspace (right): white bg, dark number (inverted).
if [ -n "$focused_ws" ]; then
  sketchybar --animate "$ANIM" "$DUR" --set space.active \
    drawing=on \
    icon="$focused_ws" \
    icon.color="$BLACK" \
    background.color="$WHITE" \
    background.corner_radius=4
else
  sketchybar --animate "$ANIM" "$DUR" --set space.active drawing=off
fi

# Focused app in current workspace (for highlighting); from AeroSpace or from front_app_switched $INFO
focused_app=""
if command -v aerospace &>/dev/null; then
  focused_app=$(aerospace list-windows --focused --format "%{app-name}" 2>/dev/null | head -1)
  focused_app=$(echo "$focused_app" | xargs)
  focused_app="${focused_app#:}"
fi
[ -z "$focused_app" ] && [ -n "${INFO:-}" ] && focused_app=$(echo "$INFO" | xargs)

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

for i in 1 2 3 4 5; do
  idx=$((i - 1))
  if [ "$idx" -lt "${#apps_list[@]}" ]; then
    app_name="${apps_list[$idx]}"
    is_focused="off"
    bg_color="$BACKGROUND_2"
    [ -n "$focused_app" ] && [ "$app_name" = "$focused_app" ] && is_focused="on" && bg_color="$BACKGROUND_1"
    sketchybar --animate "$ANIM" "$DUR" --set "space.app.${i}" \
      drawing=on \
      label="$app_name" \
      label.highlight="$is_focused" \
      icon.background.image="app.$app_name" \
      background.color="$bg_color"
  else
    sketchybar --animate "$ANIM" "$DUR" --set "space.app.${i}" drawing=off
  fi
done

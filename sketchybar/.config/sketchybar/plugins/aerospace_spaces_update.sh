#!/usr/bin/env bash
# Single script for AeroSpace workspace strip: updates space.0..9 and space.windows
# on aerospace_workspace_change. One subscription, one script, one query pass.

export PATH="/usr/local/bin:/opt/homebrew/bin:$PATH"

source "$CONFIG_DIR/colors.sh"

# 工作区列表
WORKSPACES=(0 1 2 3 4 5 6 7 8 9)

# 动画效果
ANIM="sin"
# 动画持续时间
DUR="10"

sleep 0.15

focused_ws=$(aerospace list-workspaces --focused 2>/dev/null | head -1)
[ -z "$focused_ws" ] && focused_ws="${FOCUSED_WORKSPACE:-}"

on_monitor=""
if command -v aerospace &>/dev/null; then
  on_monitor=$(aerospace list-workspaces --monitor focused 2>/dev/null)
fi

for ws in "${WORKSPACES[@]}"; do
  if ! echo "$on_monitor" | grep -q "^${ws}$"; then
    sketchybar --animate "$ANIM" "$DUR" --set "space.${ws}" drawing=off
    continue
  fi

  sketchybar --animate "$ANIM" "$DUR" --set "space.${ws}" drawing=on

  count=0
  if command -v aerospace &>/dev/null; then
    count=$(aerospace list-windows --workspace "$ws" --count 2>/dev/null || echo 0)
  fi

  if [ "$focused_ws" = "$ws" ]; then
    # 当前激活的工作区
    sketchybar --animate "$ANIM" "$DUR" --set "space.${ws}" \
      icon="$ws" \
      icon.color="$YELLOW" \
      label.drawing=off \
      background.color="$BACKGROUND_1" \
      background.corner_radius=4
  elif [ "${count:-0}" -gt 0 ]; then
    # 有窗口的工作区
    sketchybar --animate "$ANIM" "$DUR" --set "space.${ws}" \
      icon="$ws" \
      icon.color="$WHITE" \
      label.drawing=off \
      background.color="$BACKGROUND_2" \
      background.corner_radius=4 \
      background.border_color="$BACKGROUND_2"
  else
    # 空的工作区
    sketchybar --animate "$ANIM" "$DUR" --set "space.${ws}" \
      icon="$ws" \
      icon.color="$GREY" \
      label.drawing=off \
      background.color="$TRANSPARENT" \
      background.corner_radius=4 \
      background.border_color="$BACKGROUND_2"
  fi
done

# space.app.1..5: each slot = front_app style (icon + name) for one app in focused workspace
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
    sketchybar --animate "$ANIM" "$DUR" --set "space.app.${i}" \
      drawing=on \
      label="$app_name" \
      icon.background.image="app.$app_name"
  else
    sketchybar --animate "$ANIM" "$DUR" --set "space.app.${i}" drawing=off
  fi
done

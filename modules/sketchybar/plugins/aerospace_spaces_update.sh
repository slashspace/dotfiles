#!/usr/bin/env bash
export PATH="/usr/local/bin:/opt/homebrew/bin:$PATH"

source "${DOTFILES_DIR:-$HOME/dotfiles}/system/themes/generated/sketchybar-colors.sh"

ANIM="sin"
DUR="10"

if [ "${SENDER:-}" = "aerospace_workspace_change" ]; then
  sleep 0.05
fi

focused_app=""
if [ -n "${INFO:-}" ]; then
  focused_app=$(echo "$INFO" | xargs)
fi
if [ -z "$focused_app" ] && command -v aerospace &>/dev/null; then
  focused_app=$(aerospace list-windows --focused --format "%{app-name}" 2>/dev/null | head -1)
  focused_app=$(echo "$focused_app" | xargs)
  focused_app="${focused_app#:}"
fi

declare -A monitor_visible
declare -A monitor_workspaces

while IFS=' ' read -r ws is_visible monitor_id; do
  [[ -z "$ws" || -z "$monitor_id" ]] && continue
  monitor_workspaces["$monitor_id"]+="$ws "
  [[ "$is_visible" == "true" ]] && monitor_visible["$monitor_id"]="$ws"
done < <(aerospace list-workspaces --all --format '%{workspace} %{workspace-is-visible} %{monitor-id}' 2>/dev/null)

for m in "${!monitor_visible[@]}"; do
  visible_ws="${monitor_visible[$m]}"

  if [ "${SENDER:-}" != "front_app_switched" ]; then
    for w in 0 1 2 3 4 5 6 7 8 9; do
      item="space.ws.${w}.m${m}"
      click_script="/opt/homebrew/bin/aerospace workspace ${w} 2>/dev/null || /usr/local/bin/aerospace workspace ${w}"

      if [[ " ${monitor_workspaces[$m]} " == *" ${w} "* ]]; then
        win_count=$(aerospace list-windows --workspace "$w" 2>/dev/null | wc -l | tr -d ' ')

        if [ "$w" = "$visible_ws" ]; then
          sketchybar --animate "$ANIM" "$DUR" --set "$item" \
            drawing=on icon="$w" icon.color="$BLACK" \
            background.color="$MAGENTA" background.border_color="$TRANSPARENT" \
            background.border_width=0 click_script="$click_script"
        elif [ "$win_count" -gt 0 ]; then
          sketchybar --animate "$ANIM" "$DUR" --set "$item" \
            drawing=on icon="$w" icon.color="$WHITE" \
            background.color="$TRANSPARENT" background.border_color="$TRANSPARENT" \
            background.border_width=0 click_script="$click_script"
        else
          sketchybar --animate "$ANIM" "$DUR" --set "$item" \
            drawing=on icon="$w" icon.color="$GREY" \
            background.color="$TRANSPARENT" background.border_color="$TRANSPARENT" \
            background.border_width=0 click_script="$click_script"
        fi
      else
        sketchybar --animate "$ANIM" "$DUR" --set "$item" drawing=off
      fi
    done
  fi

  apps_list=()
  if [ -n "$visible_ws" ] && command -v aerospace &>/dev/null; then
    while read -r app; do
      app=$(echo "$app" | xargs)
      app="${app#:}"
      [ -z "$app" ] && continue
      apps_list+=("$app")
    done < <(aerospace list-windows --workspace "$visible_ws" --format "%{app-name}" 2>/dev/null)
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
    item="space.app.${i}.m${m}"
    if [ "$idx" -lt "${#apps_list[@]}" ]; then
      app_name="${apps_list[$idx]}"
      is_focused="off"
      [ -n "$focused_app" ] && [ "$app_name" = "$focused_app" ] && is_focused="on"
      sketchybar --set "$item" \
        drawing=on label="$app_name" label.highlight="$is_focused" \
        icon.background.image="app.$app_name"
    else
      sketchybar --set "$item" drawing=off
    fi
  done
done

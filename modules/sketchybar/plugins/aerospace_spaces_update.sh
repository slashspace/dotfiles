#!/usr/bin/env bash
# AeroSpace 工作区条：按 0-9 顺序显示，当前工作区在原位高亮。
# 在 aerospace_workspace_change 与 front_app_switched 事件下刷新。

export PATH="/usr/local/bin:/opt/homebrew/bin:$PATH"

source "$CONFIG_DIR/colors.sh"

ANIM="sin"
DUR="10"

# 仅对工作区切换事件做轻微防抖（AeroSpace 状态更新会有轻微延迟）；切 app 保持即时刷新。
if [ "${SENDER:-}" = "aerospace_workspace_change" ]; then
  sleep 0.05
fi

focused_ws=$(aerospace list-workspaces --focused 2>/dev/null | head -1)
[ -z "$focused_ws" ] && focused_ws="${FOCUSED_WORKSPACE:-}"

on_monitor=""
if command -v aerospace &>/dev/null; then
  on_monitor=$(aerospace list-workspaces --monitor focused 2>/dev/null)
fi

# 完整刷新工作区条（front_app_switched 时跳过——该事件只需要更新 app 高亮）。
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
          background.corner_radius=6 \
          click_script="$click_script"
      else
        sketchybar --animate "$ANIM" "$DUR" --set "space.ws.${w}" \
          drawing=on \
          icon="$w" \
          icon.color="$GREY" \
          background.color="$BACKGROUND_2" \
          background.border_color="$BLACK" \
          background.corner_radius=6 \
          click_script="$click_script"
      fi
    else
      sketchybar --animate "$ANIM" "$DUR" --set "space.ws.${w}" drawing=off
    fi
  done
fi

# 当前焦点应用：优先使用 front_app_switched 事件里的 $INFO（避免 CLI 查询等待）；为空时再向 AeroSpace 查询。
focused_app=""
if [ -n "${INFO:-}" ]; then
  focused_app=$(echo "$INFO" | xargs)
fi
if [ -z "$focused_app" ] && command -v aerospace &>/dev/null; then
  focused_app=$(aerospace list-windows --focused --format "%{app-name}" 2>/dev/null | head -1)
  focused_app=$(echo "$focused_app" | xargs)
  focused_app="${focused_app#:}"
fi

# space.app.1..5：每个槽位沿用 front_app 风格（图标 + 名称）；对焦点应用做高亮。
apps_list=()
if [ -n "$focused_ws" ] && command -v aerospace &>/dev/null; then
  while read -r app; do
    app=$(echo "$app" | xargs)
    app="${app#:}"
    [ -z "$app" ] && continue
    apps_list+=("$app")
  done < <(aerospace list-windows --workspace "$focused_ws" --format "%{app-name}" 2>/dev/null)
  # 按首次出现顺序去重
  seen=()
  for a in "${apps_list[@]}"; do
    if [[ " ${seen[*]} " != *" ${a} "* ]]; then
      seen+=("$a")
    fi
  done
  apps_list=("${seen[@]}")
fi

# 这里不使用 --animate：切换 app 时，高亮与文字颜色需要立即更新。
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

# 当前焦点工作区的根容器布局（h_* = 横向，v_* = 纵向）；app-only 刷新事件时跳过。
if [ "${SENDER:-}" != "front_app_switched" ] && command -v aerospace &>/dev/null; then
  root_layout=$(aerospace list-workspaces --focused --format '%{workspace-root-container-layout}' 2>/dev/null | head -1)
  root_layout=$(echo "$root_layout" | xargs)
  # Nerd Font 私有区 U+F07D / U+F07E：必须以 UTF-8 字节写入变量；
  # 不要写字面量 \uf07d（会在 bar 上原样显示文本）。
  # 在部分运行环境（如 SketchyBar 拉起的 bash）里，$'\x..' 比 printf '\u..' 更稳定。
  _ic_h=$'\xef\x81\xbd'
  _ic_v=$'\xef\x81\xbe'
  layout_icon=""
  case "$root_layout" in
    h_accordion) layout_icon="$_ic_v" ;;
    v_accordion) layout_icon="$_ic_h" ;;
    h_tiles) layout_icon="$_ic_h" ;;
    v_tiles) layout_icon="$_ic_v" ;;
  esac
  if [ -n "$layout_icon" ]; then
    sketchybar --set space.layout \
      drawing=on \
      icon="$layout_icon" \
      icon.color="$BLUE" \
      background.drawing=on \
      background.height=20 \
      background.width=20 \
      background.corner_radius=6 \
      background.border_width=1 \
      background.color="$BAR_COLOR" \
      background.border_color="$BLACK"
  else
    sketchybar --set space.layout drawing=off background.drawing=off icon=""
  fi
fi

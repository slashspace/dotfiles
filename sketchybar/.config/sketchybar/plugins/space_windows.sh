#!/bin/bash
# 查看日志：tail -f ~/dotfiles/sketchybar/debug.log

# 调试日志文件
DEBUG_LOG="$HOME/dotfiles/sketchybar/debug.log"
ENABLE_DEBUG=true

# 调试函数：同时输出到日志文件和stderr
debug_log() {
  if [ "$ENABLE_DEBUG" = true ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$DEBUG_LOG" 2>&1
    echo "[space_windows.sh] $*" >&2
  fi
}

debug_log "=== Script started ==="
debug_log "SENDER: $SENDER"
debug_log "FOCUSED_WORKSPACE: $FOCUSED_WORKSPACE"
debug_log "CONFIG_DIR: $CONFIG_DIR"

# 获取当前激活的workspace
if [ -n "$FOCUSED_WORKSPACE" ]; then
    active_workspace="$FOCUSED_WORKSPACE"
    debug_log "Using FOCUSED_WORKSPACE: $active_workspace"
else
    active_workspace=$(aerospace list-workspaces --focused 2>/dev/null | head -1)
    debug_log "Fetched active workspace: $active_workspace"
fi

if [ "$SENDER" = "aerospace_workspace_change" ]; then
    debug_log "Processing aerospace_workspace_change event"

    # 获取当前workspace的应用程序列表
    windows_raw=$(aerospace list-windows --workspace focused 2>&1)
    debug_log "Raw windows output: $windows_raw"

    apps=$(echo "$windows_raw" | awk -F'|' '{print $2}' | sort -u)
    debug_log "Extracted apps: $apps"

    icon_strip=" "
    if [ -n "${apps}" ]; then
      debug_log "Processing apps list"
      while read -r app
      do
        if [ -n "$app" ]; then
          app=$(echo "$app" | xargs)  # trim whitespace
          if [ -n "$app" ]; then
            debug_log "Processing app: '$app'"
            icon=$($CONFIG_DIR/plugins/icon_map.sh "$app" 2>&1)
            debug_log "  Icon for '$app': '$icon'"
            icon_strip+=" $icon"
          fi
        fi
      done <<< "${apps}"
    else
      debug_log "No apps found, using default icon"
      icon_strip=" —"
    fi

    debug_log "Final icon_strip: '$icon_strip'"
    sketchybar --animate sin 10 --set space.active label="$icon_strip"
    debug_log "Updated space.active label"
else
    debug_log "SENDER is not aerospace_workspace_change, skipping"
fi

debug_log "=== Script ended ==="

#!/bin/bash

export PATH="/opt/homebrew/bin:$PATH"

case "$SENDER" in
  front_app_switched|forced|aerospace_workspace_change) ;;
  *) exit 0 ;;
esac

APP="${INFO:-}"
if [ -z "$APP" ]; then
  APP=$(aerospace list-windows --focused --format '%{app-name}' 2>/dev/null | head -1)
fi
[ -n "$APP" ] || exit 0

COUNT=$(aerospace list-windows --all --format '%{app-name}' 2>/dev/null | awk -v app="$APP" '$0 == app { n++ } END { print n+0 }')
COUNT="${COUNT:-0}"

# Nearest-neighbor scaling frays the squircle. A 64px PNG at scale 0.5 is a
# 1:1 blit on the bar's 2x surface.
ICON_BIN="${HOME}/.cache/sketchybar/front-app-icon"
ICON_DIR="${HOME}/.cache/sketchybar/app-icons"
WS=$(aerospace list-workspaces --focused 2>/dev/null | head -1)
[ -n "$WS" ] || WS="–"
SAFE=$(printf '%s' "$APP" | tr '/:' '__')
SAFE_WS=$(printf '%s' "$WS" | tr '/: ' '___')
ICON_PNG="${ICON_DIR}/${SAFE}-${SAFE_WS}.png"
mkdir -p "$ICON_DIR"
if [ -x "$ICON_BIN" ] && { [ -f "$ICON_PNG" ] || "$ICON_BIN" "$APP" "$ICON_PNG" "$WS"; }; then
  ICON_IMAGE="$ICON_PNG"
  ICON_SCALE=0.5
else
  ICON_IMAGE="app.${APP}"
  ICON_SCALE=1
fi

if [ "$COUNT" -gt 1 ]; then
  sketchybar --set "$NAME" label="$COUNT" label.drawing=on \
             icon.background.drawing=on \
             icon.background.image="$ICON_IMAGE" \
             icon.background.image.scale="$ICON_SCALE"
else
  sketchybar --set "$NAME" label.drawing=off \
             icon.background.drawing=on \
             icon.background.image="$ICON_IMAGE" \
             icon.background.image.scale="$ICON_SCALE"
fi

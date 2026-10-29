#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

DND_FILE="${HOME}/Library/DoNotDisturb/DB/Assertions.json"
if [ ! -f "$DND_FILE" ]; then
  sketchybar --set dnd drawing=off icon.drawing=off label=""
  exit 0
fi

DND_ENABLED=$(plutil -convert json -o - "$DND_FILE" 2>/dev/null | jq -r '.data[0].storeAssertionRecords // empty' 2>/dev/null || true)

if [ -z "$DND_ENABLED" ] || [ "$DND_ENABLED" = "null" ]; then
  sketchybar --set dnd drawing=off icon.drawing=off label=""
else
  sketchybar --set dnd drawing=on icon="$DND" icon.drawing=on icon.color="$ORANGE" label="DND" label.color="$ORANGE"
fi

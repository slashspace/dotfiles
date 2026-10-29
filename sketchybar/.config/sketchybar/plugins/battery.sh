#!/bin/sh

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

BATTERY_INFO="$(pmset -g batt)"
if ! echo "$BATTERY_INFO" | grep -q "InternalBattery"; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

PERCENTAGE="$(printf '%s' "$BATTERY_INFO" | grep -Eo "[0-9]+%" | cut -d% -f1)"
CHARGING="$(printf '%s' "$BATTERY_INFO" | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

sketchybar --set "$NAME" drawing=on

ICON=$BATTERY_0
ICON_COLOR=$BATTERY_5
case ${PERCENTAGE} in
  [8-9][0-9]|100)
    ICON=$BATTERY_100
    ICON_COLOR=$BATTERY_1
    ;;
  7[0-9])
    ICON=$BATTERY_75
    ICON_COLOR=$BATTERY_2
    ;;
  [4-6][0-9])
    ICON=$BATTERY_50
    ICON_COLOR=$BATTERY_3
    ;;
  [1-3][0-9])
    ICON=$BATTERY_25
    ICON_COLOR=$BATTERY_4
    ;;
  [0-9])
    ICON=$BATTERY_0
    ICON_COLOR=$BATTERY_5
    ;;
esac

if [ -n "$CHARGING" ]; then
  ICON=$BATTERY_CHARGING
  ICON_COLOR=$YELLOW
fi

sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%" icon.color="$ICON_COLOR"

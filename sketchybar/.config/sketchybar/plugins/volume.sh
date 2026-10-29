#!/bin/bash

export PATH="/opt/homebrew/bin:$PATH"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

volume_change() {
  case $INFO in
    [6-9][0-9]|100) ICON=$VOLUME_100 ;;
    [3-5][0-9]) ICON=$VOLUME_66 ;;
    [1-2][0-9]) ICON=$VOLUME_33 ;;
    [1-9]) ICON=$VOLUME_10 ;;
    0) ICON=$VOLUME_0 ;;
    *) ICON=$VOLUME_100 ;;
  esac

  OUTPUT=$(SwitchAudioSource -t output -c 2>/dev/null || true)
  case "$OUTPUT" in
    *AirPods*) ICON=$AIRPODS ;;
    *Headphone*|*EarPod*|*External*) ICON=$HEADPHONES ;;
  esac

  MUTED="$(osascript -e 'output muted of (get volume settings)' 2>/dev/null || true)"
  if [ "$MUTED" = "true" ]; then
    ICON=$VOLUME_0
  fi

  STATE="${HOME}/.cache/sketchybar/volume.pct"
  mkdir -p "${HOME}/.cache/sketchybar"
  PREV="$(cat "$STATE" 2>/dev/null || true)"
  printf '%s' "$INFO" >"$STATE"

  sketchybar --set volume_icon icon="$ICON" \
             --set volume slider.percentage="$INFO"

  # The slider stays collapsed. It opens only while the volume is changing.
  [ -n "$PREV" ] && [ "$PREV" != "$INFO" ] || return 0
  TOKEN="$$-$RANDOM"
  printf '%s' "$TOKEN" >"${HOME}/.cache/sketchybar/volume-slider.token"
  sketchybar --animate tanh 30 --set volume slider.width=100
  (
    sleep 2
    if [ "$(cat "${HOME}/.cache/sketchybar/volume-slider.token" 2>/dev/null)" = "$TOKEN" ]; then
      sketchybar --animate tanh 30 --set volume slider.width=0
    fi
  ) &
}

mouse_clicked() {
  osascript -e "set volume output volume $PERCENTAGE" \
            -e 'set volume output muted false'
}

case "$SENDER" in
  volume_change) volume_change ;;
  mouse.clicked) mouse_clicked ;;
esac

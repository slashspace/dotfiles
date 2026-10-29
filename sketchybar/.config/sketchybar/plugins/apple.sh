#!/bin/bash

export PATH="/opt/homebrew/bin:$PATH"
FLAG="${HOME}/.cache/sketchybar/apple-popup.on"

close_others() {
  rm -f "${HOME}/.cache/sketchybar/cliamp-popup.on"
  sketchybar --set volume_icon popup.drawing=off \
             --set mic popup.drawing=off \
             --set cliamp.title popup.drawing=off \
             --set timer popup.drawing=off \
             --set cpu.graph popup.drawing=off \
             --set ram.graph popup.drawing=off \
             --set gpu.graph popup.drawing=off
}

if [ "$1" = "bluetooth" ]; then
  sketchybar --set apple.logo popup.drawing=off
  rm -f "$FLAG"
  if command -v blueutil >/dev/null 2>&1; then
    blueutil --power toggle
  else
    open "x-apple.systempreferences:com.apple.BluetoothSettings"
  fi
  exit 0
fi

if [ "$1" = "restart" ]; then
  sketchybar --set apple.logo popup.drawing=off
  rm -f "$FLAG"
  answer=$(osascript -e 'display dialog "重新启动这台 Mac？" buttons {"取消", "重新启动"} default button "取消"' -e 'button returned of result' 2>/dev/null || true)
  if [ "$answer" = "重新启动" ]; then
    osascript -e 'tell application "System Events" to restart'
  fi
  exit 0
fi

mkdir -p "${HOME}/.cache/sketchybar"
if [ -f "$FLAG" ]; then
  rm -f "$FLAG"
  sketchybar --set apple.logo popup.drawing=off
else
  close_others
  touch "$FLAG"
  sketchybar --set apple.logo popup.drawing=on
fi

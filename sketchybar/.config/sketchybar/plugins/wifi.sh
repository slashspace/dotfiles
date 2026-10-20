#!/bin/bash

SSID=$(networksetup -getairportnetwork en0 2>/dev/null | awk -F': ' '/Current Wi-Fi Network/ {print $2}')

sketchybar --set wifi \
  icon= \
  icon.color=0xff39FF14 \
  icon.align=center \
  label="$SSID"

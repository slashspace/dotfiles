#!/bin/bash

export PATH="/opt/homebrew/bin:$PATH"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

wifi_device() {
  local dev
  for dev in en0 en1 en2; do
    if echo "show State:/Network/Interface/${dev}/AirPort" | /usr/sbin/scutil | grep -q "Power Status"; then
      echo "$dev"
      return
    fi
  done
  echo en0
}

update() {
  local device interface ip ssid icon color label
  device=$(wifi_device)
  interface=$(route get default 2>/dev/null | awk '/interface:/{print $2; exit}')
  [ -n "$interface" ] || interface=$device
  ip=$(ipconfig getifaddr "$interface" 2>/dev/null)
  ssid=$(networksetup -getairportnetwork "$device" 2>/dev/null | awk -F ': ' 'NF>1 {print $2}')
  case "$ssid" in
    "You are not associated with an AirPort network." | "") ssid="" ;;
  esac

  if [ "$interface" = "$device" ]; then
    if [ -n "$ip" ]; then
      icon=$WIFI_CONNECTED
      color=$GREEN
    else
      icon=$WIFI_DISCONNECTED
      color=$GREY
    fi
  else
    if [ -n "$ip" ]; then
      icon=$ETHERNET_CONNECTED
      color=$GREEN
    else
      icon=$WIFI_DISCONNECTED
      color=$GREY
    fi
  fi

  if [ -n "$ip" ]; then
    label="${ssid:+$ssid }$ip"
  else
    label="Disconnected"
  fi

  sketchybar --set "$NAME" icon="$icon" icon.color="$color" label="$label"
}

click() {
  local width
  width=$(sketchybar --query "$NAME" | jq -r '.label.width')
  if [ "$width" = "0" ]; then
    sketchybar --animate sin 20 --set "$NAME" label.width=dynamic
  else
    sketchybar --animate sin 20 --set "$NAME" label.width=0
  fi
}

case "$SENDER" in
  wifi_change) update ;;
  mouse.clicked) click ;;
  *) update ;;
esac

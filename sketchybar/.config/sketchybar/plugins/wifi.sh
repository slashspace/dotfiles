#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# macOS redacts SSID_STR unless the process has Location permission, so a
# non-empty name cannot mean "connected". Link status is not redacted.
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

DEVICE=$(wifi_device)
STATUS=$(/sbin/ifconfig "$DEVICE" 2>/dev/null | awk '/status:/{print $2; exit}')

COLOR=$GREY
if [ "$STATUS" = "active" ]; then
  COLOR=$GREEN
fi

sketchybar --set wifi \
  icon= \
  icon.color=$COLOR \
  icon.align=center

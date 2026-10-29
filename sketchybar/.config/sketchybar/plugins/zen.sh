#!/bin/bash

# Click the clock to hide the status cluster, then click again to bring it back.
FLAG="${HOME}/.cache/sketchybar/zen.on"

zen_on() {
  touch "$FLAG"
  sketchybar --set volume drawing=off \
             --set volume_icon drawing=off \
             --set wifi drawing=off \
             --set dnd drawing=off \
             --set timer drawing=off \
             --set '/disk.*/' drawing=off \
             --set '/gpu.*/' drawing=off
}

zen_off() {
  rm -f "$FLAG"
  sketchybar --set volume drawing=on \
             --set volume_icon drawing=on \
             --set wifi drawing=on \
             --set timer drawing=on \
             --set '/disk.*/' drawing=on \
             --set '/gpu.*/' drawing=on
}

if [ -f "$FLAG" ]; then
  zen_off
else
  zen_on
fi

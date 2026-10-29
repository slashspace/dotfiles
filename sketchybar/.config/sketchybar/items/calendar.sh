#!/bin/bash

# Date and time share one column. The date item has no layout width, so it
# sits on the time instead of opening a second gap.
calendar_date=(
  label.font="$FONT:Bold:11.0"
  label="---"
  label.width=75
  label.align=center
  label.y_offset=5
  label.padding_left=0
  label.padding_right=0
  width=0
  icon.drawing=off
  background.drawing=off
  update_freq=30
  script="$PLUGIN_DIR/calendar.sh"
  click_script="$PLUGIN_DIR/zen.sh"
)

calendar_time=(
  label.font="$FONT:Bold:11.0"
  label="00:00"
  label.width=75
  label.align=center
  label.y_offset=-5
  label.padding_left=0
  label.padding_right=0
  padding_left=10
  width=75
  icon.drawing=off
  background.drawing=off
  click_script="$PLUGIN_DIR/zen.sh"
)

sketchybar --add item calendar.date right \
           --set calendar.date "${calendar_date[@]}" \
           --subscribe calendar.date system_woke \
           --add item calendar.time right \
           --set calendar.time "${calendar_time[@]}"

#!/bin/sh

volume_slider=(
  script="$PLUGIN_DIR/volume.sh"
  updates=on
  slider.width=0
  label.drawing=off
  icon.drawing=off
  slider.highlight_color=$BLUE
  slider.background.height=5
  slider.background.corner_radius=2
  slider.background.color=$BG2
  background.drawing=off
  padding_left=0
  padding_right=0
  slider.knob=⬤
  slider.knob.font="$FONT:Regular:11.0"
  slider.knob.drawing=on
)

volume_icon=(
  click_script="$PLUGIN_DIR/volume_click.sh"
  padding_left=4
  padding_right=4
  icon=$VOLUME_100
  icon.color=$WHITE
  icon.font="$FONT:Regular:14.0"
  icon.padding_left=6
  icon.padding_right=6
  label.drawing=off
  background.drawing=off
  popup.align=right
  popup.y_offset=6
  popup.height=28
  popup.background.color=$BAR_COLOR
  popup.background.border_color=$WHITE
  popup.background.border_width=2
  popup.background.corner_radius=9
  popup.background.drawing=on
)

sketchybar --add item volume_icon right \
           --set volume_icon "${volume_icon[@]}" \
           --add slider volume right \
           --set volume "${volume_slider[@]}" \
           --subscribe volume volume_change mouse.clicked

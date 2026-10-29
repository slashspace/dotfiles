#!/bin/bash

rm -f "${HOME}/.cache/sketchybar/cliamp-bar.state"

cliamp_item=(
  label.drawing=off
  background.drawing=off
  icon.color="$WHITE"
  icon.font="$FONT:Regular:20.0"
  icon.y_offset=0
  icon.padding_left=6
  icon.padding_right=6
  y_offset=0
  drawing=off
)

sketchybar --add item cliamp.prev center \
           --set cliamp.prev "${cliamp_item[@]}" \
                 icon= \
                 click_script="$PLUGIN_DIR/cliamp.sh prev" \
           --add item cliamp.play center \
           --set cliamp.play "${cliamp_item[@]}" \
                 icon= \
                 script="$PLUGIN_DIR/cliamp.sh" \
                 updates=on \
                 update_freq=1 \
                 click_script="$PLUGIN_DIR/cliamp.sh toggle" \
           --add item cliamp.next center \
           --set cliamp.next "${cliamp_item[@]}" \
                 icon= \
                 click_script="$PLUGIN_DIR/cliamp.sh next" \
           --add item cliamp.title center \
           --set cliamp.title \
                 icon.drawing=off \
                 background.drawing=off \
                 padding_left=4 \
                 padding_right=0 \
                 label.color="$BLUE" \
                 label.font="$FONT:Regular:12.0" \
                 label.align=center \
                 label.width=140 \
                 label.max_chars=11 \
                 label.padding_left=0 \
                 label.padding_right=0 \
                 y_offset=0 \
                 label.y_offset=4 \
                 scroll_texts=off \
                 drawing=off \
                 click_script="$PLUGIN_DIR/cliamp.sh popup" \
                 script="$PLUGIN_DIR/cliamp.sh" \
                 popup.align=center \
                 popup.y_offset=6 \
                 popup.height=180 \
                 popup.blur_radius=0 \
                 popup.background.color="$TRANSPARENT" \
                 popup.background.border_width=0 \
                 popup.background.corner_radius=0 \
                 popup.background.shadow.drawing=off \
                 popup.background.drawing=on \
           --add item cliamp.lyric center \
           --set cliamp.lyric \
                 icon.drawing=off \
                 background.drawing=off \
                 padding_left=-140 \
                 padding_right=4 \
                 label.color="$GREY" \
                 label.font="$FONT:Regular:8.0" \
                 label.align=center \
                 label.width=140 \
                 label.max_chars=16 \
                 label.padding_left=0 \
                 label.padding_right=0 \
                 y_offset=-8 \
                 scroll_texts=off \
                 drawing=off \
                 click_script="$PLUGIN_DIR/cliamp.sh popup" \
           --add item cliamp.vis center \
           --set cliamp.vis \
                 icon.drawing=off \
                 label.drawing=off \
                 background.drawing=on \
                 background.color="$TRANSPARENT" \
                 background.border_width=0 \
                 background.height=32 \
                 background.corner_radius=0 \
                 padding_left=4 \
                 padding_right=0 \
                 y_offset=0 \
                 drawing=off \
                 click_script="$PLUGIN_DIR/cliamp.sh popup" \
           --add item cliamp.card popup.cliamp.title \
           --set cliamp.card \
                 icon.drawing=off \
                 label.drawing=off \
                 background.drawing=on \
                 background.color="$TRANSPARENT" \
                 background.border_width=0 \
                 background.height=180 \
                 background.corner_radius=0 \
                 padding_left=0 \
                 padding_right=0 \
                 click_script="rm -f \"\$HOME/.cache/sketchybar/cliamp-popup.on\"; sketchybar --set cliamp.title popup.drawing=off" \
           --add bracket cliamp.group cliamp.prev cliamp.play cliamp.next cliamp.title cliamp.lyric cliamp.vis \
           --set cliamp.group \
                 background.drawing=off \
                 drawing=off

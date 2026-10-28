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
                 padding_left=8 \
                 padding_right=0 \
                 label.color="$WHITE" \
                 label.font="$FONT:Regular:13.0" \
                 label.align=center \
                 label.width=220 \
                 label.max_chars=16 \
                 label.padding_left=0 \
                 label.padding_right=0 \
                 y_offset=7 \
                 scroll_texts=off \
                 drawing=off \
                 click_script="$PLUGIN_DIR/cliamp.sh popup" \
                 script="$PLUGIN_DIR/cliamp.sh" \
                 popup.align=center \
                 popup.y_offset=6 \
                 popup.height=180 \
                 popup.background.color="$PURE_BLACK" \
                 popup.background.border_color="$BACKGROUND_2" \
                 popup.background.border_width=1 \
                 popup.background.corner_radius=8 \
                 popup.background.drawing=on \
           --add item cliamp.lyric center \
           --set cliamp.lyric \
                 icon.drawing=off \
                 background.drawing=off \
                 padding_left=-220 \
                 padding_right=12 \
                 label.color="$GREY" \
                 label.font="$FONT:Regular:11.0" \
                 label.align=center \
                 label.width=220 \
                 label.max_chars=19 \
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
                 background.height=32 \
                 background.corner_radius=0 \
                 padding_left=6 \
                 padding_right=10 \
                 y_offset=0 \
                 drawing=off \
                 click_script="$PLUGIN_DIR/cliamp.sh popup" \
           --add item cliamp.card popup.cliamp.title \
           --set cliamp.card \
                 icon.drawing=off \
                 label.drawing=off \
                 background.drawing=on \
                 background.color="$PURE_BLACK" \
                 background.height=180 \
                 background.corner_radius=0 \
                 padding_left=0 \
                 padding_right=0 \
                 click_script="rm -f \"\$HOME/.cache/sketchybar/cliamp-popup.on\"; sketchybar --set cliamp.title popup.drawing=off" \
           --add bracket cliamp.group cliamp.prev cliamp.play cliamp.next cliamp.title cliamp.lyric cliamp.vis \
           --set cliamp.group \
                 background.color="$PURE_BLACK" \
                 background.corner_radius=6 \
                 background.height=34 \
                 drawing=off

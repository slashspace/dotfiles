#!/bin/bash
sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all);
do
    sketchybar --add item space.$sid left \
      --subscribe space.$sid aerospace_workspace_change \
      --set space.$sid \
      icon="$sid" \
      icon.padding_left=10 \
      icon.padding_right=10 \
      padding_left=2 \
      padding_right=2 \
      label.padding_right=20 \
      icon.highlight_color=$RED \
      label.color=$GREY \
      label.highlight_color=$WHITE \
      label.font="sketchybar-app-font:Regular:16.0" \
      label.y_offset=-1 \
      background.color=$BACKGROUND_1 \
      background.border_color=$BACKGROUND_2 \
      script="$PLUGIN_DIR/space.sh $sid" \
      click_script="aerospace workspace $sid"
done

space_creator=(
  icon=􀆊
  icon.font="$FONT:Heavy:16.0"
  padding_left=10
  padding_right=8
  label.drawing=off
  display=active
  script="$PLUGIN_DIR/space_windows.sh"
  icon.color=$WHITE
)

sketchybar --add item space_creator left               \
           --set space_creator "${space_creator[@]}"   \
           --subscribe space_creator aerospace_workspace_change space_windows_change

#!/bin/bash

# 设置栏的位置、高度、模糊半径和颜色
# 参考： https://felixkratz.github.io/SketchyBar/config/bar
bar=(
  position=top  
  height=40
  blur_radius=0
  color="$TRANSPARENT"
  padding_left=5
  padding_right=5
)
sketchybar --bar "${bar[@]}"

# 设置栏的默认样式
# 参考： https://felixkratz.github.io/SketchyBar/config/items#changing-the-default-values-for-all-further-items
default=(
  padding_left=4
  padding_right=4
  background.color="$ITEM_BG_COLOR"
  background.corner_radius=5
  background.height=25
  icon.color=$WHITE
  icon.y_offset=1
  label.color=$WHITE
  label.y_offset=1
  icon.padding_left=10
  icon.padding_right=4
  label.padding_left=4
  label.padding_right=10
)
sketchybar --default "${default[@]}"


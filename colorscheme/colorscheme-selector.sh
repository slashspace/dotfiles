#!/usr/bin/env bash

# Path to the directory containing color scheme scripts
# 颜色方案脚本所在目录的路径
COLORSCHEME_DIR=$HOME/dotfiles/colorscheme/list

# Path to the colorscheme-set.sh script
# 颜色方案设置脚本的路径
COLORSCHEME_SET_SCRIPT=$HOME/dotfiles/zsh/.zshrc/colorscheme-set.sh

# Ensure fzf is installed
# 确保 fzf 已安装
if ! command -v fzf &>/dev/null; then
  echo "fzf is not installed. Please install it first."
  exit 1
fi

# List available color scheme scripts
# 列出颜色方案脚本目录中的所有脚本
schemes=($(ls "$COLORSCHEME_DIR"/*.sh | xargs -n 1 basename))

# Check if any schemes are available
# 检查是否存在任何颜色方案脚本
if [ ${#schemes[@]} -eq 0 ]; then
  echo "No color scheme scripts found in $COLORSCHEME_DIR."
  exit 1
fi

# Use fzf to select a scheme
# 使用 fzf 选择一个颜色方案
selected_scheme=$(printf "%s\n" "${schemes[@]}" | fzf --height=100% --reverse --header="Type or move using arrows" --prompt="Select a colorscheme > ")

# Check if a selection was made
# 检查是否选择了颜色方案
if [ -z "$selected_scheme" ]; then
  echo "No color scheme selected."
  exit 0
fi

# Apply the selected color scheme
# 应用选定的颜色方案
"$COLORSCHEME_SET_SCRIPT" "$selected_scheme"

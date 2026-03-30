#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
# 立即退出脚本，如果任何命令返回非零状态
set -e

# 仓库根目录，便于克隆到非 ~/dotfiles 时通过环境变量覆盖
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

# Function to display error messages
# 定义一个错误处理函数，用于显示错误消息并退出脚本
error() {
  echo "Error: $1" >&2
  exit 1
}

# Ensure a colorscheme profile is provided
# 确保提供了一个颜色方案配置文件
if [ -z "$1" ]; then
  error "No colorscheme profile provided"
fi

# Use the first argument as the colorscheme profile
# 将第一个参数作为颜色方案配置文件
colorscheme_profile="$1"

# Define paths
# 定义颜色方案文件和当前活跃的颜色方案文件的路径
colorscheme_file="$DOTFILES_DIR/support/colorscheme/list/$colorscheme_profile"
active_file="$DOTFILES_DIR/support/colorscheme/active/active-colorscheme.sh"
vars_file="$DOTFILES_DIR/support/colorscheme/colorscheme-vars.sh"

# Check if the colorscheme file exists
# 检查颜色方案文件是否存在
if [ ! -f "$colorscheme_file" ]; then
  error "Colorscheme file '$colorscheme_file' does not exist."
fi

# If active-colorscheme.sh doesn't exist, create it
# 如果当前活跃的颜色方案文件不存在，则创建它
if [ ! -f "$active_file" ]; then
  echo "Active colorscheme file not found. Creating '$active_file'."
  cp "$colorscheme_file" "$active_file"
  UPDATED=true
else
  # Compare the new colorscheme with the active one
  # 比较新的颜色方案与当前活跃的颜色方案
  if ! diff -q "$active_file" "$colorscheme_file" >/dev/null; then
    UPDATED=true
  else
    UPDATED=false
  fi
fi

generate_ghostty_config() {
  ghostty_conf_file="$DOTFILES_DIR/ghostty/.config/ghostty/themes/active"

  cat >"$ghostty_conf_file" <<EOF
background = $linkarzu_color10
foreground = $linkarzu_color14

cursor-color = $linkarzu_color24

# black
palette = 0=$linkarzu_color10
palette = 8=$linkarzu_color08
# red
palette = 1=$linkarzu_color11
palette = 9=$linkarzu_color11
# green
palette = 2=$linkarzu_color02
palette = 10=$linkarzu_color02
# yellow
palette = 3=$linkarzu_color05
palette = 11=$linkarzu_color05
# blue
palette = 4=$linkarzu_color04
palette = 12=$linkarzu_color04
# purple
palette = 5=$linkarzu_color01
palette = 13=$linkarzu_color01
# aqua
palette = 6=$linkarzu_color03
palette = 14=$linkarzu_color03
# white
palette = 7=$linkarzu_color14
palette = 15=$linkarzu_color14
EOF

  echo "Ghostty configuration updated at '$ghostty_conf_file'."
}

generate_btop_config() {
  btop_conf_file="$HOME/dotfiles/btop/themes/btop-theme.theme"

  cat >"$btop_conf_file" <<EOF
# Main background, empty for terminal default, need to be empty if you want transparent background
theme[main_bg]=""

# Main text color
theme[main_fg]="$linkarzu_color14"

# Title color for boxes
theme[title]="$linkarzu_color14"

# Highlight color for keyboard shortcuts
theme[hi_fg]="$linkarzu_color02"

# Background color of selected item in processes box
theme[selected_bg]="$linkarzu_color04"

# Foreground color of selected item in processes box
theme[selected_fg]="$linkarzu_color14"

# Color of inactive/disabled text
theme[inactive_fg]="$linkarzu_color09"

# Color of text appearing on top of graphs, i.e uptime and current network graph scaling
theme[graph_text]="$linkarzu_color14"

# Background color of the percentage meters
theme[meter_bg]="$linkarzu_color17"

# Misc colors for processes box including mini cpu graphs, details memory graph and details status text
theme[proc_misc]="$linkarzu_color01"

# Cpu box outline color
theme[cpu_box]="$linkarzu_color04"

# Memory/disks box outline color
theme[mem_box]="$linkarzu_color02"

# Net up/down box outline color
theme[net_box]="$linkarzu_color03"

# Processes box outline color
theme[proc_box]="$linkarzu_color05"

# Box divider line and small boxes line color
theme[div_line]="$linkarzu_color17"

# Temperature graph colors
theme[temp_start]="$linkarzu_color01"
theme[temp_mid]="$linkarzu_color16"
theme[temp_end]="$linkarzu_color06"

# CPU graph colors
theme[cpu_start]="$linkarzu_color01"
theme[cpu_mid]="$linkarzu_color05"
theme[cpu_end]="$linkarzu_color02"

# Mem/Disk free meter
theme[free_start]="$linkarzu_color18"
theme[free_mid]="$linkarzu_color16"
theme[free_end]="$linkarzu_color06"

# Mem/Disk cached meter
theme[cached_start]="$linkarzu_color03"
theme[cached_mid]="$linkarzu_color05"
theme[cached_end]="$linkarzu_color08"

# Mem/Disk available meter
theme[available_start]="$linkarzu_color21"
theme[available_mid]="$linkarzu_color01"
theme[available_end]="$linkarzu_color04"

# Mem/Disk used meter
theme[used_start]="$linkarzu_color19"
theme[used_mid]="$linkarzu_color05"
theme[used_end]="$linkarzu_color02"

# Download graph colors
theme[download_start]="$linkarzu_color01"
theme[download_mid]="$linkarzu_color02"
theme[download_end]="$linkarzu_color05"

# Upload graph colors
theme[upload_start]="$linkarzu_color08"
theme[upload_mid]="$linkarzu_color16"
theme[upload_end]="$linkarzu_color06"

# Process box color gradient for threads, mem and cpu usage
theme[process_start]="$linkarzu_color03"
theme[process_mid]="$linkarzu_color02"
theme[process_end]="$linkarzu_color06"
EOF

  echo "Btop configuration updated at '$btop_conf_file'."
}

generate_starship_config() {
  # Define the path to the active-config.toml
  starship_conf_file="$DOTFILES_DIR/starship/.config/starship/starship.toml"

  # Generate the Starship configuration file (colors from active-colorscheme)
  # Important: use a single-quoted heredoc so Starship variables like $all are not expanded by bash.
  cat >"$starship_conf_file" <<'EOF'
# Generated by support/zsh/colorscheme-set.sh from active-colorscheme (theme colors). Do not edit by hand.

"$schema" = 'https://starship.rs/config-schema.json'

add_newline = false
# A minimal left prompt
format = """$directory$character"""
palette = "catppuccin_mocha"
# move the rest of the prompt to the right
right_format = """$all"""
command_timeout = 1000

# Starship modules
[character]
# Note the use of Catppuccin color 'peach'
success_symbol = "[[󰄛](green) ❯](peach)"
error_symbol = "[[󰄛](red) ❯](peach)"
vimcmd_symbol = "[󰄛 ❮](subtext0)" # For use with zsh-vi-mode

[git_branch]
style = "bold pink"

[directory]
truncation_length = 4
style = "bold lavender"

EOF

  # Append a palette section using our active linkarzu colors (values expanded by bash).
  # Keep the palette name/keys exactly as omerxx's file, only swapping the values.
  cat >>"$starship_conf_file" <<EOF
[palettes.catppuccin_mocha]
rosewater = "${linkarzu_color14}"
flamingo = "${linkarzu_color16}"
pink = "${linkarzu_color01}"
mauve = "${linkarzu_color04}"
red = "${linkarzu_color11}"
maroon = "${linkarzu_color01}"
peach = "${linkarzu_color08}"
yellow = "${linkarzu_color12}"
green = "${linkarzu_color02}"
teal = "${linkarzu_color03}"
sky = "${linkarzu_color03}"
sapphire = "${linkarzu_color03}"
blue = "${linkarzu_color03}"
lavender = "${linkarzu_color04}"
text = "${linkarzu_color14}"
subtext1 = "${linkarzu_color09}"
subtext0 = "${linkarzu_color09}"
overlay2 = "${linkarzu_color15}"
overlay1 = "${linkarzu_color13}"
overlay0 = "${linkarzu_color25}"
surface2 = "${linkarzu_color13}"
surface1 = "${linkarzu_color07}"
surface0 = "${linkarzu_color25}"
base = "${linkarzu_color10}"
mantle = "${linkarzu_color13}"
crust = "${linkarzu_color17}"
EOF

  echo "Starship configuration updated at '$starship_conf_file'."
}

# Persist the selected profile to colorscheme-vars.sh so the next shell (e.g. after
# reopening Ghostty) uses the same theme and does not overwrite with an old default.
# 将当前选中的主题写回 colorscheme-vars.sh，避免新开终端/重开 Ghostty 时用旧默认覆盖。
# Only replace the single uncommented colorscheme_profile= line.
persist_colorscheme_profile() {
  [ ! -f "$vars_file" ] && return
  tmp=$(mktemp)
  sed '/^[[:space:]]*colorscheme_profile=/s/.*/colorscheme_profile="'"$colorscheme_profile"'"/' "$vars_file" > "$tmp" && mv "$tmp" "$vars_file"
}

# If there's an update, replace the active colorscheme and perform necessary actions
# 如果存在更新，则替换当前活跃的颜色方案并执行必要的操作
if [ "$UPDATED" = true ]; then
  echo "Updating active colorscheme to '$colorscheme_profile'."

  # Replace the contents of active-colorscheme.sh
  # 将颜色方案文件复制到当前活跃的颜色方案文件
  cp "$colorscheme_file" "$active_file"

  # Persist selected profile so reopening Ghostty/terminal keeps this theme
  # 持久化当前选择，重开 Ghostty 或新开终端时不会用旧默认覆盖
  persist_colorscheme_profile

  # Reload sketchybar so it picks up the new theme
  sketchybar --reload
fi

# Always source active and regenerate Starship/Ghostty from theme variables,
# so generated files stay in sync with active-colorscheme.sh (even when theme unchanged).
# 始终用当前 active 主题变量重新生成 Starship/Ghostty，保证生成产物与颜色变量一致。
source "$active_file"
generate_starship_config
generate_ghostty_config
# generate_btop_config

# Keep JankyBorders (borders) active color in sync with the active colorscheme.
# Uses linkarzu_color02 by default (same as SketchyBar GREEN).
if [ -x "$DOTFILES_DIR/support/borders/apply-from-colorscheme.sh" ]; then
  "$DOTFILES_DIR/support/borders/apply-from-colorscheme.sh" || true
fi

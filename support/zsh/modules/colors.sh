# ============================================================================
# Zsh 终端颜色配置模块 / Terminal Color Configuration Module
# ============================================================================
# - ANSI 变量 (boldGreen 等): 用于 echo 等终端输出，与主题无关。
# - 若存在 support/colorscheme，会 source 当前主题并导出 THEME_* 十六进制变量，
#   供支持 hex 的脚本或工具与 support/colorscheme 保持一致。
# ============================================================================

boldGreen="\033[1;32m"
boldYellow="\033[1;33m"
boldRed="\033[1;31m"
boldPurple="\033[1;35m"
boldBlue="\033[1;34m"
noColor="\033[0m"

# Optional: theme hex colors (success/error 等) for scripts that support hex
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
if [[ -f "$DOTFILES_DIR/support/colorscheme/active/active-colorscheme.sh" ]]; then
  source "$DOTFILES_DIR/support/colorscheme/active/active-colorscheme.sh"
  export THEME_SUCCESS_HEX="${linkarzu_color02:-#37f499}"
  export THEME_ERROR_HEX="${linkarzu_color11:-#f16c75}"
  export THEME_FOREGROUND_HEX="${linkarzu_color14:-#ffffff}"
  export THEME_BACKGROUND_HEX="${linkarzu_color10:-#0D1116}"
fi

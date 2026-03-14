# ============================================================================
# Zsh 终端颜色配置模块 / Terminal Color Configuration Module
# ============================================================================
# 本模块定义了 ANSI 转义序列的颜色变量，用于在终端输出彩色文本
# This module defines ANSI escape sequence color variables for colored terminal output
#
# 使用示例 / Usage example:
#   source ~/dotfiles/zsh/modules/colors.sh
#   echo -e "${boldGreen}Success message${noColor}"
#   echo -e "${boldRed}Error message${noColor}"
# ============================================================================

boldGreen="\033[1;32m"
boldYellow="\033[1;33m"
boldRed="\033[1;31m"
boldPurple="\033[1;35m"
boldBlue="\033[1;34m"
noColor="\033[0m"

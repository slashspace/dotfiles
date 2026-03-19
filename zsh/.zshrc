############################
## 1. Oh My Zsh 基础配置 ##
############################
# Oh My Zsh 安装路径
export ZSH="$HOME/.oh-my-zsh"
# Zsh 主题（参考官方主题列表）
ZSH_THEME="robbyrussell"
# 启用的插件
plugins=(git zsh-vi-mode zsh-syntax-highlighting zsh-autosuggestions)
# 补全缓存文件路径，避免主目录下产生杂文件
ZSH_COMPDUMP=$HOME/.cache/zsh/zcompdump-$ZSH_VERSION
# 加载 Oh My Zsh
source $ZSH/oh-my-zsh.sh

#########################
## 2. PATH（path 别名见 support/zsh/modules/alias.sh）##
#########################
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/git/bin:$PATH"
export PATH="$HOME/Library/pnpm:$PATH"
export PATH="$HOME/.local/bin:$PATH"

################################
## 3. 加载 dotfiles 公共模块 ##
################################
# 仓库根目录，克隆到非 ~/dotfiles 时可预先设置 DOTFILES_DIR
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
# 颜色 / 历史 / alias 等基础模块
source "$DOTFILES_DIR/support/zsh/zshrc-common.sh"

#########################
## 4. 颜色主题与皮肤  ##
#########################
# 从 colorscheme-vars.sh 读取当前主题名
source "$DOTFILES_DIR/support/colorscheme/colorscheme-vars.sh"
# 应用主题：仅在选中的主题与 active 不一致时才重建生成文件
"$DOTFILES_DIR/support/zsh/colorscheme-set.sh" "$colorscheme_profile"

#########################
## 5. 命令行工具集成   ##
##    (fzf / eza 等)  ##
#########################
source "$DOTFILES_DIR/support/zsh/modules/tools.sh"
#########################

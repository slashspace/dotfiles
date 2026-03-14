# 仓库根目录，与 colorscheme-set.sh 等脚本一致，便于克隆到非 ~/dotfiles 时使用
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
source "$DOTFILES_DIR/support/zsh/modules/colors.sh"
source "$DOTFILES_DIR/support/zsh/modules/history.sh"
source "$DOTFILES_DIR/support/zsh/modules/alias.sh"

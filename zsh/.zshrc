#------------------------ZSH Configuration(中文：ZSH 配置)----------------
# Path to your oh-my-zsh installation(中文：你的 oh-my-zsh 安装路径)
export ZSH="$HOME/.oh-my-zsh"
# ZSH Theme(中文：主题)：See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"
# ZSH Plugins(中文：插件)
plugins=(git zsh-vi-mode zsh-syntax-highlighting zsh-autosuggestions)
# ZSH Compdump(中文：设置 zsh 补全缓存文件的路径到 ~/.cache/zsh 文件夹，避免主目录下产生杂乱文件)
ZSH_COMPDUMP=$HOME/.cache/zsh/zcompdump-$ZSH_VERSION
# load oh-my-zsh (中文：加载 oh-my-zsh)
source $ZSH/oh-my-zsh.sh
# ------------------------End of ZSH Configuration--------------------------


# ----------------------------Paths(追加环境变量)-----------------------------
alias path='echo -e ${PATH//:/\\n}'

export PATH="$HOME/Library/pnpm:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/git/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
# ----------------------------End of Paths-------------------------------------


# ----------------------------Load common modules(加载通用模块)----------------
source ~/dotfiles/zsh/zshrc-common.sh
# ----------------------------End of Load common modules------------------------


# -------------------------Colorscheme configuration(颜色方案配置)------------
# load colorscheme_profile from ~/dotfiles/colorscheme/colorscheme-vars.sh
source ~/dotfiles/colorscheme/colorscheme-vars.sh
# set colorscheme
~/dotfiles/zsh/colorscheme-set.sh "$colorscheme_profile"
# -------------------------End of Colorscheme configuration----------------------


# -------------------------Command line tools(命令行工具)----------------------
# Tool 1: Starship
# https://starship.rs/config/#prompt
if command -v starship &>/dev/null; then
  type starship_zle-keymap-select >/dev/null ||
    {
      export STARSHIP_CONFIG=$HOME/dotfiles/starship/.config/starship/starship.toml
      eval "$(starship init zsh)" >/dev/null 2>&1
    }
fi

# Tool 2: fzf
# replacement for find(替代 find 命令)
# Useful commands:
# - CTRL-T: search files and directories(中文：搜索文件和目录)
# - CTRL-R: search command history(中文：搜索命令历史)
# - ALT-C: cd to the selected directory(中文：进入选定的目录)
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
  export FZF_CTRL_T_OPTS="
    --preview 'bat -n --color=always {}'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"

  # Use :: as the trigger sequence instead of the default **
  export FZF_COMPLETION_TRIGGER='::'

  # https://github.com/eldritch-theme/fzf
  export FZF_DEFAULT_OPTS='--color=fg:#ebfafa,bg:#09090d,hl:#37f499 --color=fg+:#ebfafa,bg+:#0D1116,hl+:#37f499 --color=info:#04d1f9,prompt:#04d1f9,pointer:#7081d0 --color=marker:#7081d0,spinner:#f7c67f,header:#323449'

  alias f='fzf'
  alias fman="compgen -c | fzf | xargs man"
  alias nlof="~/dotfiles/scripts/fzf_listoldfiles.sh"
fi

# Tool 3: eza
# replacement for ls(替代 ls 命令)
if command -v eza &>/dev/null; then
  alias ls='eza'
  alias ll='eza -lhg'
  alias la='eza -alhg'
  alias tree='eza --tree'
fi

# Tool 4: Bat
# replacement for cat(替代 cat 命令)
# https://github.com/sharkdp/bat
# Supports syntax highlighting for a large number of programming and markup languages
if command -v bat &>/dev/null; then
  # --style=plain - removes line numbers and git modifications
  # --paging=never - doesnt pipe it through less
  alias cat='bat --paging=never --style=plain'
  alias catt='bat'
  # alias cata='bat --show-all --paging=never'
  alias cata='bat --show-all --paging=never --style=plain'
fi

# Tool 5: zoxide
# replace for cd command(替代 cd 命令)
# smarter cd command, it remembers which directories you use most
# frequently, so you can "jump" to them in just a few keystrokes.
# https://github.com/ajeetdsouza/zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  # Alias for cd command(别名用于 cd 命令)
  alias cd='z'
  # Alias below is same as 'cd -', takes to the previous directory(别名与 'cd -' 相同，用于切换到上一个目录)
  alias cdd='z -'
fi

# Tool 6: sketchybar
# This will update the brew package count after running a brew upgrade, brew
# update or brew outdated command
# Personally I added "list" and "install", and everything that is after but
# that's just a personal preference.
# That way sketchybar updates when I run those commands as well
if command -v sketchybar &>/dev/null; then
  # When the zshrc file is ran, reload sketchybar, in case the theme was
  # switched
  # I disabled this as it was getting refreshed every time I opened the
  # terminal and if I restored a lot of sessions after rebooting it was a mess
  # sketchybar --reload

  # Define a custom 'brew' function to wrap the Homebrew command.
  function brew() {
    # Execute the original Homebrew command with all passed arguments.
    # 执行原始 Homebrew 命令，并传递所有参数
    command brew "$@"

    # Check if the command includes "upgrade", "update", or "outdated".
    # 检查命令是否包含 "upgrade", "update", 或 "outdated"
    if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]] || [[ $* =~ "list" ]] || [[ $* =~ "install" ]] || [[ $* =~ "uninstall" ]] || [[ $* =~ "bundle" ]] || [[ $* =~ "doctor" ]] || [[ $* =~ "info" ]] || [[ $* =~ "cleanup" ]]; then
      # If so, notify SketchyBar to trigger a custom action.
      # 如果包含，通知 SketchyBar 触发自定义动作
      sketchybar --trigger brew_update
    fi
  }
fi


#----------------------------End of Command line tools------------------------








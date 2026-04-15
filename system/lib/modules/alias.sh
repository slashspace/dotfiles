# ============================================================================
# Zsh Alias Configuration Module(中文：ZSH 别名配置模块)
# ============================================================================

# Common alias
alias path='echo -e ${PATH//:/\\n}'
alias c='clear'
alias ..='cd ..'
alias ...='cd ../../'

# Git alias
alias ga="git add ."
alias gs="git status"
alias gc='git commit -m'
alias glog='git log --oneline --graph --all'


# Vpn alias
# 1. 建立隧道的快捷命令
alias vpn-bridge="ssh -f -D 1080 -N -p 2222 dingsheng@127.0.0.1"

# 2. 开启/关闭终端代理
alias vpn-on="export ALL_PROXY=socks5://127.0.0.1:1080"
alias vpn-off="unset ALL_PROXY"

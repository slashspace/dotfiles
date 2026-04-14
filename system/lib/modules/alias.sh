# ============================================================================
# Zsh Alias Configuration Module(中文：ZSH 别名配置模块)
# ============================================================================

# Common aliases
alias path='echo -e ${PATH//:/\\n}'
alias c='clear'
alias ..='cd ..'
alias ...='cd ../../'

# Git aliases
alias ga="git add ."
alias gs="git status"
alias gc='git commit -m'
alias glog='git log --oneline --graph --all'

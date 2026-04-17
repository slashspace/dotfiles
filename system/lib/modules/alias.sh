#!/usr/bin/env bash

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
alias gss='git status -s'
alias gc='git commit -m'
alias glog='git log --oneline --graph --all'


# Vpn alias
# 1. 建立隧道的快捷命令（自动释放旧端口）
vpn-bridge() {
    # 如果 1080 端口已被占用，先释放
    if lsof -ti :1080 > /dev/null 2>&1; then
        echo "[vpn-bridge] 端口 1080 已被占用，正在释放..."
        kill $(lsof -ti :1080) 2>/dev/null
        sleep 1
    fi
    ssh -f -D 1080 -N -p 2222 dingsheng@127.0.0.1
}

# 2. 开启/关闭终端代理
alias vpn-on="export ALL_PROXY=socks5://127.0.0.1:1080"
alias vpn-off="unset ALL_PROXY"

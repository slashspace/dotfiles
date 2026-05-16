#!/usr/bin/env bash
# Generic shell aliases. Personal/host-specific aliases (work shortcuts,
# proxy settings, SSH tunnels, etc.) belong in ~/.zshrc.local.

# Navigation
alias path='echo -e ${PATH//:/\\n}'
alias c='clear'
alias ..='cd ..'
alias ...='cd ../../'

# Git
alias gs='git status -sb'
alias ga='git add .'
alias gc='git commit -m'
alias glog='git log --oneline --graph --all'

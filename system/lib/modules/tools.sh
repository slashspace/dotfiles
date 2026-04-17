#!/usr/bin/env bash

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

# Starship
if command -v starship &>/dev/null; then
  if [[ -f "$DOTFILES_DIR/system/themes/generated/starship.toml" ]]; then
    export STARSHIP_CONFIG="$DOTFILES_DIR/system/themes/generated/starship.toml"
  else
    export STARSHIP_CONFIG="$DOTFILES_DIR/core/starship/starship.toml"
  fi
  eval "$(starship init zsh)" >/dev/null 2>&1
fi

# fzf
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
  export FZF_CTRL_T_OPTS="
    --preview 'bat -n --color=always {}'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"
  export FZF_COMPLETION_TRIGGER='::'
  export FZF_DEFAULT_OPTS='--color=fg:#ebfafa,bg:#09090d,hl:#37f499 --color=fg+:#ebfafa,bg+:#0D1116,hl+:#37f499 --color=info:#04d1f9,prompt:#04d1f9,pointer:#7081d0 --color=marker:#7081d0,spinner:#f7c67f,header:#323449'
  alias f='fzf'
  alias fh="history 1 | sed -E 's/^[[:space:]]*[0-9]+[[:space:]]+//' | fzf"
  alias fman="compgen -c | fzf | xargs man"
  alias nlof="$DOTFILES_DIR/system/lib/scripts/fzf_listoldfiles.sh"
  alias nvimf="$DOTFILES_DIR/system/lib/scripts/zoxide_openfiles_nvim.sh"
fi

# eza
if command -v eza &>/dev/null; then
  alias ls='eza'
  alias ll='eza -lhg'
  alias la='eza -alhg'
  alias tree='eza --tree'
fi

# bat
if command -v bat &>/dev/null; then
  alias cat='bat --paging=never --style=plain'
  alias catt='bat'
  alias cata='bat --show-all --paging=never --style=plain'
fi

# zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  alias cd='z'
  alias cdd='z -'
fi

# sketchybar brew wrapper
if command -v sketchybar &>/dev/null; then
  function brew() {
    command brew "$@"
    if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]] || [[ $* =~ "list" ]] || [[ $* =~ "install" ]] || [[ $* =~ "uninstall" ]] || [[ $* =~ "bundle" ]] || [[ $* =~ "doctor" ]] || [[ $* =~ "info" ]] || [[ $* =~ "cleanup" ]]; then
      sketchybar --trigger brew_update
    fi
  }
fi

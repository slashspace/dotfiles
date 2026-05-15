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
  # FZF colors derived from theme palette (fall back to defaults when no theme active)
  _fg="${THEME_FG:-#ffffff}"
  _bg="${THEME_BG:-#0D1116}"
  _green="${THEME_SUCCESS:-#37f499}"
  _red="${THEME_ERROR:-#f16c75}"
  _yellow="${THEME_WARNING:-#f5c542}"
  _muted="${THEME_OUTLINE:-#6b7a8d}"
  export FZF_DEFAULT_OPTS=" \
    --color=fg:${_fg},bg:${_bg},hl:${_green} \
    --color=fg+:${_fg},bg+:${_bg},hl+:${_green} \
    --color=info:${_muted},prompt:${_red},pointer:${_yellow} \
    --color=marker:${_muted},spinner:${_yellow},header:${_yellow} \
    --height=90% --reverse --border=rounded --padding=1 \
    --bind=ctrl-j:down,ctrl-k:up"

  alias f='fzf --preview "bat --style=numbers --color=always --line-range :500 {}"'
  alias fh="history 1 | sed -E 's/^[[:space:]]*[0-9]+[[:space:]]+//' | fzf"

  # directory: fuzzy jump
  alias fcd='cd $(fd --type d | fzf)'

  # git: fuzzy branch switch
  alias fgb='git branch | fzf | xargs git checkout'

  # git: fuzzy log browser with diff preview
  alias fgl='git log --oneline | fzf --preview "git show {1}" | awk "{print \$1}"'

  # process: fuzzy kill
  alias fkill='ps aux | fzf | awk "{print \$2}" | xargs kill -9'
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
  eval "$(zoxide init zsh --no-cmd)"
  z() { __zoxide_z "$@" }
  zi() { __zoxide_zi "$@" }
  cd() {
    if [[ $# -eq 0 ]]; then
      builtin cd ~
    elif [[ -d "$1" ]] || [[ "$1" = '-' ]] || [[ "$1" =~ ^[-+][0-9]+$ ]]; then
      builtin cd "$@"
    else
      __zoxide_z "$@"
    fi
  }
  alias cdd='cd -'
fi

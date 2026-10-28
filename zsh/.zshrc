# ============================================
# Zsh Configuration — powered by Sheldon
# ============================================

export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-$ZSH_VERSION"
export EDITOR=nvim
export VISUAL=nvim
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# --- Atuin (shell history). Bind Ctrl-R after vi-mode loads. ---
export ATUIN_NOBIND="true"
if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh)"
fi

# Ctrl+G opens the git picker. zsh-vi-mode resets keys, so this runs from zvm_after_init.
fzf-git-menu-widget() {
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    zle -M 'fzf-git: not a git repository'
    return
  fi
  local action
  action=$(printf '%s\n' files branches hashes tags remotes stashes worktrees \
    | fzf --prompt='git> ' --height=40% --reverse --bind='ctrl-j:down,ctrl-k:up') || true
  zle reset-prompt
  [[ -n $action ]] && zle "fzf-git-${action}-widget"
}

fzf_git_setup() {
  [[ -f "$HOME/.config/zsh/fzf-git.sh" ]] || return
  source "$HOME/.config/zsh/fzf-git.sh"
  zle -N fzf-git-menu-widget
  local mode object letter
  for object in files branches tags remotes hashes stashes lreflogs each_ref worktrees; do
    letter=${object[1]}
    for mode in emacs vicmd viins; do
      bindkey -M "$mode" -r "^G^${(U)letter}"
      bindkey -M "$mode" -r "^G${letter}"
    done
  done
  for mode in emacs vicmd viins; do
    bindkey -M "$mode" '^G' fzf-git-menu-widget
  done
}

function zvm_after_init() {
  if command -v atuin &>/dev/null; then
    bindkey -M viins '^r' atuin-search-viins
    bindkey -M vicmd '^r' atuin-search-viins
  fi
  fzf_git_setup
}

# --- Sheldon (plugin manager) ---
eval "$(sheldon source)"

# --- Completion ---
# Use a daily compinit cache: skips full security check on hot starts.
mkdir -p "${ZSH_COMPDUMP%/*}"
autoload -Uz compinit
if [[ -n "$ZSH_COMPDUMP"(#qN.mh+24) ]]; then
  compinit -C -d "$ZSH_COMPDUMP"
else
  compinit -d "$ZSH_COMPDUMP"
fi

# --- History ---
HISTFILE="$HOME/.local/state/zsh/history"
HISTSIZE=10000
SAVEHIST=20000

mkdir -p "${HISTFILE:h}"
if [[ ! -f $HISTFILE ]]; then
  touch $HISTFILE
  chmod 600 $HISTFILE
fi

setopt appendhistory
setopt extendedhistory
setopt sharehistory
setopt incappendhistory
setopt histignoredups
setopt histignorespace
setopt autocd

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^[[A' history-beginning-search-backward-end
bindkey '^[[B' history-beginning-search-forward-end

# --- Aliases ---
alias path='echo -e ${PATH//:/\\n}'
alias c='clear'
alias e='exit'
alias ..='cd ..'
alias ...='cd ../../'
alias vim='nvim'
alias rsynct='rsync -avh --progress --partial'

# Git. gs/ga/gc/glog stay short; the rest follow the common git-plugin set.
alias gt='git'
alias gs='git status -sb'
alias gst='git status'
alias ga='git add .'
alias gaa='git add --all'
alias gc='git commit -m'
alias glog='git log --oneline --graph --all'
alias gd='git diff'
alias gds='git diff --staged'
alias gco='git checkout'
alias gb='git branch'
alias gp='git push'
alias gl='git pull'
alias gh-create='gh repo create --private --source=. --remote=origin && git push -u --all && gh browse'

# --- Tools ---
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)" >/dev/null 2>&1
fi

if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
  export FZF_CTRL_T_OPTS="
    --preview 'bat -n --color=always {}'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"
  export FZF_COMPLETION_TRIGGER='::'
  export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type=d --hidden --strip-cwd-prefix --exclude .git'
  export FZF_DEFAULT_OPTS=" \
    --height=90% --reverse --border=rounded --padding=1 \
    --bind=ctrl-j:down,ctrl-k:up"

  fzf_git_setup

  alias f='fzf --preview "bat --style=numbers --color=always --line-range :500 {}"'
  alias fh="history 1 | sed -E 's/^[[:space:]]*[0-9]+[[:space:]]+//' | fzf"
  fcd() { local dir; dir=$(fd --type d --hidden --exclude .git | fzf) && cd "$dir" }
  fgb() { local branch; branch=$(git branch --format='%(refname:short)' | fzf) && git checkout "$branch" }
  fgl() { git log --oneline | fzf --preview 'git show {1}' | awk '{print $1}' }
  fkill() { local pid; pid=$(ps aux | fzf | awk '{print $2}') && kill -9 "$pid" }
  fman() { local cmd; cmd=$(print -l ${(k)commands} | fzf) && man "$cmd" }
fi

if command -v eza &>/dev/null; then
  alias ls='eza --long --no-filesize --color=always --icons=always --no-user --group-directories-first'
  alias ll='ls'
  alias la='eza --long --all --no-filesize --color=always --icons=always --no-user --group-directories-first'
  alias tree='eza --tree --level=3 --all --icons=always --group-directories-first -I .git'
  alias dtree='eza --tree --level=3 --all --only-dirs --icons=always --group-directories-first -I .git'
fi

if command -v lazygit &>/dev/null; then
  alias lg='lazygit'
fi

if command -v bat &>/dev/null; then
  alias cat='bat --paging=never --style=plain'
  alias catt='bat'
  alias cata='bat --show-all --paging=never --style=plain'
fi

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

# --- Local overrides ---
# Machine-specific config (PATH additions, secrets, language SDKs,
# work-only aliases) belongs in ~/.zshrc.local.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

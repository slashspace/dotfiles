#!/usr/bin/env bash
# Zsh history: large shared/incremental history with timestamps and
# prefix-based up/down search.

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=20000

if [[ ! -f $HISTFILE ]]; then
  touch $HISTFILE
  chmod 600 $HISTFILE
fi

setopt appendhistory    # append, do not overwrite
setopt extendedhistory  # store timestamps
setopt sharehistory     # share across sessions
setopt incappendhistory # write incrementally, not at exit
setopt histignoredups   # drop consecutive duplicates
setopt histignorespace  # ignore commands starting with a space
setopt autocd           # `dirname` -> `cd dirname`

# Up/Down: prefix-based history search
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^[[A' history-beginning-search-backward-end
bindkey '^[[B' history-beginning-search-forward-end

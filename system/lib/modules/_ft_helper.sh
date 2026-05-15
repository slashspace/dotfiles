#!/usr/bin/env bash
# Helper for the `ft` zsh function: list sessions and render previews.
# Kept separate so fzf's --preview can re-invoke it cheaply.

set -u

cmd="${1:-}"; shift || true

case "$cmd" in
  list)
    cur="${1:-}"
    # Format: name<TAB>colored line
    tmux list-sessions -F '#{session_name}|#{session_windows}|#{?session_attached,1,0}' 2>/dev/null \
      | awk -F'|' -v cur="$cur" '
        BEGIN {
          DIM="\033[2m"; GRN="\033[32m"; RST="\033[0m"
        }
        {
          marker = ($1 == cur) ? GRN "●" RST : " "
          attached = ($3 == "1") ? GRN "attached" RST : DIM "detached" RST
          printf "%s %-24s %s%2dw%s  %s\n", marker, $1, DIM, $2, RST, attached
        }'
    ;;
  preview)
    sess="${1:-}"
    [[ -z "$sess" ]] && exit 0
    printf '\033[1mWindows\033[0m\n'
    tmux list-windows -t "$sess" -F ' #{window_index}: #{window_name}  [#{pane_current_command}]#{?window_active, *,}' 2>/dev/null
    echo
    printf '\033[1mActive pane (%s)\033[0m\n' "$sess"
    echo "─────────────────────────────────────────"
    tmux capture-pane -ep -t "$sess" 2>/dev/null | tail -40
    ;;
esac

#!/bin/bash

source "$CONFIG_DIR/colors.sh"

PAGE_SIZE=$(sysctl -n hw.pagesize 2>/dev/null)
TOTAL_BYTES=$(sysctl -n hw.memsize 2>/dev/null)

if [ -z "$PAGE_SIZE" ] || [ -z "$TOTAL_BYTES" ]; then
  exit 0
fi

VM_STAT=$(vm_stat 2>/dev/null)
[ -z "$VM_STAT" ] && exit 0

# Single awk: parse vm_stat and compute used % in one pass (fewer process spawns)
PERCENT=$(printf "%s\n" "$VM_STAT" | awk -v ps="$PAGE_SIZE" -v total="$TOTAL_BYTES" '
  /Pages free/       { gsub(/\./,"",$3); free += $3 }
  /Pages speculative/{ gsub(/\./,"",$3); spec += $3 }
  /Pages inactive/   { gsub(/\./,"",$3); inactive += $3 }
  END {
    free_bytes = (free + spec + inactive) * ps
    used = total - free_bytes
    if (total > 0 && used > 0) printf "%.0f", used / total * 100
    else print 0
  }
')

COLOR=$GREEN
if [ "$PERCENT" -ge 80 ]; then
  COLOR=$RED
elif [ "$PERCENT" -ge 50 ]; then
  COLOR=$YELLOW
fi

sketchybar --set "$NAME" label="${PERCENT}%" label.color="$COLOR"

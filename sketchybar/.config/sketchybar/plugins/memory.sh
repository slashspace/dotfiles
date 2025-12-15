#!/bin/bash

source "$CONFIG_DIR/colors.sh"

PAGE_SIZE=$(sysctl -n hw.pagesize 2>/dev/null)
TOTAL_BYTES=$(sysctl -n hw.memsize 2>/dev/null)

if [ -z "$PAGE_SIZE" ] || [ -z "$TOTAL_BYTES" ]; then
  exit 0
fi

VM_STAT=$(vm_stat 2>/dev/null)

if [ -z "$VM_STAT" ]; then
  exit 0
fi

FREE_PAGES=$(printf "%s\n" "$VM_STAT" | awk '/Pages free/ {gsub("\\.","",$3); print $3}')
SPEC_PAGES=$(printf "%s\n" "$VM_STAT" | awk '/Pages speculative/ {gsub("\\.","",$3); print $3}')
INACTIVE_PAGES=$(printf "%s\n" "$VM_STAT" | awk '/Pages inactive/ {gsub("\\.","",$3); print $3}')

[ -z "$FREE_PAGES" ] && FREE_PAGES=0
[ -z "$SPEC_PAGES" ] && SPEC_PAGES=0
[ -z "$INACTIVE_PAGES" ] && INACTIVE_PAGES=0

FREE_BYTES=$(( (FREE_PAGES + SPEC_PAGES + INACTIVE_PAGES) * PAGE_SIZE ))
USED_BYTES=$(( TOTAL_BYTES - FREE_BYTES ))

if [ "$USED_BYTES" -le 0 ] || [ "$TOTAL_BYTES" -le 0 ]; then
  exit 0
fi

PERCENT=$(awk -v used="$USED_BYTES" -v total="$TOTAL_BYTES" 'BEGIN { printf "%.0f", used / total * 100 }')

COLOR=$GREEN
if [ "$PERCENT" -ge 80 ]; then
  COLOR=$RED
elif [ "$PERCENT" -ge 50 ]; then
  COLOR=$YELLOW
fi

sketchybar --set "$NAME" label="${PERCENT}%" label.color="$COLOR"

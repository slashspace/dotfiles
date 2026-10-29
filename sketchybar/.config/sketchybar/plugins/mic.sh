#!/bin/bash

export PATH="/opt/homebrew/bin:$PATH"
source "$CONFIG_DIR/colors.sh"

INPUT_NAME=$(SwitchAudioSource -t input -c 2>/dev/null | awk '{print $1}')
OUTPUT_NAME=$(SwitchAudioSource -t output -c 2>/dev/null)
MIC_VOLUME=$(osascript -e 'input volume of (get volume settings)' 2>/dev/null || echo 0)

case "$MIC_VOLUME" in
  ''|*[!0-9]*) MIC_VOLUME=0 ;;
esac

INPUT_NAME=$(printf '%s' "$INPUT_NAME" | awk '{print $1}')
OUTPUT_NAME=$(printf '%s' "$OUTPUT_NAME" | awk '{print $1}')
[ -n "$INPUT_NAME" ] || INPUT_NAME="Mic"
[ -n "$OUTPUT_NAME" ] || OUTPUT_NAME=" "

# Upper line matches the bar in the reference: cyan while the mic is live,
# red when it is muted, with the input level after the name.
if [ "$MIC_VOLUME" -eq 0 ]; then
  ICON=
  COLOR=$RED
else
  ICON=
  COLOR=$BLUE
fi
MIC_LABEL="${INPUT_NAME}-${MIC_VOLUME}"

# The output line is a zero-width overlay. Pull it left so it sits under the
# mic name instead of spilling into the next item. 12pt ~7px, 8pt ~5px.
OUTPUT_PADDING_LEFT=$((-((${#MIC_LABEL} * 7 + ${#OUTPUT_NAME} * 5) / 2 + 5)))

sketchybar --set mic icon="$ICON" icon.color="$COLOR" label.color="$COLOR" label="$MIC_LABEL" \
           --set mic.output label="$OUTPUT_NAME" padding_left="$OUTPUT_PADDING_LEFT"

#!/bin/bash

export PATH="/opt/homebrew/bin:$PATH"
source "$CONFIG_DIR/colors.sh"

PLAY=
PAUSE=
CACHE_DIR="${HOME}/.cache/sketchybar"
CACHE_KEY="$CACHE_DIR/cliamp-lyrics.key"
CACHE_LYRICS="$CACHE_DIR/cliamp-lyrics.json"
CACHE_STATE="$CACHE_DIR/cliamp-bar.state"

hide() {
  rm -f "$CACHE_DIR/cliamp-popup.on" "$CACHE_STATE"
  mkdir -p "$CACHE_DIR"
  touch "$CACHE_DIR/cliamp-bar.off"
  sketchybar --set cliamp.prev drawing=off \
             --set cliamp.play drawing=off \
             --set cliamp.next drawing=off \
             --set cliamp.title drawing=off popup.drawing=off \
             --set cliamp.lyric drawing=off \
             --set cliamp.vis drawing=off \
             --set cliamp.group drawing=off
}

show() {
  sketchybar --set cliamp.prev drawing=on \
             --set cliamp.play drawing=on \
             --set cliamp.next drawing=on \
             --set cliamp.title drawing=on \
             --set cliamp.lyric drawing=on \
             --set cliamp.vis drawing=on \
             --set cliamp.group drawing=on
}

ensure_vis() {
  local bin="$CACHE_DIR/cliamp-vis"
  local pidfile="$CACHE_DIR/cliamp-vis.pid"
  local pid
  pid="$(cat "$pidfile" 2>/dev/null || true)"
  if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
    return
  fi
  [ -x "$bin" ] || return 0
  mkdir -p "$CACHE_DIR"
  nohup "$bin" >>"$CACHE_DIR/cliamp-vis.log" 2>&1 &
  echo $! >"$pidfile"
}

if [ "$1" = "popup" ]; then
  mkdir -p "$CACHE_DIR"
  if [ -f "$CACHE_DIR/cliamp-popup.on" ]; then
    rm -f "$CACHE_DIR/cliamp-popup.on"
    sketchybar --set cliamp.title popup.drawing=off
  else
    sketchybar --set volume_icon popup.drawing=off \
               --set mic popup.drawing=off
    touch "$CACHE_DIR/cliamp-popup.on"
    sketchybar --set cliamp.title popup.drawing=on
  fi
  ensure_vis
  exit 0
fi

if [ "$1" = "prev" ] || [ "$1" = "next" ] || [ "$1" = "toggle" ]; then
  cliamp "$1" >/dev/null 2>&1
fi

JSON=$(cliamp status --json 2>/dev/null) || {
  hide
  exit 0
}

OK=$(printf '%s' "$JSON" | jq -r '.ok // false')
IFS=$'\x1f' read -r TITLE ARTIST ALBUM STATE POS TRACK_ID < <(
  printf '%s' "$JSON" | jq -r '
    [
      .track.title // "",
      .track.artist // "",
      .track.album // "",
      .state // "",
      ((.position // 0) | tostring),
      (.track.path // ((.track.artist // "") + " — " + (.track.title // "")))
    ] | join("\u001f")
  '
)

if [ "$OK" != "true" ] || [ -z "$TITLE" ]; then
  hide
  exit 0
fi

LABEL="$TITLE"
[ -n "$ARTIST" ] && LABEL="$ARTIST — $TITLE"

mkdir -p "$CACHE_DIR"
if [ "$(cat "$CACHE_KEY" 2>/dev/null)" != "$TRACK_ID" ]; then
  printf '%s' "$TRACK_ID" >"$CACHE_KEY"
  printf '[]' >"$CACHE_LYRICS"
  nohup /bin/bash -c '
    tmp="$1.$$"
    if /opt/homebrew/bin/cliamp remote call lyrics --wait --params "{}" 2>/dev/null \
      | /opt/homebrew/bin/jq -c ".job.result.lyrics // []" >"$tmp"; then
      mv "$tmp" "$1"
    else
      rm -f "$tmp"
    fi
  ' _ "$CACHE_LYRICS" >/dev/null 2>&1 &
fi

LYRIC=$(jq -r --argjson pos "${POS:-0}" '
  [ .[] | select((.start // -1) <= $pos and (.text // "") != "") ] | last | .text // ""
' "$CACHE_LYRICS" 2>/dev/null)

if [ "$STATE" = "playing" ]; then
  rm -f "$CACHE_DIR/cliamp-bar.off"
  ensure_vis
  snapshot=$'playing\x1f'"$LABEL"$'\x1f'"${LYRIC:- }"
else
  touch "$CACHE_DIR/cliamp-bar.off"
  snapshot=$'idle\x1f'"$LABEL"
fi
previous="$(cat "$CACHE_STATE" 2>/dev/null || true)"
if [ "$previous" = "$snapshot" ]; then
  exit 0
fi
printf '%s' "$snapshot" >"$CACHE_STATE"

if [ "$STATE" = "playing" ]; then
  [ "${previous%%$'\x1f'*}" = "playing" ] || show
  sketchybar --set cliamp.play icon="$PAUSE" icon.color="$GREEN" \
             --set cliamp.title label="$LABEL" y_offset=7 label.y_offset=1 \
             --set cliamp.lyric label="${LYRIC:- }"
else
  sketchybar --set cliamp.prev drawing=on \
             --set cliamp.play drawing=on icon="$PLAY" icon.color="$WHITE" \
             --set cliamp.next drawing=on \
             --set cliamp.title drawing=on label="$LABEL" y_offset=0 label.y_offset=0 \
             --set cliamp.lyric drawing=off \
             --set cliamp.vis drawing=off \
             --set cliamp.group drawing=on
fi

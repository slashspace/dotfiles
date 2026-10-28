#!/bin/bash

export PATH="/opt/homebrew/bin:/usr/bin:/bin"
CACHE="${HOME}/.cache/sketchybar"
mkdir -p "$CACHE"
SRC="$(cd "$(dirname "$0")" && pwd)/cliamp-vis.swift"
BIN="$CACHE/cliamp-vis"

if [ ! -x "$BIN" ]; then
  echo "cliamp-vis binary is missing; compile plugins/cliamp-vis.swift into $BIN" >&2
  exit 1
fi

exec "$BIN"

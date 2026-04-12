#!/usr/bin/env bash
# Called from aerospace.toml after layout hotkeys; layout changes do not fire exec-on-workspace-change.
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
sketchybar --trigger aerospace_workspace_change 2>/dev/null || sketchybar --trigger aerospace_workspace_change

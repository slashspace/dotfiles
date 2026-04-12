#!/bin/bash
# Renderer: Ghostty terminal theme
# Reads THEME_XX env vars and generates a Ghostty palette file.

set -euo pipefail

OUTPUT="${DOTFILES_DIR}/system/themes/generated/ghostty-theme"

cat > "$OUTPUT" <<EOF
background = ${THEME_BASE}
foreground = ${THEME_TEXT}
cursor-color = ${THEME_PEACH}
palette = 0=${THEME_BASE}
palette = 8=${THEME_PEACH}
palette = 1=${THEME_RED}
palette = 9=${THEME_RED}
palette = 2=${THEME_GREEN}
palette = 10=${THEME_GREEN}
palette = 3=${THEME_LAVENDER}
palette = 11=${THEME_LAVENDER}
palette = 4=${THEME_MAUVE}
palette = 12=${THEME_MAUVE}
palette = 5=${THEME_MAROON}
palette = 13=${THEME_MAROON}
palette = 6=${THEME_TEAL}
palette = 14=${THEME_TEAL}
palette = 7=${THEME_TEXT}
palette = 15=${THEME_TEXT}
EOF

echo "Generated $OUTPUT"

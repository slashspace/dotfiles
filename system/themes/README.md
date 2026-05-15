# Theme System

A pluggable, semantic-color theme engine that re-skins the entire toolchain
(Ghostty, sketchybar, tmux, starship, nvim, borders, gitmux, …) from a single
palette file. Inspired by [mango-waybar](https://codeberg.org/theblackdon/mango-waybar)'s
two-layer (semantic + ANSI16) approach.

## Layout

```
system/themes/
  schema.sh           Declares the THEME_* contract + safe defaults
  palettes/           One file per theme — exports THEME_* assignments
    catppuccin-pink.sh
    catppuccin-purple.sh
    gruvbox.sh
    monochrome.sh
  renderers/          One script per tool — reads THEME_*, writes generated/
  generated/          Renderer output (gitignored)
system/lib/
  color.sh            hex→rgb / hex→argb helpers
  reload.sh           Live-reload helpers (sketchybar, tmux, ghostty)
```

## Usage

```bash
dotfiles theme   # fzf picker; current theme is marked with ●
```

## How it works

1. `dotfiles theme` shows an fzf picker over `palettes/*.sh` (current marked ●).
2. The chosen palette is sourced with `set -a` so every `THEME_*`
   assignment becomes an exported env var.
3. Every script in `renderers/*.sh` runs in a subshell and emits one
   tool-specific file into `generated/`.
4. `lib/reload.sh` pings sketchybar / tmux so changes appear live; Ghostty
   hot-reloads on its own.

## The THEME_\* contract

A palette must export three groups (see `schema.sh` for full docs):

**Semantic (15)** — what the color *means*:
```
THEME_BG  THEME_BG_ALT  THEME_SHADOW  THEME_FG
THEME_PRIMARY  THEME_SECONDARY  THEME_TERTIARY  THEME_ACCENT  THEME_HOVER
THEME_SURFACE  THEME_OUTLINE
THEME_SUCCESS  THEME_WARNING  THEME_ERROR  THEME_ORANGE
```

**ANSI16 (16)** — the raw terminal palette:
```
THEME_BLACK / BLACKB    THEME_RED / REDB      THEME_GREEN / GREENB
THEME_YELLOW / YELLOWB  THEME_BLUE / BLUEB    THEME_MAGENTA / MAGENTAB
THEME_CYAN / CYANB      THEME_WHITE / WHITEB
```

**Metadata (optional)** — per-tool routing hints:
```
THEME_DISPLAY_NAME            # picker label (default: filename)
THEME_GHOSTTY_BUILTIN         # if set, Ghostty uses this builtin (no custom file)
THEME_NVIM_COLORSCHEME        # nvim plugin name (fallback: gruvbox)
THEME_NVIM_STYLE              # nvim variant ("dark", "mocha", …)
THEME_BORDERS_INACTIVE_COLOR  # 0xAARRGGBB (default: invisible)
THEME_BORDERS_WIDTH           # float (default: 5.0)
```

## Adding a new palette

```bash
cp system/themes/palettes/gruvbox.sh system/themes/palettes/my-theme.sh
$EDITOR system/themes/palettes/my-theme.sh   # tweak colors + metadata
dotfiles theme                                # pick "my-theme" in fzf
```

## Adding a new renderer

A renderer is a script that reads `THEME_*` and writes one file:

```bash
#!/bin/bash
set -euo pipefail
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
# shellcheck source=../../lib/color.sh
source "$DOTFILES_DIR/system/lib/color.sh"

OUTPUT="${DOTFILES_DIR}/system/themes/generated/mytool.conf"

cat > "$OUTPUT" <<EOF
background = ${THEME_BG}
accent     = ${THEME_PRIMARY}
EOF

echo "  ✨ mytool.conf"
```

Drop it in `renderers/`, mark `chmod +x`, and it runs on every
`dotfiles theme` invocation.

If your tool is hot-reloadable, add a `reload_<tool>` function to
`system/lib/reload.sh` and call it from `theme_apply` in
`system/lib/theme.sh`.

## Color helpers

```bash
source "$DOTFILES_DIR/system/lib/color.sh"

color_strip_hash  "#FF8800"        # → ff8800
color_hex_to_rgb  "#ff8800"        # → 255,136,0
color_hex_to_argb "#ff8800"        # → 0xffff8800
color_hex_to_argb "#ff8800" 80     # → 0x80ff8800   (alpha as hex byte)
color_with_alpha  "#ff8800" 128    # → 0x80ff8800   (alpha as decimal)
```

## Notes

- All paths assume `DOTFILES_DIR` (defaults to `$HOME/dotfiles`).
- `generated/` is gitignored.
- macOS bash 3.2 compatible (no `${var,,}`, no associative arrays).
- Shell modules read `generated/theme-env.sh` so new shells inherit
  `THEME_*` without re-running renderers.

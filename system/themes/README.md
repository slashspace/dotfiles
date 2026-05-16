# Theme System

Inspired by [mango-waybar](https://codeberg.org/theblackdon/mango-waybar). A
palette declares a small set of `THEME_*` variables; renderers read those and
write tool-specific config files into `generated/`.

## Layout

```
themes/
├── palettes/      One file per theme; defines THEME_* variables
├── renderers/     One file per tool; reads THEME_* and writes a config file
└── generated/     Output (gitignored). Tools point at files here.
```

## Workflow

```bash
dotfiles theme            # fzf picker (current marked ●)
```

The picker calls `theme_apply <name>`, which:

1. Sources the palette with `set -a` so `THEME_*` is exported.
2. Runs every script in `renderers/`.
3. Reloads sketchybar / tmux / Ghostty in place.
4. Writes the active name to `generated/.current-theme`.

## Palette contract

Every palette must export the variables below. See `palettes/catppuccin-mocha.sh`
for a complete reference.

### Semantic layer

| Variable          | Meaning                                                   |
|-------------------|-----------------------------------------------------------|
| `THEME_BG`        | Main background                                            |
| `THEME_BG_ALT`    | Alternate / inactive background                            |
| `THEME_SHADOW`    | Deepest background (drop shadows, gutters)                 |
| `THEME_FG`        | Main foreground / body text                                |
| `THEME_PRIMARY`   | Brand color (active window, current item)                  |
| `THEME_SECONDARY` | Secondary accent (links, functions)                        |
| `THEME_TERTIARY`  | Tertiary accent (info, modes)                              |
| `THEME_ACCENT`    | Decorative accent (badges, separators)                     |
| `THEME_HOVER`     | Hover / focused-but-not-selected                           |
| `THEME_SURFACE`   | Raised surface (panes, popups)                             |
| `THEME_OUTLINE`   | Borders, separators, comments                              |
| `THEME_SUCCESS`   | Positive state                                             |
| `THEME_WARNING`   | Cautious state                                             |
| `THEME_ERROR`     | Error / destructive state                                  |
| `THEME_ORANGE`    | Numbers / constants (kept distinct from WARNING)           |

### ANSI 16

`THEME_BLACK / THEME_BLACKB`, `THEME_RED / THEME_REDB`,
`THEME_GREEN / THEME_GREENB`, `THEME_YELLOW / THEME_YELLOWB`,
`THEME_BLUE / THEME_BLUEB`, `THEME_MAGENTA / THEME_MAGENTAB`,
`THEME_CYAN / THEME_CYANB`, `THEME_WHITE / THEME_WHITEB`.

### Metadata (optional, renderers fall back gracefully)

| Variable                         | Purpose                                 |
|----------------------------------|-----------------------------------------|
| `THEME_DISPLAY_NAME`             | Pretty name for picker                  |
| `THEME_GHOSTTY_BUILTIN`          | Use this Ghostty built-in theme name    |
| `THEME_NVIM_COLORSCHEME`         | Neovim plugin name                      |
| `THEME_NVIM_STYLE`               | Variant ("dark", "mocha", ...)          |
| `THEME_BORDERS_INACTIVE_COLOR`   | `0xAARRGGBB` (default `0x00000000`)     |
| `THEME_BORDERS_WIDTH`            | Float (default `5.0`)                   |

## Adding a theme

1. Copy any file in `palettes/`, edit the `THEME_*` values + metadata.
2. Run `dotfiles theme` and select it.
3. Inspect `generated/` to confirm renderers wrote the expected files.

## Adding a renderer

Create `renderers/<tool>.sh`. The script will be invoked with `THEME_*`
already in the environment; write its output into `generated/<file>`.
For `borders`, the convention is to accept `--apply` to also call the
live-reload command.

# AGENTS.md

This file provides guidance to OpenCode when working with this repository.

## Overview

macOS dotfiles managed with **GNU Stow** for symlink management and a custom **theme engine** with semantic color variables. Three-layer architecture: `core/` (cross-platform essentials), `modules/` (macOS-specific), `system/` (engine/libs/bin/).

## Key Commands

```bash
# Unified CLI (after stow)
dotfiles                       # Show help
dotfiles bootstrap             # One-time setup (brew + stow + default theme)
dotfiles stow apply --core     # Symlink core packages
dotfiles stow apply --modules  # Symlink macOS modules
dotfiles stow apply --all      # Symlink everything
dotfiles stow dry-run --core   # Preview stow operations
dotfiles stow delete --core    # Remove symlinks
dotfiles theme                 # Pick a theme via fzf (current marked ●)
dotfiles defaults              # Apply macOS system defaults
dotfiles lint                  # shellcheck + shfmt across the repo
dotfiles check                 # Verify Brewfile + outdated formulae

# Install/update dependencies
brew bundle --file=~/dotfiles/system/packages/Brewfile
```

## Architecture

### Three-Layer Structure

| Layer | Purpose | Target |
|-------|---------|--------|
| `core/` | Cross-platform essentials (git, zsh, sheldon, nvim, tmux, starship) | `$HOME` or `$HOME/.config/...` |
| `modules/` | macOS-specific (aerospace, ghostty, karabiner, sketchybar, borders) | `$HOME/.config/...` |
| `system/` | Engine: bin/, themes/, lib/, packages/ | N/A |

### Stow Package Mapping (dotfiles-stow)

Each package maps a source directory to a target. Core packages live in `core/`, macOS packages in `modules/`, system binaries in `system/bin/`. The `dotfiles stow` command handles per-package target directories (e.g., `nvim` → `$HOME/.config/nvim`, `bin` → `$HOME/.local/bin`). `dotfiles stow apply` automatically handles conflicts with pre-existing files (GNU stow `--adopt` is enabled by default).

### Theme Engine

Inspired by [mango-waybar](https://codeberg.org/theblackdon/mango-waybar):
themes in `system/themes/palettes/` declare a 15-color semantic layer
(`THEME_BG / THEME_FG / THEME_PRIMARY / …`) plus a 16-color ANSI layer
(`THEME_BLACK / THEME_RED / … / THEME_WHITEB`) and a small metadata layer
(`THEME_GHOSTTY_BUILTIN`, `THEME_NVIM_COLORSCHEME`, etc.).

`dotfiles theme` sources the chosen palette with `set -a` (auto-export), then
runs every script in `system/themes/renderers/` in a subshell. Each renderer
reads `THEME_*` and writes one tool-specific file into
`system/themes/generated/` (gitignored). Renderers cover: starship,
sketchybar, tmux (catppuccin/tmux `@thm_*` namespace), borders, ghostty,
shell `theme-env.sh`, nvim, gitmux. The ghostty renderer points the config at
a built-in theme when `THEME_GHOSTTY_BUILTIN` is set; otherwise it generates
`modules/ghostty/themes/my-theme`. `gitmux.conf` is generated and copied to
`~/.gitmux.conf` (not stowed). Live-reload logic for sketchybar/tmux/ghostty
lives in `system/lib/reload.sh`.

See `system/themes/README.md` for details on adding palettes and renderers.

### Zsh Startup Chain

`.zshrc` → Sheldon (`eval "$(sheldon source)"`) → `system/lib/modules/` (alias, history, colors, tools) → `~/.zshrc.local`

### Shared Libraries

- `system/lib/log.sh` — Logging helpers (`log_info`, `log_warn`, `log_error`, `log_step`, `log_ok`)
- `system/lib/color.sh` — Color helpers (`color_no_hash`, hex/rgb conversion)
- `system/lib/theme.sh` — `theme_apply`, `theme_list`, `current_theme_get/set`
- `system/lib/reload.sh` — Live-reload helpers for sketchybar/borders/tmux/Ghostty

## Local Overrides

- `~/.zshrc.local` — Zsh overrides (not tracked)
- `~/.gitconfig.local` — Git user.name/email and secrets (not tracked)

## Adding New Modules

1. Create directory in `modules/<name>/` with config files relative to their `$HOME/.config/...` target
2. Register in `MODULES` array in `system/bin/dotfiles-stow` as `"modules:name:$TARGET_PATH"`
3. Add dependencies to `system/packages/Brewfile`
4. Run `dotfiles stow apply --modules`

## Adding New Themes

1. Copy any file in `system/themes/palettes/<name>.sh`, edit the
   `THEME_*` color values and metadata
   (`THEME_DISPLAY_NAME` / `THEME_GHOSTTY_BUILTIN` /
    `THEME_NVIM_COLORSCHEME` / `THEME_NVIM_STYLE`).
2. Test with `dotfiles theme` (pick the new entry in fzf).
3. Verify generated files in `system/themes/generated/`.
4. See `system/themes/README.md` for the full contract.

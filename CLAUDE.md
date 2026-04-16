# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with this repository.

## Overview

macOS dotfiles managed with **GNU Stow** for symlink management and a custom **theme engine** with semantic color variables. Three-layer architecture: `core/` (cross-platform essentials), `modules/` (macOS-specific), `system/` (engine/libs/scripts).

## Key Commands

```bash
# Bootstrap everything (first-time setup)
~/dotfiles/system/scripts/bootstrap.sh

# Stow/unstow configs
~/dotfiles/system/scripts/stow-manager.sh apply --core       # Symlink core/
~/dotfiles/system/scripts/stow-manager.sh apply --modules   # Symlink modules/
~/dotfiles/system/scripts/stow-manager.sh dry-run --core    # Preview changes
~/dotfiles/system/scripts/stow-manager.sh delete --core     # Remove symlinks

# Install macOS modules
~/dotfiles/system/scripts/install-modules.sh

# Theme management
theme list              # List available themes
theme current           # Show current theme
theme apply <name>      # Apply theme (no name = fzf selection)

# Install/update dependencies
brew bundle --file=~/dotfiles/system/packages/Brewfile
```

## Architecture

### Three-Layer Structure

| Layer | Purpose | Target |
|-------|---------|--------|
| `core/` | Cross-platform essentials (git, zsh, sheldon, nvim, tmux, starship) | `$HOME` or `$HOME/.config/...` |
| `modules/` | macOS-specific (aerospace, ghostty, karabiner, sketchybar, borders, gitmux) | `$HOME/.config/...` |
| `system/` | Engine: themes, shared libs, scripts, packages | N/A |

### Stow Package Mapping (stow-manager.sh)

Each package maps a source directory to a target. Core packages live in `core/`, macOS packages in `modules/`. The stow-manager.sh script handles per-package target directories (e.g., `nvim` → `$HOME/.config/nvim`, `git` → `$HOME`).

### Theme Engine

Themes in `system/themes/list/*.sh` export 29 `THEME_*` semantic color variables. The `theme apply` command sources a theme, then runs all renderers in `system/themes/renderers/` which write tool-specific configs to `system/themes/generated/` (gitignored). Renderers cover: starship, sketchybar, tmux, borders.

### Zsh Startup Chain

`.zshrc` → Sheldon (`eval "$(sheldon source)"`) → `system/lib/modules/` (alias, history, colors, tools) → `~/.zshrc.local`

### Shared Libraries

- `system/lib/log.sh` — Logging helpers (`log_info`, `log_warn`, `log_error`, `log_step`)
- `system/lib/platform.sh` — OS/arch detection (`platform_os`, `platform_arch`, `platform_distro`)
- `system/lib/package.sh` — Package manager abstraction (Homebrew/apt/pacman)

## Local Overrides

- `~/.zshrc.local` — Zsh overrides (not tracked)
- `~/.gitconfig.local` — Git user.name/email and secrets (not tracked)

## Adding New Modules

1. Create directory in `modules/<name>/` with config files relative to their `$HOME/.config/...` target
2. Register in `MACOS_PACKAGES` array in `system/scripts/stow-manager.sh` as `"name:$TARGET_PATH"`
3. Add dependencies to `system/packages/Brewfile`
4. Run `stow-manager.sh apply --modules`

## Adding New Themes

1. Create `system/themes/list/<name>.sh` sourcing `palette.sh` and overriding all `THEME_*` variables
2. Test with `theme apply <name>`
3. Verify generated files in `system/themes/generated/`

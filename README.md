# dotfiles

macOS dotfiles managed with GNU Stow. Core tools live in `core/`, optional desktop modules live in `modules/`, and shared scripts/theme tooling live in `system/`.

## Structure

```text
dotfiles/
├── core/              Core essentials
│   ├── git/             Git config
│   ├── zsh/             Shell config (Sheldon)
│   ├── sheldon/         Plugin manager config
│   ├── nvim/            Neovim config
│   ├── tmux/            Tmux config
│   ├── starship/        Prompt config
│   └── opencode/        OpenCode config
├── modules/           Optional macOS modules
│   ├── aerospace/       Tiling window manager
│   ├── ghostty/         Terminal emulator
│   ├── karabiner/       Keyboard remapping
│   ├── sketchybar/      Minimal menu bar
│   └── borders/         Window borders
└── system/            Shared tooling
    ├── bin/             CLI entry points
    ├── lib/             Shared shell modules and helpers
    ├── packages/        Brewfile
    └── themes/          Optional theme workflow
```

## Architecture

- `core/` contains the shell/editor/terminal configs that are useful on every machine.
- `modules/` contains optional macOS-only integrations.
- `system/bin/dotfiles` is the main CLI.
- `dotfiles stow` maps each package to its real target path instead of assuming everything goes to one directory.
- The theme system is optional. If you do not run `dotfiles theme apply`, tools use their default configs.

## Quick Start

### 1. Clone

```bash
git clone <repo-url> ~/dotfiles
```

If you use a different path, set `DOTFILES_DIR` when invoking scripts.

### 2. Bootstrap core setup

```bash
dotfiles bootstrap
```

This installs Xcode CLI tools if needed, installs Homebrew if needed, runs `brew bundle`, locks Sheldon plugins, stows core packages, and applies the default theme.

### 3. Install optional macOS modules

```bash
dotfiles modules install
```

This stows:

- `aerospace`
- `ghostty`
- `karabiner`
- `sketchybar`
- `borders`

### 4. Apply macOS defaults

```bash
dotfiles defaults
```

### 5. Verify and restart shell

```bash
dotfiles doctor
exec zsh
```

## Commands

```bash
dotfiles theme list
dotfiles theme apply <name>
dotfiles theme select [name]
dotfiles theme current

dotfiles stow apply --core
dotfiles stow apply --modules
dotfiles stow apply --all
dotfiles stow delete --core
dotfiles stow dry-run --core

dotfiles bootstrap
dotfiles modules install
dotfiles defaults
dotfiles doctor
```

After `dotfiles stow apply --core`, the CLI is available at `~/.local/bin/dotfiles`.

## Theme Workflow

```bash
dotfiles theme list
dotfiles theme current
dotfiles theme apply catppuccin-mocha
dotfiles theme select
```

Notes:

- Theme output is written to `system/themes/generated/`.
- Current theme name is stored in `system/themes/generated/.current-theme`.
- SketchyBar, tmux, Ghostty, and related generated files update from this workflow.

Available themes:

`catppuccin-mocha`, `catppuccin-macchiato`, `dracula`, `gruvbox-dark`, `tokyo-night`, `kanagawa`, `nord`, `rose-pine`, `everforest`, `solarized-dark`, `retro-phosphor`

Custom themes live in `system/themes/list/` and should export the `THEME_*` variables defined in `system/themes/palette.sh`.

## Local Overrides

- `~/.zshrc.local` for machine-specific shell config
- `~/.gitconfig.local` for Git identity and local secrets

## Dependencies

Managed via Homebrew in `system/packages/Brewfile`.

| Category | Tools |
|----------|-------|
| Core | git, stow, fzf |
| Shell | starship, sheldon, eza, bat, zoxide |
| Terminal | tmux, gitmux, nvim |
| Desktop | aerospace, ghostty, karabiner-elements, sketchybar, borders |
| Dev tools | shellcheck, shfmt |

## Notes

- SketchyBar is intentionally minimal: workspace strip, calendar, battery, Wi-Fi, and volume.
- `gitmux` is used by tmux, but it is not a stowed module.
- Platform support is macOS only.

## Uninstall

```bash
dotfiles stow delete --all
rm -rf ~/dotfiles
rm -rf ~/.local/share/sheldon
rm -f ~/.zshrc.local ~/.gitconfig.local
```

## License

MIT

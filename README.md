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
- The theme system is optional. If you do not run `dotfiles theme`, tools use their default configs.

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

### 3. Apply macOS defaults (optional)

```bash
dotfiles defaults
```

### 4. Restart shell

```bash
exec zsh
```

## Commands

```bash
dotfiles bootstrap              # One-time setup
dotfiles stow apply|delete|dry-run --core|--modules|--all
dotfiles theme                  # Pick a theme via fzf (current marked ●)
dotfiles defaults               # Apply macOS system defaults
```

After `dotfiles bootstrap` (or `dotfiles stow apply --core`), the CLI is available at `~/.local/bin/dotfiles`.

## Theme Workflow

```bash
dotfiles theme   # fzf picker; current theme marked with ●
```

Notes:

- Theme output is written to `system/themes/generated/`.
- Current theme name is stored in `system/themes/generated/.current-theme`.
- SketchyBar, tmux, Ghostty, and related generated files update from this workflow.

Available themes:

`catppuccin-pink`, `catppuccin-purple`, `gruvbox`, `monochrome`

Custom themes live in `system/themes/palettes/` and should export the `THEME_*` variables described in `system/themes/schema.sh`. See `system/themes/README.md` for the full guide.

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

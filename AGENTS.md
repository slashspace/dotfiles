# AGENTS.md

macOS dotfiles. Each top-level directory is a GNU Stow package whose contents mirror paths under `$HOME`.

## Layout

| Package | Lands at |
|---------|----------|
| `zsh` | `~/.zshrc`, `~/.zprofile`, `~/.config/zsh/fzf-git.sh` |
| `git` | `~/.gitconfig` |
| `sheldon` | `~/.config/sheldon` |
| `nvim` | `~/.config/nvim` |
| `starship` | `~/.config/starship` |
| `herdr` | `~/.config/herdr` |
| `opencode` | `~/.config/opencode` |
| `ghostty` | `~/.config/ghostty` |
| `aerospace` | `~/.config/aerospace` |
| `karabiner` | `~/.config/karabiner` |
| `sketchybar` | `~/.config/sketchybar` |
| `borders` | `~/.config/borders` |
| `zed` | `~/.config/zed` |
| `fastfetch` | `~/.config/fastfetch` |
| `atuin` | `~/.config/atuin` |
| `mpd` | `~/.config/mpd` |
| `rmpc` | `~/.config/rmpc` |
| `mactop` | `~/.mactop` |

Root files (`install.sh`, `Brewfile`, README) are not packages. `.stow-local-ignore` lists them.

## Commands

```bash
brew bundle --file=~/dotfiles/Brewfile
cd ~/dotfiles
stow -R -t ~ zsh git sheldon nvim starship herdr opencode \
  ghostty aerospace karabiner sketchybar borders zed \
  fastfetch atuin mpd rmpc mactop
```

`install.sh` does Xcode CLT, Homebrew, `brew bundle`, Sheldon lock, stow, and macOS defaults.

## Theme

Ghostty themes live in `ghostty/.config/ghostty/themes/` (`rosepine`, `rosepine-custom`, `tokyonight`). `config` points at `themes/rosepine`. Neovim's active colorscheme is solarized-osaka. Starship uses the `solarized_osaka` palette. SketchyBar uses its own bar colors. Borders stay on Rose Pine. Herdr uses Catppuccin.

## Shell

`.zprofile` loads Homebrew. `.zshrc` loads Sheldon, then history, aliases, and tools. Machine-specific overrides: `~/.zshrc.local`, `~/.gitconfig.local`. History file is `~/.local/state/zsh/history`. Completion cache is `~/.cache/zsh/`.

## Adding a package

1. Create `<name>/.config/<name>/...` (or `<name>/.file` when the target is `$HOME`).
2. `stow -R -t ~ <name>` from the repo root.
3. Add the formula or cask to `Brewfile`.

# dotfiles

![dotfiles preview](https://github.com/d3george/github-static/blob/main/dotfiles/screenshot.png)

macOS dotfiles. Each top-level directory is a [GNU Stow](https://www.gnu.org/software/stow/) package, and the paths inside it match `$HOME`.

[中文](README.zh-CN.md)

## Structure

```text
dotfiles/
├── install.sh
├── Brewfile
├── zsh/            ~/.zshrc, ~/.zprofile
├── git/            ~/.gitconfig
├── sheldon/        ~/.config/sheldon
├── nvim/           ~/.config/nvim
├── starship/       ~/.config/starship
├── herdr/          ~/.config/herdr
├── opencode/       ~/.config/opencode
├── ghostty/        ~/.config/ghostty
├── aerospace/      ~/.config/aerospace
├── karabiner/      ~/.config/karabiner
├── sketchybar/     ~/.config/sketchybar
├── borders/        ~/.config/borders
├── zed/            ~/.config/zed
├── fastfetch/      ~/.config/fastfetch
├── atuin/          ~/.config/atuin
├── mpd/            ~/.config/mpd
├── rmpc/           ~/.config/rmpc
└── mactop/         ~/.mactop
```

## Install

```bash
git clone <repo-url> ~/dotfiles
chmod +x ~/dotfiles/install.sh
/bin/bash ~/dotfiles/install.sh
exec zsh
```

`install.sh` installs Xcode Command Line Tools and Homebrew if needed, runs `brew bundle`, locks Sheldon plugins, stows every package, and applies macOS defaults.

To link packages without the rest of the installer:

```bash
cd ~/dotfiles
stow -R -t ~ zsh git sheldon nvim starship herdr opencode \
  ghostty aerospace karabiner sketchybar borders zed \
  fastfetch atuin mpd rmpc mactop
```

## Theme

Ghostty keeps three static themes in `ghostty/.config/ghostty/themes/`: `rosepine` (active), `rosepine-custom`, and `tokyonight`. Switch by editing `config-file` in `ghostty/.config/ghostty/config`.

Neovim's active colorscheme is solarized-osaka. Starship uses the `solarized_osaka` palette. SketchyBar uses the bar colors shipped with that config. Window borders stay on Rose Pine. Herdr uses Catppuccin.

## Editor keys

Neovim and Zed share one leader, Space. Neovim is the fuller set. Zed mirrors the motions that Zed can express. Leader is Space in both.

| Action | Neovim | Zed |
|--------|--------|-----|
| Find file | `Space p f` | `Space p f` |
| Search text | `Space p s` | `Space p s` |
| Recent files | `Space p r` | `Ctrl+o p` or `Space f p` |
| Hover | `K` | `Shift+k` |
| Signature help | `Ctrl+h` in insert | `Ctrl+h` in insert |
| Rename | `Space r n` | `Space r n` |
| Code action | `Space v c a` | `Space v c a` |
| Format | `Space m p` | `Space m p` or `=` in visual |
| Go to definition | `g d` | `g d` (Zed default); `Space v` opens it in a split |
| References | `g R` | `g r` |
| Diagnostics | `Space x w` | `g ]` / `g [` |
| Move line | `J` / `K` in visual | `Shift+j` / `Shift+k` in visual |
| Pane left/down/up/right | `Ctrl+w` then `h j k l` | `Ctrl+h j k l` |
| Vertical / horizontal split | `Space s v` / `Space s h` | Zed default splits; `Ctrl+w f` opens a terminal |
| File tree | `Space e e` (mini.files) or `-` (Oil) | `Space e e` toggles the right dock |

Neovim-only: `Space a` adds the file to Harpoon, then `Ctrl+y` `Ctrl+i` `Ctrl+n` `Ctrl+s` jump to marks 1–4, `Ctrl+e` opens the list. `Space l g` opens lazygit. `Space u` toggles undo history. `Space p k` searches keymaps.

In the Zed project panel: `a` new file, `A` new directory, `r` rename, `d` delete, `x` cut, `c` copy, `p` paste, `q` closes the dock.

## fastfetch

Prints a system summary in the terminal. Run `fastfetch`. It does not start with the shell.

## Atuin

Replaces `Ctrl+R` history search. Open a new shell, then press `Ctrl+R`, type, and Enter to run the selected command. `atuin search` opens the same search. `atuin import auto` pulls in existing shell history once. `atuin login` is only needed if you want to sync history to an Atuin account.

## mpd

Music Player Daemon. Put audio files in `~/.config/mpd/music`, then:

```bash
mpd ~/.config/mpd/mpd.conf
mpc update
mpc ls
mpc add <file>
mpc play
mpc status
mpc next
mpc stop
```

`pkill mpd` stops it. Start it again with the same `mpd` command. `rmpc` is the full-screen player for that daemon: start mpd, then run `rmpc`.

## fzf-git

Inside a Git repo, press `Ctrl+G` and pick files, branches, or commits. The selection is inserted into the current command line. Outside a repo the line says `not a git repository`. Open a new shell first.

## mactop

Apple Silicon resource monitor. Run `mactop`, press `q` to quit. Colors live in `~/.mactop/config.json`.

## SketchyBar

`sketchybar` stays attached to the terminal, so the line `sketchybar configuration loaded..` remains on screen. That is the bar process, not a hang. Start it in the background at login instead:

```bash
ln -sf /opt/homebrew/opt/sketchybar/homebrew.mxcl.sketchybar.plist ~/Library/LaunchAgents/
launchctl bootout gui/$(id -u)/homebrew.mxcl.sketchybar 2>/dev/null || true
killall sketchybar 2>/dev/null || true
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/homebrew.mxcl.sketchybar.plist
```

If a terminal is already sitting on that line, press `Ctrl+C` there. The menu bar keeps running from the service.

## Local overrides

- `~/.zshrc.local` for machine PATH and shell config
- `~/.gitconfig.local` for Git identity and secrets

## Dependencies

Managed via Homebrew in `Brewfile`.

| Category | Tools |
|----------|-------|
| Core | git, stow, fzf, fd, ripgrep |
| Shell | starship, sheldon, eza, bat, zoxide, atuin, fastfetch |
| Editor | neovim, herdr, zed |
| Desktop | aerospace, ghostty, karabiner-elements, sketchybar, borders |
| Music | mpd, mpc, rmpc |
| Monitor | mactop |
| Dev tools | shellcheck, shfmt |

## Uninstall

```bash
cd ~/dotfiles
stow -D -t ~ zsh git sheldon nvim starship herdr opencode \
  ghostty aerospace karabiner sketchybar borders zed \
  fastfetch atuin mpd rmpc mactop
```

## License

MIT

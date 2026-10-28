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
├── cliamp/         ~/.config/cliamp
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
  fastfetch atuin cliamp mactop
```

## Theme

Ghostty themes live in `ghostty/.config/ghostty/themes/` and match Zed's four Polycarbonate themes: `polycarbonate-gruvbox-dark` (active), `polycarbonate-sha1`, `polycarbonate-ayu-dark`, and `polycarbonate-one-dark`. Switch by editing `config-file` in `ghostty/.config/ghostty/config`.

Neovim's active colorscheme is solarized-osaka. Starship uses the `solarized_osaka` palette. SketchyBar uses the bar colors shipped with that config. Window borders stay on Rose Pine. Herdr uses Catppuccin.

## Daily keys

Neovim and Zed share `Space` as leader. `Space p f` means Space, then `p`, then `f`. A `+` means hold the keys together.

### Windows (AeroSpace)

Apps land on a workspace by themselves: Zed on `0`, browsers on `1`, notes on `2`, chat on `3`, Ghostty on `9`.

| Action | Keys |
|--------|------|
| Focus left/down/up/right | `Alt+h` `j` `k` `l` |
| Move window | `Alt+Shift+h` `j` `k` `l` |
| Go to workspace 1–9, 0 | `Alt+1` … `Alt+9`, `Alt+0` |
| Send the window there | Add `Shift` to the above |
| Back to the previous workspace | `Alt+Tab` |
| Send to the other monitor | `Alt+Shift+Tab` |
| Tiles / accordion | `Alt+/`, `Alt+,` |
| Resize | `Alt+Shift+r`, then `h` `j` `k` `l`, `b` to balance, `Esc` to leave |

After editing the config, run `aerospace reload-config`.

### Ghostty

The prefix is `Ctrl+Space`, then the next key. If macOS still uses `Ctrl+Space` for “select the previous input source”, Ghostty never sees it. Reload the current window with `Shift+Cmd+,`.

| Action | Keys |
|--------|------|
| New tab / go to tab n | prefix then `c`, or `1`–`9` |
| Split right / down | prefix then `\`, `-` |
| Focus split left/down/up/right | prefix then `h` `j` `k` `l` |
| Equalize splits | prefix then `e` |
| Close surface / new window | prefix then `x`, `n` |
| Quick terminal | prefix then `,` |

### Herdr

The prefix is the default `Ctrl+b`.

| Action | Keys |
|--------|------|
| Settings / reload | prefix then `;`, `r` |
| Go to | prefix then `s` |
| New workspace / rename it | prefix then `Shift+w`, `$` |
| Rename tab | prefix then `,` |
| Vertical split / zoom | prefix then `\|`, `m` |
| Resize mode | prefix then `Shift+r` |
| Previous / next workspace | `Ctrl+k`, `Ctrl+j` |

### Neovim and Zed

Both are normal mode. In Neovim, `Space p k` searches every keymap. In Zed, wait half a second after `Space`, `g`, or `z` and the next keys are listed.

| Action | Neovim | Zed |
|--------|--------|-----|
| Find file | `Space p f` | `Space p f` |
| Search text | `Space p s` | `Space p s` |
| Recent files | `Space p r` | `Ctrl+o` then `p`, or `Space f p` |
| Current directory | `-` | |
| File tree | `Space e e` | `Space e e` toggles the right dock |
| Hover | `K` | `Shift+k` |
| Signature help | `Ctrl+h` in insert | `Ctrl+h` in insert |
| Definition | `g d` | `g d`; `Space v` opens it in a split |
| References | `g R` | `g r` |
| Rename | `Space r n` | `Space r n` |
| Code action | `Space v c a` | `Space v c a` |
| Format | `Space m p` | `Space m p` |
| Diagnostics | `Space x w` | `g ]` / `g [` |
| Fold toggle | `za` | `z a` |
| Fold close / open | `zc` / `zo` | `z c` / `z o` |
| Fold all / open all | `zM` / `zR` | `z Shift+m` / `z Shift+r` |
| Half-page down/up | `Ctrl+d` / `Ctrl+u` | |
| Clear search highlight | `Ctrl+c` | |
| Pane left/down/up/right | `Ctrl+w` then `h` `j` `k` `l` | `Ctrl+h` `j` `k` `l` |
| Split vertical / horizontal | `Space s v` / `Space s h` | |
| Equalize / close split | `Space s e` / `Space s x` | |
| Terminal | | `Ctrl+w` then `f` |
| Move lines | `J` / `K` in visual | `Shift+j` / `Shift+k` in visual |
| All tabs | | `Ctrl+e` then `h` |
| Harpoon | `Space a` to mark, `Ctrl+y` `Ctrl+i` `Ctrl+n` `Ctrl+s` jump to 1–4 | |
| lazygit / undo history | `Space l g` / `Space u` | |

In the Zed project panel: `a` new file, `A` new directory, `r` rename, `d` delete, `q` close. Folds stay inert until `document_folding_ranges` in `settings.json` is `always` instead of `off`.

In Zed normal mode, which-key appears in the corner only when the key is the start of a two-key sequence. `d`, `c`, and `y` wait for a motion, so they do not open it. These prefixes stay until the next key or `Esc`. `Space` no longer moves right on its own, so it stays the same way `g` does.

| Key | What follows |
|-----|----------------|
| `Space` | Find file, file tree, format, rename |
| `g` | Go to, references, diagnostics |
| `z` | Folds, scroll the cursor to top/center/bottom |
| `Ctrl+w` | Splits and focus |
| `[` / `]` | Sections, diagnostics, hunks |
| `Shift+z` | `Shift+z` again saves and closes, `Shift+q` closes without saving |

These disappear after about a second, because the key is already a complete action:

| Key | What the key alone does | The extra binding |
|-----|-------------------------|-------------------|
| `Ctrl+o` | Jump back | `Ctrl+o` then `p` opens recent projects |
| `Ctrl+e` | Scroll the view down one line | `Ctrl+e` then `h` opens all tabs |

### Shell

| Action | Command or keys |
|--------|-----------------|
| History | `Ctrl+R` |
| Pick a file, branch, or commit in a repo | `Ctrl+G` |
| Change directory | `z name`, or `cd name` |
| Previous directory | `cdd` |
| List / hidden / three-level tree | `ls`, `la`, `tree` |
| View a file | `cat`, `catt` to page |
| Git short status / stage / commit / push / pull | `gs`, `ga`, `gc "message"`, `gp`, `gl` |
| Diff / staged diff / graph | `gd`, `gds`, `glog` |
| Branch UI | `lg` |
| Clear | `c` |

## fastfetch

Prints a system summary in the terminal. Run `fastfetch`. It does not start with the shell.

## Atuin

Replaces `Ctrl+R` history search. Open a new shell, then press `Ctrl+R`, type, and Enter to run the selected command. `atuin search` opens the same search. `atuin import auto` pulls in existing shell history once. `atuin login` is only needed if you want to sync history to an Atuin account.

## cliamp

Terminal player. It is not part of the Brewfile:

```bash
brew install bjarneo/cliamp/cliamp
```

Preferences live in `cliamp/.config/cliamp/config.toml` and are linked to `~/.config/cliamp/config.toml`. Play a local folder with `cliamp ~/Music`. Press `q` to quit and `?` for keys. `cliamp setup` rewrites that file; if it inserts a token, keep the value in `~/.zshrc.local` as `${VAR}` and do not commit the token.

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
| Monitor | mactop |
| Dev tools | shellcheck, shfmt |

## Uninstall

```bash
cd ~/dotfiles
stow -D -t ~ zsh git sheldon nvim starship herdr opencode \
  ghostty aerospace karabiner sketchybar borders zed \
  fastfetch atuin cliamp mactop
```

## License

MIT

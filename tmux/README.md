
## Install
This package installs tmux config into XDG locations via `stow`.

### TPM install (one-time)
Once tmux is installed, install TPM first:
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## Run
1. Start tmux:
   ```bash
   tmux kill-server
   tmux new -s test
   ```
2. Install plugins in tmux:
   - `prefix + I`

### Confirm prefix (optional)
If you're not sure what `prefix` is:
```bash
tmux show -g prefix
```

## Config locations
After stow, the expected files are:
- `~/.config/tmux/tmux.conf`
- `~/.config/tmux/tmux.reset.conf`

## Theme
Status line uses [catppuccin/tmux](https://github.com/catppuccin/tmux) **v2** (`catppuccin/tmux#v2.1.3`). It is not compatible with the older `omerxx/catppuccin-tmux` / `@catppuccin_status_modules_*` API.

After pulling dotfile changes:

1. Remove the old theme plugin directory under `~/.tmux/plugins/` if present (e.g. a folder from `omerxx/catppuccin-tmux`), or run `~/.tmux/plugins/tpm/bin/clean_plugins` and follow prompts.
2. In tmux: `prefix` + `I` to install plugins.
3. Prefer `tmux kill-server` then `tmux new -s test` so globals from the old theme do not linger.

Documentation: [status line modules](https://github.com/catppuccin/tmux/blob/main/docs/reference/status-line.md).

### Git in the status bar (gitmux)
Branch and working-tree status are shown in **tmux** via [gitmux](https://github.com/arl/gitmux), not in Starship (`git_branch` / `git_status` are disabled in the generated `starship.toml`).

1. Install: `brew install gitmux` (see repo `Brewfile`).
2. After `stow tmux`, you should have `~/.gitmux.conf` → `dotfiles/tmux/.gitmux.conf`.
3. Reload tmux config. The status line includes `#{E:@catppuccin_status_gitmux}` between directory and date/time.

If git does not appear, check `which gitmux` and that `status-interval` (default 2s in this config) allows refreshes.

### Transparent status bar + window list
The status bar uses `@catppuccin_status_background "none"` and after TPM, `status-style` / `window-status-*-style` with `bg=default`.

**Note:** Catppuccin **`rounded`** window style uses `#[fg=@_ctp_status_bg,reverse]` for Powerline glyphs. With a transparent status line (`none`), that causes **black boxes and rectangular artifacts**. This repo uses **`@catppuccin_window_status_style "basic"`** for the window list instead. For rounded pills again, use a **solid** status background (`@catppuccin_status_background "default"`) and you can switch back to `rounded`.


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


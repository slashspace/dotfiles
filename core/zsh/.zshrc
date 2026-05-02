# ============================================
# Zsh Configuration — powered by Sheldon
# ============================================

# --- Environment ---
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-$ZSH_VERSION"

# --- PATH ---
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/git/bin:$PATH"
export PATH="$HOME/Library/pnpm:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# --- Sheldon (plugin manager) ---
eval "$(sheldon source)"

# --- Completion ---
mkdir -p "${ZSH_COMPDUMP%/*}"
autoload -Uz compinit && compinit -d "$ZSH_COMPDUMP"

# --- Modules ---
source "$DOTFILES_DIR/system/lib/modules/alias.sh"
source "$DOTFILES_DIR/system/lib/modules/history.sh"
source "$DOTFILES_DIR/system/lib/modules/colors.sh"
source "$DOTFILES_DIR/system/lib/modules/tools.sh"

# --- Theme (optional) ---
# If a theme has been applied, the starship config points to the generated file

# --- Local overrides ---
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# bun completions
[ -s "/Users/dingsheng/.bun/_bun" ] && source "/Users/dingsheng/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

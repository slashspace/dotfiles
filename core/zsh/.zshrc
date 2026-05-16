# ============================================
# Zsh Configuration — powered by Sheldon
# ============================================

# --- Environment ---
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-$ZSH_VERSION"

# --- PATH ---
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/git/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# --- Sheldon (plugin manager) ---
eval "$(sheldon source)"

# --- Completion ---
# Use a daily compinit cache: skips full security check on hot starts.
mkdir -p "${ZSH_COMPDUMP%/*}"
autoload -Uz compinit
if [[ -n "$ZSH_COMPDUMP"(#qN.mh+24) ]]; then
  compinit -C -d "$ZSH_COMPDUMP"
else
  compinit -d "$ZSH_COMPDUMP"
fi

# --- Modules ---
source "$DOTFILES_DIR/system/lib/modules/alias.sh"
source "$DOTFILES_DIR/system/lib/modules/history.sh"
source "$DOTFILES_DIR/system/lib/modules/tools.sh"

# --- Theme (optional) ---
# If a theme has been applied, the starship config points to the generated file

# --- Local overrides ---
# Machine-specific config (PATH additions, secrets, language SDKs like
# bun/nvm/rbenv, work-only aliases) belongs in ~/.zshrc.local — it is sourced
# last so it can override anything defined above.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# ============================================
# Zsh Configuration — powered by zinit
# ============================================

# --- Environment ---
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-$ZSH_VERSION"

# --- PATH ---
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/git/bin:$PATH"
export PATH="$HOME/Library/pnpm:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# --- Zinit ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# --- Plugins ---
zinit light-mode for \
  zsh-users/zsh-syntax-highlighting \
  zsh-users/zsh-autosuggestions \
  jeffreytse/zsh-vi-mode \
  atload"zicompinit; zicdreplay" \
  blockf \
  zsh-users/zsh-completions

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
# No need to run colorscheme-set.sh on every shell startup anymore

# --- Local overrides ---
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

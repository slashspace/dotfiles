# macOS Terminal otherwise writes ~/.zsh_sessions and pins history to ~/.zsh_history.
# This has to run before /etc/zshrc, which sources the Terminal session hook.
export SHELL_SESSIONS_DISABLE=1

. "$HOME/.cargo/env"

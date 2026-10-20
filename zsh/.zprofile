eval "$(/opt/homebrew/bin/brew shellenv)"

export LANG=en_US.UTF-8

# Prefer Homebrew git over the Xcode copy.
export PATH="/opt/homebrew/opt/git/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

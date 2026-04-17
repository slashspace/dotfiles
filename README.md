# dotfiles

A modular macOS development environment configuration system. Three-layer architecture, unified theme engine, one-command setup.

## Directory Structure

```
dotfiles/
├── core/              Cross-platform essentials
│   ├── git/             Git config
│   ├── zsh/             Shell config (Sheldon)
│   ├── sheldon/         Plugin manager config
│   ├── nvim/            Neovim config (lazy.nvim)
│   ├── tmux/            Tmux config
│   └── starship/        Prompt config
│
├── modules/           macOS platform modules
│   ├── aerospace/       Tiling window manager
│   ├── ghostty/         Terminal emulator
│   ├── karabiner/       Keyboard remapping
│   ├── sketchybar/      Menu bar replacement
│   ├── borders/         Window focus borders
│   └── gitmux/          Tmux git status
│
└── system/            Engine
    ├── bin/             CLI entry point (dotfiles, dotfiles-theme, ...)
    ├── themes/          Theme system (optional)
    ├── lib/             Shared libs & Zsh modules
    └── packages/        Brewfile dependency manifest
```

## Architecture

```mermaid
flowchart TB
    subgraph bootstrap ["Bootstrap (dotfiles bootstrap)"]
        B1["1. Xcode CLI"]
        B2["2. Homebrew"]
        B3["3. Brew Bundle"]
        B4["4. Sheldon"]
        B5["5. Stow core/"]
        B6["6. Theme apply"]
        B1 --> B2 --> B3 --> B4 --> B5 --> B6
    end

    subgraph layers ["Three-Layer Structure"]
        direction LR
        CORE["core/<br/>git · zsh · sheldon · nvim · tmux · starship"]
        MODS["modules/<br/>aerospace · ghostty · karabiner<br/>sketchybar · borders · gitmux"]
        SYS["system/<br/>themes · lib · bin · packages"]
    end

    subgraph stow ["Stow Manager"]
        SM["dotfiles stow"]
        SM -->|"--target $HOME"| CORE
        SM -->|"--target $HOME/.config/..."| MODS
    end

    subgraph theme ["Theme Engine"]
        direction TB
        TL["themes/list/*.sh<br/>Semantic color definitions"]
        TR["themes/renderers/<br/>starship · sketchybar · tmux · borders"]
        TG["themes/generated/<br/>Tool-specific configs (gitignored)"]
        CLI["dotfiles theme<br/>CLI: list · apply · select · current"]
        TL --> CLI --> TR --> TG
    end

    bootstrap --> layers
    layers --> stow
    SYS --> theme
    TG -.->|"source / include"| CORE
    TG -.->|"source / include"| MODS
```

## Theme System Flow

```mermaid
flowchart LR
    subgraph source ["Source"]
        T1["catppuccin-mocha.sh"]
        T2["dracula.sh"]
        T3["tokyo-night.sh"]
        T4["... 9 more"]
    end

    subgraph apply ["theme apply <name>"]
        S["Source theme file<br/>(loads THEME_* vars)"]
        R["Run all renderers"]
        P["Persist to .current-theme"]
    end

    subgraph generated ["Generated (gitignored)"]
        G1["starship.toml"]
        G2["sketchybar-colors.sh"]
        G3["tmux-colors.conf"]
        G4["borders-colors.sh"]
    end

    subgraph tools ["Tool Integration"]
        ST["Starship<br/>STARSHIP_CONFIG env var"]
        SB["SketchyBar<br/>source colors.sh"]
        TM["Tmux<br/>source-file tmux-colors.conf"]
        BD["Borders<br/>CLI args from colors"]
    end

    source --> S --> R --> P
    R --> generated
    G1 --> ST
    G2 --> SB
    G3 --> TM
    G4 --> BD
```

## Zsh Startup Flow

```mermaid
flowchart TB
    ZSHRC[".zshrc"]
    SHELDON["Sheldon (plugin manager)"]
    PLUGINS["Plugins<br/>zsh-vi-mode (sync)<br/>zsh-defer (sync)<br/>zsh-syntax-highlighting (deferred)<br/>zsh-autosuggestions (deferred)<br/>zsh-autopair (deferred)<br/>zsh-completions (fpath)"]

    subgraph modules ["System Modules"]
        ALIAS["alias.sh"]
        HIST["history.sh"]
        CLR["colors.sh (palette defaults)"]
        TOOL["tools.sh (starship, fzf, eza, bat, zoxide)"]
    end

    LOCAL["~/.zshrc.local (optional)"]

    ZSHRC --> SHELDON
    SHELDON --> PLUGINS
    PLUGINS --> ALIAS
    ALIAS --> HIST --> CLR --> TOOL
    TOOL --> LOCAL
```

## Stow Package Mapping

```mermaid
flowchart LR
    subgraph core_pkgs ["core/"]
        direction TB
        CG["git/.gitconfig"]
        CZ["zsh/.zshrc"]
        CSD["sheldon/plugins.toml"]
        CN["nvim/init.lua lua/..."]
        CT["tmux/tmux.conf"]
        CS["starship/starship.toml"]
    end

    subgraph module_pkgs ["modules/"]
        direction TB
        MA["aerospace/aerospace.toml"]
        MG["ghostty/config"]
        MK["karabiner/karabiner.json assets/"]
        MS["sketchybar/sketchybarrc items/ plugins/"]
        MB["borders/bordersrc"]
        MX["gitmux/.gitmux.conf"]
    end

    subgraph system_pkgs ["system/"]
        direction TB
        CB["bin/ (dotfiles CLI)"]
    end

    subgraph targets ["~ (Home)"]
        direction TB
        T1["$HOME/.gitconfig"]
        T2["$HOME/.zshrc"]
        T3["$HOME/.config/nvim/"]
        T4["$HOME/.config/tmux/"]
        T5["$HOME/.config/aerospace/"]
        T6["$HOME/.config/ghostty/"]
        T7["$HOME/.config/sketchybar/"]
        T8["$HOME/.local/bin/ (CLI)"]
    end

    CG -->|"stow --target=$HOME"| T1
    CZ -->|"stow --target=$HOME"| T2
    CN -->|"stow --target=$HOME/.config/nvim"| T3
    CT -->|"stow --target=$HOME/.config/tmux"| T4
    MA -->|"stow --target=$HOME/.config/aerospace"| T5
    MG -->|"stow --target=$HOME/.config/ghostty"| T6
    MS -->|"stow --target=$HOME/.config/sketchybar"| T7
    CB -->|"stow --target=$HOME/.local/bin"| T8
```

## Quick Start

### 1. Clone

```bash
git clone <repo-url> ~/dotfiles
```

### 2. Bootstrap

```bash
dotfiles bootstrap
```

Automatically: Xcode CLI → Homebrew → Brew Bundle → Sheldon lock → Stow core → Apply default theme.

### 3. macOS Modules (optional)

```bash
dotfiles modules install
```

### 4. macOS Defaults (optional)

```bash
dotfiles defaults
```

### 5. Verify & Restart

```bash
dotfiles doctor             # Check everything is working
exec zsh
```

## dotfiles CLI

All commands are available via `dotfiles help`:

```bash
dotfiles theme list                  # List available themes
dotfiles theme apply <name>          # Apply a theme
dotfiles theme select [name]         # Interactive selection (fzf) or by name
dotfiles theme current               # Show current theme
dotfiles stow apply --core           # Symlink core packages
dotfiles stow apply --modules        # Symlink macOS modules
dotfiles stow apply --all            # Symlink everything
dotfiles stow delete --core          # Remove core symlinks
dotfiles stow dry-run --core         # Preview stow operations
dotfiles doctor                      # Run health checks
dotfiles bootstrap                   # One-time setup
dotfiles modules install             # Install macOS modules
dotfiles defaults                    # Apply macOS system defaults
```

After running `dotfiles stow apply --core`, all commands are available at `~/.local/bin/dotfiles`.

## Theme CLI

```bash
dotfiles theme list              # List all themes
dotfiles theme current           # Show current theme
dotfiles theme apply catppuccin-mocha # Apply a theme
dotfiles theme select            # Interactive selection (fzf)
```

The theme system is optional — without running `dotfiles theme apply`, all tools use their default configs.

Each theme defines 29 semantic color variables (inspired by [Catppuccin](https://catppuccin.com) naming). Renderers convert these to tool-specific formats stored in `system/themes/generated/` (gitignored).

### Available Themes

catppuccin-mocha · catppuccin-macchiato · dracula · gruvbox-dark · tokyo-night · kanagawa · nord · rose-pine · everforest · solarized-dark · retro-phosphor

### Custom Theme

Create a `.sh` file in `system/themes/list/` exporting all `THEME_*` variables. See `system/themes/palette.sh` for the full variable list.

## Health Check

```bash
dotfiles doctor
```

Checks: dependencies, config files, theme status, known references.

## Local Overrides

- `~/.zshrc.local` — Local Zsh config (not tracked by Git)
- `~/.gitconfig.local` — Git user.name/email and other secrets

## Dependencies

Managed via Homebrew, declared in `system/packages/Brewfile`:

| Category | Tools |
|----------|-------|
| Core | git, stow, fzf |
| Shell | starship, sheldon, eza, bat, zoxide |
| Terminal | tmux, gitmux, nvim |
| Desktop | aerospace, ghostty, karabiner-elements, sketchybar, borders |
| Dev tools | shellcheck, shfmt |

## Platform Support

macOS only. Linux support is architecturally prepared:
- `system/lib/platform.sh` — Platform detection
- `system/lib/package.sh` — Package manager abstraction (Homebrew / apt / pacman)
- Future: add `modules/linux/` with i3/sway/waybar configs

## License

MIT

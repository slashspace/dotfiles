# dotfiles

A modular macOS development environment configuration system. Three-layer architecture, unified theme engine, one-command setup.

## Directory Structure

```
dotfiles/
├── core/              Cross-platform essentials
│   ├── git/             Git config
│   ├── zsh/             Shell config (zinit)
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
    ├── themes/          Theme system (optional)
    ├── lib/             Shared libs & Zsh modules
    ├── scripts/         Install & management scripts
    └── packages/        Brewfile dependency manifest
```

## Architecture

```mermaid
flowchart TB
    subgraph bootstrap ["Bootstrap (system/scripts/bootstrap.sh)"]
        B1["1. Xcode CLI"]
        B2["2. Homebrew"]
        B3["3. Brew Bundle"]
        B4["4. zinit"]
        B5["5. Stow core/"]
        B6["6. Theme apply"]
        B1 --> B2 --> B3 --> B4 --> B5 --> B6
    end

    subgraph layers ["Three-Layer Structure"]
        direction LR
        CORE["core/<br/>git · zsh · nvim · tmux · starship"]
        MODS["modules/<br/>aerospace · ghostty · karabiner<br/>sketchybar · borders · gitmux"]
        SYS["system/<br/>themes · lib · scripts · packages"]
    end

    subgraph stow ["Stow Manager"]
        SM["stow-manager.sh"]
        SM -->|"--target $HOME"| CORE
        SM -->|"--target $HOME/.config/..."| MODS
    end

    subgraph theme ["Theme Engine"]
        direction TB
        TL["themes/list/*.sh<br/>Semantic color definitions"]
        TR["themes/renderers/<br/>ghostty · starship · sketchybar · tmux · borders"]
        TG["themes/generated/<br/>Tool-specific configs (gitignored)"]
        CLI["themes/bin/theme<br/>CLI: list · apply · current"]
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
        T1["darkppuccin.sh"]
        T2["catppuccin-mocha.sh"]
        T3["batman.sh"]
        T4["... 11 more"]
    end

    subgraph apply ["theme apply <name>"]
        S["Source theme file<br/>(loads THEME_* vars)"]
        R["Run all renderers"]
        P["Persist to .current-theme"]
    end

    subgraph generated ["Generated (gitignored)"]
        G1["ghostty-theme"]
        G2["starship.toml"]
        G3["sketchybar-colors.sh"]
        G4["tmux-colors.conf"]
        G5["borders-colors.sh"]
    end

    subgraph tools ["Tool Integration"]
        GT["Ghostty<br/>config-file = themes/active"]
        ST["Starship<br/>STARSHIP_CONFIG env var"]
        SB["SketchyBar<br/>source colors.sh"]
        TM["Tmux<br/>source-file tmux-colors.conf"]
        BD["Borders<br/>CLI args from colors"]
    end

    source --> S --> R --> P
    R --> generated
    G1 --> GT
    G2 --> ST
    G3 --> SB
    G4 --> TM
    G5 --> BD
```

## Zsh Startup Flow

```mermaid
flowchart TB
    ZSHRC[".zshrc"]
    ZSHENV[".zshenv (PATH, DOTFILES_DIR)"]
    ZINIT["zinit (plugin manager)"]
    PLUGINS["Plugins<br/>zsh-syntax-highlighting<br/>zsh-autosuggestions<br/>jeffreytse/zsh-vi-mode<br/>zsh-completions"]

    subgraph modules ["System Modules"]
        ALIAS["alias.sh"]
        HIST["history.sh"]
        CLR["colors.sh (palette defaults)"]
        TOOL["tools.sh (starship, fzf, eza, bat, zoxide)"]
    end

    LOCAL["~/.zshrc.local (optional)"]

    ZSHRC --> ZSHENV
    ZSHENV --> ZINIT
    ZINIT --> PLUGINS
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
        CZ["zsh/.zshrc .zshenv"]
        CN["nvim/init.lua lua/..."]
        CT["tmux/tmux.conf"]
        CS["starship/starship.toml"]
    end

    subgraph module_pkgs ["modules/"]
        direction TB
        MA["aerospace/aerospace.toml"]
        MG["ghostty/config themes/ shaders/"]
        MK["karabiner/karabiner.json assets/"]
        MS["sketchybar/sketchybarrc items/ plugins/"]
        MB["borders/bordersrc"]
        MX["gitmux/.gitmux.conf"]
    end

    subgraph targets ["~ (Home)"]
        T1["$HOME/.gitconfig"]
        T2["$HOME/.zshrc"]
        T3["$HOME/.config/nvim/"]
        T4["$HOME/.config/tmux/"]
        T5["$HOME/.config/aerospace/"]
        T6["$HOME/.config/ghostty/"]
        T7["$HOME/.config/sketchybar/"]
    end

    CG -->|"stow --target=$HOME"| T1
    CZ -->|"stow --target=$HOME"| T2
    CN -->|"stow --target=$HOME/.config/nvim"| T3
    CT -->|"stow --target=$HOME/.config/tmux"| T4
    MA -->|"stow --target=$HOME/.config/aerospace"| T5
    MG -->|"stow --target=$HOME/.config/ghostty"| T6
    MS -->|"stow --target=$HOME/.config/sketchybar"| T7
```

## Quick Start

### 1. Clone

```bash
git clone <repo-url> ~/dotfiles
```

### 2. Bootstrap

```bash
~/dotfiles/system/scripts/bootstrap.sh
```

Automatically: Xcode CLI → Homebrew → Brew Bundle → zinit → Stow core → Apply default theme.

### 3. macOS Modules (optional)

```bash
~/dotfiles/system/scripts/install-modules.sh
```

### 4. macOS Defaults (optional)

```bash
~/dotfiles/system/scripts/macos-defaults.sh
```

### 5. Restart Shell

```bash
exec zsh
```

## Theme CLI

```bash
theme list              # List all themes
theme current           # Show current theme
theme apply darkppuccin # Apply a theme
theme apply             # Interactive selection (fzf)
```

The theme system is optional — without running `theme apply`, all tools use their default configs.

Each theme defines 29 semantic color variables (inspired by [Catppuccin](https://catppuccin.com) naming). Renderers convert these to tool-specific formats stored in `system/themes/generated/` (gitignored).

### Available Themes

darkppuccin · catppuccin-mocha · catppuccin-macchiato · batman · eldritch-colors · linkarzu-colors · linkarzu-new-headings · minty-lemon · pastel-fiambre · pikachu · radioactive-fiambre · retro-phosphor · star-saber · star-saber-dark

### Custom Theme

Create a `.sh` file in `system/themes/list/` exporting all `THEME_*` variables. See `system/themes/palette.sh` for the full variable list.

## Stow Management

```bash
# Preview
~/dotfiles/system/scripts/stow-manager.sh dry-run --core
~/dotfiles/system/scripts/stow-manager.sh dry-run --modules

# Apply
~/dotfiles/system/scripts/stow-manager.sh apply --core
~/dotfiles/system/scripts/stow-manager.sh apply --modules

# Remove
~/dotfiles/system/scripts/stow-manager.sh delete --core
~/dotfiles/system/scripts/stow-manager.sh delete --modules
```

## Local Overrides

- `~/.zshrc.local` — Local Zsh config (not tracked by Git)
- `~/.gitconfig.local` — Git user.name/email and other secrets

## Dependencies

Managed via Homebrew, declared in `system/packages/Brewfile`:

| Category | Tools |
|----------|-------|
| Core | git, stow, fzf |
| Shell | starship, zinit, eza, bat, zoxide |
| Terminal | tmux, gitmux, nvim |
| Desktop | aerospace, ghostty, karabiner-elements, sketchybar, borders |

## Platform Support

macOS only. Linux support is architecturally prepared:
- `system/lib/platform.sh` — Platform detection
- `system/lib/package.sh` — Package manager abstraction (Homebrew / apt / pacman)
- Future: add `modules/linux/` with i3/sway/waybar configs

## License

MIT

# Dotfiles 产品化设计文档

## 概述

将个人 dotfiles 仓库重构为产品级开发环境配置系统。目标是打造一套 macOS 开发环境的开箱即用配置，具备统一主题系统、模块化架构、轻量且可扩展，未来可面向其他开发者交付。

## 已确认的决策

| 决策 | 选择 |
|------|------|
| 定位 | 产品级开发环境配置系统 |
| 平台策略 | 先 macOS，架构预留 Linux 扩展 |
| 工具范围 | 全部当前工具 |
| 主题系统 | 语义化颜色命名（catppuccin 模式），可选模块 |
| 安装体验 | 两步走：核心一键安装 + 平台模块按需启用 |
| Shell 框架 | zinit 替换 Oh My Zsh |
| 架构方案 | 三层分离：core / modules / system |
| 项目名 | dotfiles |

## 架构设计

### 目录结构

三目录原则：`core/`（通用）、`modules/`（平台特定）、`system/`（引擎代码）。

```
dotfiles/
├── core/                           # 核心层：跨平台通用工具
│   ├── git/
│   │   └── .gitconfig
│   ├── zsh/
│   │   ├── .zshrc
│   │   └── .zshenv
│   ├── tmux/
│   │   └── tmux.conf
│   ├── nvim/
│   │   ├── init.lua
│   │   └── lua/
│   └── starship/
│       └── starship.toml           # 默认配置（无主题时使用）
│
├── modules/                        # 平台模块层：macOS 特有
│   ├── aerospace/
│   │   └── aerospace.toml
│   ├── ghostty/
│   │   ├── config
│   │   └── themes/
│   ├── karabiner/
│   │   ├── karabiner.json
│   │   └── assets/
│   ├── sketchybar/
│   │   ├── sketchybarrc
│   │   ├── items/
│   │   └── plugins/
│   ├── borders/
│   │   └── bordersrc
│   └── gitmux/
│       └── .gitmux.conf
│
├── system/                         # 项目引擎
│   ├── themes/
│   │   ├── palette.sh
│   │   ├── list/
│   │   ├── renderers/
│   │   ├── generated/              # .gitignore
│   │   └── bin/theme
│   ├── lib/
│   │   ├── platform.sh
│   │   ├── package.sh
│   │   └── log.sh
│   ├── scripts/
│   │   ├── bootstrap.sh
│   │   ├── install-core.sh
│   │   ├── install-modules.sh
│   │   ├── stow-manager.sh
│   │   └── macos-defaults.sh
│   └── packages/
│       └── Brewfile
│
└── README.md
```

### Stow 包管理

每个 stow package 内部保持扁平，通过 package registry 定义 target 映射，消除 `.config/tool/` 的深层嵌套。

```sh
# system/scripts/stow-manager.sh 中的 registry
CORE_PACKAGES=(
  "git:$HOME"
  "zsh:$HOME"
  "tmux:$HOME/.config/tmux"
  "nvim:$HOME/.config/nvim"
  "starship:$HOME/.config/starship"
)

MACOS_PACKAGES=(
  "aerospace:$HOME/.config/aerospace"
  "ghostty:$HOME/.config/ghostty"
  "karabiner:$HOME/.config/karabiner"
  "sketchybar:$HOME/.config/sketchybar"
  "borders:$HOME/.config/borders"
  "gitmux:$HOME"
)

# 调用方式
# stow --dir=core --target=$HOME/.config/nvim nvim
# stow --dir=modules --target=$HOME/.config/aerospace aerospace
```

对比当前嵌套：

```
# 之前（3-4 层）
karabiner/.config/karabiner/karabiner.json

# 之后（1 层）
modules/karabiner/karabiner.json
```

### 主题系统

#### 语义色定义

参考 catppuccin style guide，定义一套语义化的颜色命名体系。每个主题文件 export 相同的语义色变量。

`system/themes/palette.sh` 定义默认值和语义：

```sh
# 背景色层级（由浅到深）
THEME_BG="base"           # 主背景
THEME_BG_SURFACE="surface" # 次级面板
THEME_BG_OVERLAY="overlay" # 覆盖层

# 文本色层级
THEME_FG="text"           # 正文
THEME_FG_SUBTLE="subtext" # 次级文字
THEME_FG_MUTED="muted"    # 弱化文字

# 强调色
THEME_ROSEWATER="rosewater"
THEME_FLAMINGO="flamingo"
THEME_PINK="pink"
THEME_MAUVE="mauve"
THEME_RED="red"
THEME_MAROON="maroon"
THEME_PEACH="peach"
THEME_YELLOW="yellow"
THEME_GREEN="green"
THEME_TEAL="teal"
THEME_SKY="sky"
THEME_SAPPHIRE="sapphire"
THEME_BLUE="blue"
THEME_LAVENDER="lavender"
```

每个主题文件（`system/themes/list/darkppuccin.sh`）：

```sh
#!/usr/bin/env sh
export THEME_BG="#09090d"
export THEME_BG_SURFACE="#1a1a2e"
export THEME_BG_OVERLAY="#2a2a3e"
export THEME_FG="#ebfafa"
export THEME_FG_SUBTLE="#a0aec0"
export THEME_FG_MUTED="#6b7280"
export THEME_ROSEWATER="#f5e0dc"
export THEME_RED="#f38ba8"
# ... 每个语义色的实际 hex 值
```

#### 渲染器

每个工具一个渲染器，读取语义色变量，输出工具特定格式到 `system/themes/generated/`。

| 渲染器 | 输入 | 输出 |
|--------|------|------|
| `renderers/ghostty.sh` | 语义色 | `generated/ghostty-theme` (Ghostty palette 格式) |
| `renderers/starship.sh` | 语义色 | `generated/starship.toml` (Starship 配置) |
| `renderers/sketchybar.sh` | 语义色 | `generated/sketchybar-colors.sh` (shell 变量) |
| `renderers/tmux.sh` | 语义色 | `generated/tmux-colors.conf` (tmux 格式) |
| `renderers/borders.sh` | 语义色 | `generated/borders-colors.sh` (shell 变量) |

生成产物目录 `system/themes/generated/` 加入 `.gitignore`。

#### 工具接入方式

各工具通过环境变量或 include 指向生成产物，stow 包内不包含生成内容：

- **Starship**: `export STARSHIP_CONFIG=$DOTFILES_DIR/system/themes/generated/starship.toml`
- **Ghostty**: config 中 `theme = "active"`，将 generated/ghostty-theme symlink 到 ghostty themes 目录
- **SketchyBar**: `source $DOTFILES_DIR/system/themes/generated/sketchybar-colors.sh`
- **tmux**: `source-file $DOTFILES_DIR/system/themes/generated/tmux-colors.conf`
- **Borders**: `source $DOTFILES_DIR/system/themes/generated/borders-colors.sh`

#### 主题 CLI

`system/themes/bin/theme` 提供三个命令：

```sh
theme list                  # 列出所有可用主题
theme select [name]         # 交互式(fzf)或直接选择主题
theme apply [name]          # 选择并立即应用主题
theme current               # 显示当前主题名
```

`theme apply` 的执行流程：
1. source 选中的主题文件（加载语义色变量）
2. 依次执行所有渲染器，生成产物到 `generated/`
3. 将主题名写入 `generated/.current-theme`（持久化当前选择）
4. reload 受影响的工具（sketchybar --reload, tmux source-file 等）

主题系统完全可选——不运行 `theme apply`，所有工具使用各自 stow 包内的默认配置。

### 包管理抽象

`system/lib/package.sh` 提供平台无关的包管理接口：

```sh
pkg_manager()    # 返回当前包管理器: brew / apt / pacman
pkg_install()    # 安装单个包
pkg_bundle()     # 从 bundle 文件批量安装
```

macOS 实现 Homebrew 后端，`system/packages/Brewfile` 声明依赖。后续 Linux 扩展时添加 apt/pacman 后端和对应的 bundle 文件。

### 平台检测

`system/lib/platform.sh`：

```sh
platform_os()       # 返回: macos / linux
platform_distro()   # Linux 时返回: ubuntu / arch / fedora ...
platform_arch()     # 返回: arm64 / x86_64
```

`install-modules.sh` 根据平台选择模块目录（当前仅 macOS，未来加 `modules/linux/`）。

### 安装流程

两步走设计：

**Step 1 — 核心安装（一键）：**

```sh
git clone https://github.com/user/dotfiles.git ~/dotfiles
~/dotfiles/system/scripts/bootstrap.sh
```

`bootstrap.sh` 做的事：
1. 检测平台（调用 `lib/platform.sh`）
2. 安装基础依赖（Xcode CLI + Homebrew，调用 `lib/package.sh`）
3. `brew bundle --file=system/packages/Brewfile`（安装所有核心和模块工具）
4. 安装 zinit（zsh 插件管理器）
5. `stow-manager.sh apply --core`（stow 所有核心包）
6. 可选：应用默认主题（如果用户选择）
7. 提示用户重启 shell

**Step 2 — 平台模块（按需）：**

```sh
~/dotfiles/system/scripts/install-modules.sh
# 或手动：
~/dotfiles/system/scripts/stow-manager.sh apply --modules
~/dotfiles/system/scripts/macos-defaults.sh
theme apply darkppuccin
```

### Zsh 配置重构

用 zinit 替换 Oh My Zsh，保留相同的 4 个插件功能：

```sh
# core/zsh/.zshrc 核心结构

# 1. 环境变量
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
source "$DOTFILES_DIR/core/zsh/.zshenv"

# 2. zinit + 插件
source ~/.local/share/zinit/zinit.git/zinit.zsh
zinit light-mode for \
  zsh-users/zsh-syntax-highlighting \
  zsh-users/zsh-autosuggestions \
  zsh-vi-mode \
  zinit-zsh/z-a-bin-gem-node

# 3. 加载模块
source "$DOTFILES_DIR/system/lib/modules/alias.sh"
source "$DOTFILES_DIR/system/lib/modules/history.sh"
source "$DOTFILES_DIR/system/lib/modules/tools.sh"

# 4. 主题（可选）
if [[ -f "$DOTFILES_DIR/system/themes/generated/.current-theme" ]]; then
  source "$DOTFILES_DIR/system/themes/generated/sketchybar-colors.sh"
fi

# 5. 本地覆盖
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
```

zsh 模块文件从 `support/zsh/modules/` 迁移到 `system/lib/modules/`。

### 新增 stow package: git

```
core/git/
└── .gitconfig
```

包含共享 git 配置（alias、core.editor、pull.rebase 等）。敏感信息通过条件包含处理：

```gitconfig
# .gitconfig 末尾
[include]
  path = ~/.gitconfig.local
```

用户在 `~/.gitconfig.local` 中放 `user.name` 和 `user.email`。

### 文件迁移映射

| 当前位置 | 目标位置 | 说明 |
|----------|----------|------|
| `zsh/.zshrc` | `core/zsh/.zshrc` | 重写内容 |
| `nvim/.config/nvim/*` | `core/nvim/*` | 扁平化 |
| `tmux/.config/tmux/tmux.conf` | `core/tmux/tmux.conf` | 扁平化 |
| `starship/.config/starship/starship.toml` | 删除（由主题生成） | — |
| `aerospace/.config/aerospace/*` | `modules/aerospace/*` | 扁平化 |
| `ghostty/.config/ghostty/*` | `modules/ghostty/*` | 扁平化 |
| `karabiner/.config/karabiner/*` | `modules/karabiner/*` | 扁平化 |
| `sketchybar/.config/sketchybar/*` | `modules/sketchybar/*` | 扁平化 |
| `gitmux/.gitmux.conf` | `modules/gitmux/.gitmux.conf` | 移动 |
| `support/colorscheme/list/*.sh` | `system/themes/list/` | 重写变量名 |
| `support/zsh/modules/*.sh` | `system/lib/modules/` | 保留逻辑 |
| `support/scripts/stow-packages.sh` | `system/scripts/stow-manager.sh` | 重写 |
| `support/scripts/fzf-git.sh` | `system/lib/scripts/fzf-git.sh` | 移动 |
| `bootstrap.sh` | `system/scripts/bootstrap.sh` | 重写 |
| `Brewfile` | `system/packages/Brewfile` | 移动 |
| `docs/` | `docs/` | 更新内容 |

### .gitignore

```
*.log
system/themes/generated/
modules/karabiner/automatic_backups/
```

## 不做什么

- 不做 Linux 支持（架构预留，但不实现）
- 不做 Oh My Zsh 兼容层（直接替换为 zinit）
- 不做主题编辑器 GUI
- 不做自动更新机制
- 不做文档站（MVP 阶段 README 够用）

## 验证方式

1. 在当前机器上完成迁移，验证所有工具正常工作
2. `stow-manager.sh --dry-run` 确认 symlink 路径正确
3. 打开新 shell 验证 zsh 启动无报错、插件加载正常
4. `theme apply darkppuccin` 验证主题切换，所有工具同步变色
5. `git status` 确认生成产物不被追踪
6. 记录 zsh 启动时间（对比迁移前后）

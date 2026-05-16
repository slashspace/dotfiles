# dotfiles 使用指南

这是一个面向 macOS 的 dotfiles 仓库，使用 GNU Stow 管理符号链接。`core/` 放核心工具配置，`modules/` 放可选桌面模块，`system/` 放共享脚本和主题工具。

[English](README.md)

## 目录结构

```text
dotfiles/
├── core/              核心工具
│   ├── git/             Git 配置
│   ├── zsh/             Shell 配置（Sheldon）
│   ├── sheldon/         插件管理器配置
│   ├── nvim/            Neovim 配置
│   ├── tmux/            Tmux 配置
│   ├── starship/        提示符配置
│   └── opencode/        OpenCode 配置
├── modules/           可选 macOS 模块
│   ├── aerospace/       窗口管理器
│   ├── ghostty/         终端模拟器
│   ├── karabiner/       键盘映射
│   ├── sketchybar/      精简状态栏
│   └── borders/         窗口边框
└── system/            共享工具
    ├── bin/             CLI 入口
    ├── lib/             共享 shell 模块与辅助脚本
    ├── packages/        Brewfile
    └── themes/          可选主题工作流
```

## 架构说明

- `core/` 放 shell、编辑器、终端等基础配置。
- `modules/` 放 macOS 专属、可选安装的模块。
- `system/bin/dotfiles` 是主 CLI。
- `dotfiles stow` 会按包名把文件链接到真实目标目录，而不是统一丢到一个路径。
- 主题系统是可选的；如果不运行 `dotfiles theme`，各工具就使用默认配置。

## 快速开始

### 1. 克隆仓库

```bash
git clone <repo-url> ~/dotfiles
```

如果仓库不在 `~/dotfiles`，运行脚本时传入 `DOTFILES_DIR` 即可。

### 2. 安装核心配置

```bash
dotfiles bootstrap
```

它会在需要时安装 Xcode CLI Tools 和 Homebrew，然后执行 `brew bundle`、锁定 Sheldon 插件、stow 核心包，并应用默认主题。

### 3. 应用 macOS 默认设置（可选）

```bash
dotfiles defaults
```

### 4. 重启 shell

```bash
exec zsh
```

## 常用命令

```bash
dotfiles bootstrap              # 一次性初始化
dotfiles stow apply|delete|dry-run --core|--modules|--all
dotfiles theme                  # fzf 选择主题（当前主题标 ●）
dotfiles defaults               # 应用 macOS 系统默认值

# 仓库维护（在仓库根目录执行）
./scripts/lint                  # shellcheck + shfmt 全仓检查
./scripts/check                 # 检查 Brewfile 状态和待升级的包
```

执行 `dotfiles bootstrap`（或 `dotfiles stow apply --core`）之后，CLI 会出现在 `~/.local/bin/dotfiles`。

## 主题工作流

```bash
dotfiles theme   # fzf 选择，当前主题以 ● 标注
```

说明：

- 主题产物会写入 `system/themes/generated/`
- 当前主题名保存在 `system/themes/generated/.current-theme`
- SketchyBar、tmux、Ghostty 等相关生成文件会通过这套流程更新

可用主题：

`catppuccin-mocha`、`gruvbox`、`kanagawa`、`matrix`、`rose-pine`、`tokyo-night`

自定义主题放在 `system/themes/palettes/`，并导出 `system/themes/README.md` 中描述的 `THEME_*` 变量。

## 本地覆盖

- `~/.zshrc.local`：机器专属 shell 配置
- `~/.gitconfig.local`：Git 身份和本地敏感配置

## 依赖

通过 Homebrew 管理，定义在 `system/packages/Brewfile`：

| 类别 | 工具 |
|------|------|
| 核心 | git, stow, fzf |
| Shell | starship, sheldon, eza, bat, zoxide |
| 终端 | tmux, gitmux, nvim |
| 桌面 | aerospace, ghostty, karabiner-elements, sketchybar, borders |
| 开发工具 | shellcheck, shfmt |

## 备注

- 仅支持 macOS。SketchyBar 刻意保持精简：工作区、日期时间、电池、Wi-Fi、音量。

## 卸载

```bash
dotfiles stow delete --all
rm -rf ~/dotfiles
rm -rf ~/.local/share/sheldon
rm -f ~/.zshrc.local ~/.gitconfig.local
```

## License

MIT

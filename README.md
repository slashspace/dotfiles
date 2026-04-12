# dotfiles

一套模块化的 macOS 开发环境配置系统。三层架构，统一主题，一键安装。

## 目录结构

```
dotfiles/
├── core/           跨平台核心工具
│   ├── git/          Git 配置
│   ├── zsh/          Shell 配置（zinit 驱动）
│   ├── nvim/         Neovim 配置（lazy.nvim）
│   ├── tmux/         Tmux 配置
│   └── starship/     提示符配置
│
├── modules/        macOS 平台模块
│   ├── aerospace/    窗口管理器
│   ├── ghostty/      终端模拟器
│   ├── karabiner/    键盘映射
│   ├── sketchybar/   状态栏
│   ├── borders/      窗口边框
│   └── gitmux/       Tmux Git 状态
│
└── system/         引擎代码
    ├── themes/       主题系统（可选）
    ├── lib/          共享库与 Zsh 模块
    ├── scripts/      安装与管理脚本
    └── packages/     Brewfile 依赖声明
```

## 快速开始

### 1. 克隆仓库

```bash
git clone <repo-url> ~/dotfiles
```

### 2. 一键安装核心工具

```bash
~/dotfiles/system/scripts/bootstrap.sh
```

这个脚本会自动：
- 安装 Xcode CLI Tools（如缺失）
- 安装 Homebrew（如缺失）
- 通过 Brewfile 安装所有依赖
- 安装 zinit（Zsh 插件管理器）
- Stow 所有核心包（git、zsh、nvim、tmux、starship）
- 应用 darkppuccin 默认主题

### 3. 安装 macOS 模块（可选）

```bash
~/dotfiles/system/scripts/install-modules.sh
```

安装 AeroSpace、Ghostty、Karabiner、SketchyBar、Borders、gitmux。

### 4. 设置 macOS 偏好（可选）

```bash
~/dotfiles/system/scripts/macos-defaults.sh
```

配置键盘重复速率、Dock 自动隐藏、Finder 显示隐藏文件等。

### 5. 重启 Shell

```bash
exec zsh
```

## 主题系统

主题系统是可选的——不运行 `theme apply`，所有工具使用各自默认配置。

### 可用命令

```bash
theme list              # 列出所有主题
theme current           # 显示当前主题
theme apply darkppuccin # 应用指定主题
theme apply             # 交互式选择（fzf）
```

### 工作原理

1. 每个主题文件定义 29 个语义颜色变量（参考 [Catppuccin](https://catppuccin.com) 命名体系）
2. 渲染器将语义颜色转换为各工具的配置格式
3. 生成产物存放在 `system/themes/generated/`（已 gitignore）
4. 各工具通过 source/include 指向生成产物

### 当前主题列表

darkppuccin · catppuccin-mocha · catppuccin-macchiato · batman · eldritch-colors · linkarzu-colors · linkarzu-new-headings · minty-lemon · pastel-fiambre · pikachu · radioactive-fiambre · retro-phosphor · star-saber · star-saber-dark

### 自定义主题

在 `system/themes/list/` 下创建新的 `.sh` 文件，导出全部 `THEME_*` 变量即可。参考 `system/themes/palette.sh` 中的变量定义。

## Stow 管理

```bash
# 预览（不实际操作）
~/dotfiles/system/scripts/stow-manager.sh dry-run --core
~/dotfiles/system/scripts/stow-manager.sh dry-run --modules

# 安装
~/dotfiles/system/scripts/stow-manager.sh apply --core
~/dotfiles/system/scripts/stow-manager.sh apply --modules

# 卸载
~/dotfiles/system/scripts/stow-manager.sh delete --core
~/dotfiles/system/scripts/stow-manager.sh delete --modules
```

## 本地覆盖

- `~/.zshrc.local` — Zsh 本地配置（不纳入 Git）
- `~/.gitconfig.local` — Git 用户名/邮箱等敏感信息

## Git 配置

共享 Git 配置在 `core/git/.gitconfig`，包含常用 alias 和设置。

在 `~/.gitconfig.local` 中设置个人信息：

```gitconfig
[user]
    name = Your Name
    email = you@example.com
```

## 依赖

核心依赖通过 Homebrew 管理，声明在 `system/packages/Brewfile` 中：

| 类别 | 工具 |
|------|------|
| 核心 | git, stow, fzf |
| Shell | starship, zinit, eza, bat, zoxide |
| 终端 | tmux, gitmux, nvim |
| 桌面 | aerospace, ghostty, karabiner-elements, sketchybar, borders |

## 平台支持

当前仅支持 macOS。架构上预留了 Linux 扩展能力：
- `system/lib/platform.sh` — 平台检测
- `system/lib/package.sh` — 包管理抽象（Homebrew / apt / pacman）
- 后续可在 `modules/` 下新增 `linux/` 模块

## License

MIT

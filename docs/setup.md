# Setup Guide

## 适用环境

- macOS
- `zsh`
- GNU Stow 管理软链接

## Bootstrap（推荐）

仓库根目录提供 `bootstrap.sh`，用于一次性完成环境准备与链接：

1. **Xcode Command Line Tools**：未安装时会触发安装并退出，安装完成后需重新执行。
2. **Homebrew**：未安装时自动安装。
3. **brew bundle**：根据根目录 [Brewfile](../Brewfile) 安装 CLI 与 cask 依赖。
4. **Oh My Zsh**：未检测到时会提示安装命令（需自行执行）。
5. **Stow**：先 dry-run 再 apply，使用 `support/scripts/stow-packages.sh`。

```bash
cd "$HOME/dotfiles"
./bootstrap.sh
```

若仓库不在 `~/dotfiles`，可设置 `DOTFILES_DIR`：

```bash
DOTFILES_DIR=/path/to/dotfiles ./bootstrap.sh
```

## Brewfile

根目录 [Brewfile](../Brewfile) 列出本仓库依赖，便于复现环境：

- **tap**：`FelixKratz/formulae`（SketchyBar）、`nikitabobko/tap`（AeroSpace）。
- **brew**：git、stow、fzf、starship、eza、bat、zoxide、jq、switchaudio-osx、sketchybar。（tmux 已安装时可跳过）
- **cask**：aerospace、ghostty、karabiner-elements。

可选工具在 Brewfile 中已注释，按需取消注释后执行 `brew bundle`：

- **shellcheck**、**shfmt**：脚本静态检查与格式化，建议在修改 `support/` 下 shell 脚本时使用。
- **mise**、**atuin**、**direnv**：版本/环境管理与 shell 增强，可按需启用。

仅安装依赖、不执行 stow：

```bash
cd "$HOME/dotfiles"
brew bundle
```

检查当前环境是否满足 Brewfile（不安装）：

```bash
brew bundle check
```

## 建议先安装的基础依赖（手动安装时）

### 必需

- Xcode Command Line Tools
- Homebrew
- `git`
- `stow`
- `tmux`
- `zsh`
- `oh-my-zsh`
- `fzf`

### 推荐

- `starship`
- `eza`
- `bat`
- `zoxide`
- `jq`
- `SwitchAudioSource`
- `AeroSpace`
- `SketchyBar`
- `Ghostty`
- `Karabiner-Elements`

## 安装顺序（手动）

若不用 `./bootstrap.sh`，可按以下顺序操作。

### 1. 克隆仓库

```bash
git clone <your-repo-url> "$HOME/dotfiles"
cd "$HOME/dotfiles"
```

### 2. 安装基础工具

若已安装 Homebrew，可执行 `brew bundle` 或最小依赖集：

```bash
brew bundle
# 或
brew install git stow fzf starship eza bat zoxide jq
brew install --cask ghostty karabiner-elements
```

说明：

- `AeroSpace`、`SketchyBar` 通过 Brewfile 的 tap 安装；若需手动安装见各项目文档。
- `oh-my-zsh` 需单独安装，因为 `zsh/.zshrc` 依赖其目录结构。

### 3. 先 dry-run，再 stow

当前推荐只 stow 明确的 package：

```bash
cd "$HOME/dotfiles"

stow -nv aerospace ghostty karabiner tmux nvim sketchybar starship zsh
stow aerospace ghostty karabiner tmux nvim sketchybar starship zsh
```

或者使用仓库脚本：

```bash
cd "$HOME/dotfiles"

bash support/scripts/stow-packages.sh --dry-run
bash support/scripts/stow-packages.sh --apply
```

如果你暂时只想启用 shell：

```bash
cd "$HOME/dotfiles"

stow -nv zsh starship ghostty
stow zsh starship ghostty
```

## 为什么当前不推荐直接 `stow .`

因为仓库顶层除了真正的 package，还保留了：

- `docs`
- `support`

其中 `support` 用来集中放置辅助脚本、主题源文件、状态文件和安装脚本，它不是标准 Stow package。直接执行 `stow .` 仍然可能把仓库根目录整体当成一个 package 处理，生成不符合预期的链接。

为避免误操作，仓库根目录现在添加了 `.stow-local-ignore` 作为保护层。

推荐做法：

- 显式写出 package 名称
- 或使用 `support/scripts/stow-packages.sh`

## 首次主题同步与持久化

主题切换相关入口如下：

- `support/colorscheme/colorscheme-vars.sh`: 当前选中的主题名（用 selector 切换时会写回此文件）
- `support/colorscheme/colorscheme-selector.sh`: 交互式切换入口
- `support/zsh/colorscheme-set.sh`: 应用主题并生成目标配置

首次进入 shell 或切换主题后，`colorscheme-set.sh` 会在「所选主题与 active 不一致」时重新生成：

- `support/colorscheme/active/active-colorscheme.sh`
- `ghostty/.config/ghostty/themes/active`
- `starship/.config/starship/starship.toml`

并 reload SketchyBar，同时把当前选择写回 `colorscheme-vars.sh`，因此**重开 Ghostty 或新开终端会保持同一主题**，不会用旧默认覆盖。

若仓库不在 `~/dotfiles`，可设置 `export DOTFILES_DIR=/path/to/repo`（例如写在 `.zshrc` 的 colorscheme 块之前）。

## 常用维护命令

```bash
cd "$HOME/dotfiles"

stow -nv zsh
stow zsh
stow -R zsh
stow -D zsh
bash support/scripts/stow-packages.sh --dry-run
bash support/scripts/stow-packages.sh --apply
bash support/scripts/stow-packages.sh --delete
```

含义：

- `stow -nv zsh`: 预览将要创建或修改的链接
- `stow zsh`: 建立链接
- `stow -R zsh`: 重建链接
- `stow -D zsh`: 删除该 package 创建的链接
- `support/scripts/stow-packages.sh --dry-run`: 预览受支持 package 的统一安装结果
- `support/scripts/stow-packages.sh --apply`: 统一安装受支持 package
- `support/scripts/stow-packages.sh --delete`: 统一删除受支持 package

## Shell 脚本质量与可选工具

- **shellcheck**：对 `support/` 及 package 内 shell 脚本做静态检查：`shellcheck support/scripts/*.sh support/zsh/*.sh`。
- **shfmt**：格式化脚本：`shfmt -w -i 2 -ci support/scripts/*.sh`（按需调整参数）。
- **mise** / **atuin** / **direnv**：Brewfile 中已注释；若启用，需自行配置与文档对齐。

## 排查建议

- `fzf` 不存在时，`support/colorscheme/colorscheme-selector.sh` 无法工作
- `oh-my-zsh` 不存在时，`zsh/.zshrc` 会在启动时报错
- `SketchyBar` 或 `AeroSpace` 缺失时，对应的桌面联动不会生效
- 如果主题脚本报错，检查仓库路径是否为 `$HOME/dotfiles`，或设置 `DOTFILES_DIR`

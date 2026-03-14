# Setup Guide

## 适用环境

- macOS
- `zsh`
- GNU Stow 管理软链接

## 建议先安装的基础依赖

### 必需

- Xcode Command Line Tools
- Homebrew
- `git`
- `stow`
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

## 安装顺序

### 1. 克隆仓库

```bash
git clone <your-repo-url> "$HOME/dotfiles"
cd "$HOME/dotfiles"
```

### 2. 安装基础工具

如果已安装 Homebrew，可以先安装最小依赖集：

```bash
brew install git stow fzf starship eza bat zoxide jq
brew install --cask ghostty karabiner-elements
```

说明：

- `AeroSpace`、`SketchyBar` 的安装方式可以按你的本机环境补充。
- `oh-my-zsh` 需要单独安装，因为 `zsh/.zshrc` 依赖它的目录结构。

### 3. 先 dry-run，再 stow

当前推荐只 stow 明确的 package：

```bash
cd "$HOME/dotfiles"

stow -nv aerospace ghostty karabiner sketchybar starship zsh
stow aerospace ghostty karabiner sketchybar starship zsh
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

## 首次主题同步

主题切换相关入口如下：

- `support/colorscheme/colorscheme-vars.sh`: 默认主题变量
- `support/colorscheme/colorscheme-selector.sh`: 交互式切换入口
- `support/zsh/colorscheme-set.sh`: 应用主题并生成目标配置

首次进入 shell 时，`zsh/.zshrc` 会调用 `zsh/colorscheme-set.sh`，根据当前主题生成以下内容：

- `support/colorscheme/active/active-colorscheme.sh`
- `ghostty/.config/ghostty/themes/active`
- `starship/.config/starship/starship.toml`

并在需要时 reload `SketchyBar`。

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

## 排查建议

- `fzf` 不存在时，`support/colorscheme/colorscheme-selector.sh` 无法工作
- `oh-my-zsh` 不存在时，`zsh/.zshrc` 会在启动时报错
- `SketchyBar` 或 `AeroSpace` 缺失时，对应的桌面联动不会生效
- 如果主题脚本报错，优先检查仓库路径是否仍为 `$HOME/dotfiles`

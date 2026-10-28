# dotfiles 使用指南

![dotfiles 预览](https://github.com/d3george/github-static/blob/main/dotfiles/screenshot.png)

面向 macOS 的 dotfiles。每个顶层目录都是一个 [GNU Stow](https://www.gnu.org/software/stow/) 包，包内路径与 `$HOME` 一致。

[English](README.md)

## 目录结构

```text
dotfiles/
├── install.sh
├── Brewfile
├── zsh/            ~/.zshrc、~/.zprofile
├── git/            ~/.gitconfig
├── sheldon/        ~/.config/sheldon
├── nvim/           ~/.config/nvim
├── starship/       ~/.config/starship
├── herdr/          ~/.config/herdr
├── opencode/       ~/.config/opencode
├── ghostty/        ~/.config/ghostty
├── aerospace/      ~/.config/aerospace
├── karabiner/      ~/.config/karabiner
├── sketchybar/     ~/.config/sketchybar
├── borders/        ~/.config/borders
├── zed/            ~/.config/zed
├── fastfetch/      ~/.config/fastfetch
├── atuin/          ~/.config/atuin
├── cliamp/         ~/.config/cliamp
└── mactop/         ~/.mactop
```

## 安装

```bash
git clone <repo-url> ~/dotfiles
chmod +x ~/dotfiles/install.sh
/bin/bash ~/dotfiles/install.sh
exec zsh
```

`install.sh` 会在需要时安装 Xcode 命令行工具和 Homebrew，然后执行 `brew bundle`、锁定 Sheldon 插件、stow 全部包，并写入 macOS 默认设置。

只链接配置、不重跑安装：

```bash
cd ~/dotfiles
stow -R -t ~ zsh git sheldon nvim starship herdr opencode \
  ghostty aerospace karabiner sketchybar borders zed \
  fastfetch atuin cliamp mactop
```

## 主题

Ghostty 主题在 `ghostty/.config/ghostty/themes/`，对应 Zed 的四套 Polycarbonate：`polycarbonate-gruvbox-dark`（当前）、`polycarbonate-sha1`、`polycarbonate-ayu-dark`、`polycarbonate-one-dark`。切换时改 `ghostty/.config/ghostty/config` 里的 `config-file`。

Neovim 当前配色是 solarized-osaka。Starship 使用 `solarized_osaka` 调色板。SketchyBar 使用那套配置自带的颜色。窗口边框仍是 Rose Pine。Herdr 使用 Catppuccin。

## 常用命令

Neovim 和 Zed 的 leader 都是 `Space`。`Space p f` 表示先按空格，再按 `p`，再按 `f`。写成 `Ctrl+h` 的才是同时按住。

### 窗口（AeroSpace）

工作区是自动去的：Zed 在 `0`，浏览器在 `1`，笔记在 `2`，聊天在 `3`，Ghostty 在 `9`。

| 动作 | 按键 |
|------|------|
| 焦点 左/下/上/右 | `Alt+h` `j` `k` `l` |
| 移动窗口 | `Alt+Shift+h` `j` `k` `l` |
| 去工作区 1–9、0 | `Alt+1` … `Alt+9`、`Alt+0` |
| 把窗口送去那个工作区 | 上面再加 `Shift` |
| 回到刚才的工作区 | `Alt+Tab` |
| 送到另一块屏幕 | `Alt+Shift+Tab` |
| 平铺 / 手风琴 | `Alt+/`、`Alt+,` |
| 改大小 | `Alt+Shift+r`，然后 `h` `j` `k` `l`，`b` 均分，`Esc` 退出 |

改完配置在终端跑 `aerospace reload-config`。

### Ghostty

前缀是 `Ctrl+Space`，再按下一个键。系统「选择上一个输入法」如果还占着 `Ctrl+Space`，这些都不会进到 Ghostty。当前窗口重载用 `Shift+Cmd+,`。

| 动作 | 按键 |
|------|------|
| 新标签 / 去第 n 个 | 前缀然后 `c`，或 `1`–`9` |
| 左右 / 上下分屏 | 前缀然后 `\`、`-` |
| 分屏 左/下/上/右 | 前缀然后 `h` `j` `k` `l` |
| 分屏等宽 | 前缀然后 `e` |
| 关当前界面 / 新窗口 | 前缀然后 `x`、`n` |
| 快速终端 | 前缀然后 `,` |

### Herdr

前缀是默认的 `Ctrl+b`。

| 动作 | 按键 |
|------|------|
| 设置 / 重载 | 前缀然后 `;`、`r` |
| 跳转 | 前缀然后 `s` |
| 新工作区 / 改名 | 前缀然后 `Shift+w`、`$` |
| 标签改名 | 前缀然后 `,` |
| 竖分屏 / 放大 | 前缀然后 `\|`、`m` |
| 调尺寸 | 前缀然后 `Shift+r` |
| 工作区上一个 / 下一个 | `Ctrl+k`、`Ctrl+j` |

### Neovim 和 Zed

都是普通模式。Neovim 忘了键就按 `Space p k` 搜索。Zed 按 `Space`、`g` 或 `z` 后停半秒，会列出下一键。

| 动作 | Neovim | Zed |
|------|--------|-----|
| 找文件 | `Space p f` | `Space p f` |
| 搜文本 | `Space p s` | `Space p s` |
| 最近文件 | `Space p r` | `Ctrl+o` 然后 `p`，或 `Space f p` |
| 当前目录 | `-` | |
| 文件树 | `Space e e` | `Space e e` 开关右侧栏 |
| 悬浮文档 | `K` | `Shift+k` |
| 函数签名 | 插入模式 `Ctrl+h` | 插入模式 `Ctrl+h` |
| 定义 | `g d` | `g d`；`Space v` 在分屏里打开 |
| 引用 | `g R` | `g r` |
| 重命名 | `Space r n` | `Space r n` |
| 代码动作 | `Space v c a` | `Space v c a` |
| 格式化 | `Space m p` | `Space m p` |
| 诊断 | `Space x w` | `g ]` / `g [` |
| 折叠切换 | `za` | `z a` |
| 折起 / 展开 | `zc` / `zo` | `z c` / `z o` |
| 全折 / 全开 | `zM` / `zR` | `z Shift+m` / `z Shift+r` |
| 半页下/上 | `Ctrl+d` / `Ctrl+u` | |
| 清除搜索高亮 | `Ctrl+c` | |
| 窗格 左/下/上/右 | `Ctrl+w` 然后 `h` `j` `k` `l` | `Ctrl+h` `j` `k` `l` |
| 竖分 / 横分 | `Space s v` / `Space s h` | |
| 分屏等宽 / 关掉 | `Space s e` / `Space s x` | |
| 终端 | | `Ctrl+w` 然后 `f` |
| 行移动 | 可视模式 `J` / `K` | 可视模式 `Shift+j` / `Shift+k` |
| 所有标签 | | `Ctrl+e` 然后 `h` |
| Harpoon | `Space a` 标记，`Ctrl+y` `Ctrl+i` `Ctrl+n` `Ctrl+s` 跳到 1–4 | |
| lazygit / 撤销历史 | `Space l g` / `Space u` | |

Zed 文件树里：`a` 新建文件，`A` 新建目录，`r` 改名，`d` 删除，`q` 关掉。折叠要先把 `settings.json` 里的 `document_folding_ranges` 从 `off` 改成 `always`。

Zed 普通模式里，一个键后面还登记了「再按一键」的组合，右下角才会弹出 which-key。`d`、`c`、`y` 这种是等一个动作对象，不算组合键，所以不会弹。下面这些会一直留着，直到按下一键或 `Esc`。`Space` 的默认「向右一格」已经卸掉，所以它和 `g` 一样会停住。

| 按键 | 后面是什么 |
|------|------------|
| `Space` | 找文件、文件树、格式化、重命名 |
| `g` | 跳转、引用、诊断 |
| `z` | 折叠、把光标滚到上/中/下 |
| `Ctrl+w` | 分屏、焦点 |
| `[` / `]` | 上一段、下一段、诊断、改动块 |
| `Shift+z` | 再按 `Shift+z` 保存并关闭，或 `Shift+q` 不保存关闭 |

下面这些大约一秒就消失，因为这个键自己已经是一个完整动作：

| 按键 | 单独按时在做什么 | 另外绑的后续 |
|------|------------------|--------------|
| `Ctrl+o` | 回到上一个位置 | `Ctrl+o` 然后 `p` 打开最近项目 |
| `Ctrl+e` | 画面下滚一行 | `Ctrl+e` 然后 `h` 打开全部标签 |

### 终端

| 动作 | 命令或按键 |
|------|------------|
| 历史 | `Ctrl+R` |
| 仓库里挑文件、分支、提交 | `Ctrl+G` |
| 进目录 | `z 名字`，或直接 `cd 名字` |
| 回到上次目录 | `cdd` |
| 列表 / 含隐藏 / 三层树 | `ls`、`la`、`tree` |
| 看文件 | `cat`、分页用 `catt` |
| Git 简状态 / 暂存 / 提交 / 推 / 拉 | `gs`、`ga`、`gc "说明"`、`gp`、`gl` |
| 对比 / 已暂存的对比 / 图 | `gd`、`gds`、`glog` |
| 分支界面 | `lg` |
| 清屏 | `c` |

## fastfetch

在终端打印一份系统信息。运行 `fastfetch`。它不会随 shell 自动启动。

## Atuin

替换 `Ctrl+R` 的历史搜索。新开一个 shell 后按 `Ctrl+R`，输入后回车执行选中的命令。`atuin search` 是同一个界面。`atuin import auto` 把现有 shell 历史导入一次。只有要把历史同步到 Atuin 账号时才需要 `atuin login`。

## cliamp

终端播放器，不在 `Brewfile` 里：

```bash
brew install bjarneo/cliamp/cliamp
```

偏好在 `cliamp/.config/cliamp/config.toml`，链接到 `~/.config/cliamp/config.toml`。听本地目录用 `cliamp ~/Music`。按 `q` 退出，按 `?` 看按键。`cliamp setup` 会改这个文件；如果写入了令牌，把值留在 `~/.zshrc.local` 里用 `${VAR}` 引用，不要把令牌提交进仓库。

## fzf-git

在 Git 仓库里按 `Ctrl+G`，选出文件、分支或提交。选中的名字会填进当前命令行。不在仓库里时，命令行会提示 `not a git repository`。新开一个 shell 后生效。

## mactop

Apple Silicon 的资源监控。运行 `mactop`，按 `q` 退出。配色在 `~/.mactop/config.json`。

## SketchyBar

`sketchybar` 会占住当前终端，配置加载后的那行字会一直留着，这是正常的。不要在终端里直接跑它。用登录服务在后台启动：

```bash
ln -sf /opt/homebrew/opt/sketchybar/homebrew.mxcl.sketchybar.plist ~/Library/LaunchAgents/
launchctl bootout gui/$(id -u)/homebrew.mxcl.sketchybar 2>/dev/null || true
killall sketchybar 2>/dev/null || true
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/homebrew.mxcl.sketchybar.plist
```

如果某个终端已经卡在 `sketchybar configuration loaded..`，在那个窗口按 `Ctrl+C` 即可回到提示符。菜单栏由后台服务继续画。

## 本机覆盖

- `~/.zshrc.local`：本机 PATH 和 shell 配置
- `~/.gitconfig.local`：Git 身份和密钥

## 依赖

由仓库根目录的 `Brewfile` 管理。

| 类别     | 工具                                                        |
| -------- | ----------------------------------------------------------- |
| 基础     | git, stow, fzf, fd, ripgrep                                 |
| Shell    | starship, sheldon, eza, bat, zoxide, atuin, fastfetch       |
| 编辑器   | neovim, herdr, zed                                          |
| 桌面     | aerospace, ghostty, karabiner-elements, sketchybar, borders |
| 监控     | mactop                                                      |
| 开发工具 | shellcheck, shfmt                                           |

## 卸载

```bash
cd ~/dotfiles
stow -D -t ~ zsh git sheldon nvim starship herdr opencode \
  ghostty aerospace karabiner sketchybar borders zed \
  fastfetch atuin cliamp mactop
```

## License

MIT

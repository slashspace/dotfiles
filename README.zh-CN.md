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
├── mpd/            ~/.config/mpd
├── rmpc/           ~/.config/rmpc
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
  fastfetch atuin mpd rmpc mactop
```

## 主题

Ghostty 在 `ghostty/.config/ghostty/themes/` 里放三份静态主题：`rosepine`（当前）、`rosepine-custom`、`tokyonight`。切换时改 `ghostty/.config/ghostty/config` 里的 `config-file`。

Neovim 当前配色是 solarized-osaka。Starship 使用 `solarized_osaka` 调色板。SketchyBar 使用那套配置自带的颜色。窗口边框仍是 Rose Pine。Herdr 使用 Catppuccin。

## 编辑器按键

Neovim 和 Zed 共用 Space 作为 leader。Neovim 的键更全，Zed 只镜像它能表达的那些动作。

| 动作 | Neovim | Zed |
|------|--------|-----|
| 找文件 | `Space p f` | `Space p f` |
| 搜文本 | `Space p s` | `Space p s` |
| 最近文件 | `Space p r` | `Ctrl+o p` 或 `Space f p` |
| 悬浮文档 | `K` | `Shift+k` |
| 函数签名 | 插入模式 `Ctrl+h` | 插入模式 `Ctrl+h` |
| 重命名 | `Space r n` | `Space r n` |
| 代码动作 | `Space v c a` | `Space v c a` |
| 格式化 | `Space m p` | `Space m p`，可视模式里也可以按 `=` |
| 跳到定义 | `g d` | `g d`（Zed 默认）；`Space v` 在分屏里打开 |
| 查找引用 | `g R` | `g r` |
| 诊断 | `Space x w` | `g ]` / `g [` |
| 移动行 | 可视模式 `J` / `K` | 可视模式 `Shift+j` / `Shift+k` |
| 窗格左/下/上/右 | `Ctrl+w` 然后 `h j k l` | `Ctrl+h j k l` |
| 垂直 / 水平分屏 | `Space s v` / `Space s h` | Zed 自带分屏；`Ctrl+w f` 打开终端 |
| 文件树 | `Space e e`（mini.files）或 `-`（Oil） | `Space e e` 开关右侧栏 |

只在 Neovim 里：`Space a` 把当前文件放进 Harpoon，然后 `Ctrl+y` `Ctrl+i` `Ctrl+n` `Ctrl+s` 跳到第 1–4 个标记，`Ctrl+e` 打开列表。`Space l g` 打开 lazygit。`Space u` 开关撤销历史。`Space p k` 搜索键位。

Zed 文件树里：`a` 新建文件，`A` 新建目录，`r` 重命名，`d` 删除，`x` 剪切，`c` 复制，`p` 粘贴，`q` 关闭侧栏。

## fastfetch

在终端打印一份系统信息。运行 `fastfetch`。它不会随 shell 自动启动。

## Atuin

替换 `Ctrl+R` 的历史搜索。新开一个 shell 后按 `Ctrl+R`，输入后回车执行选中的命令。`atuin search` 是同一个界面。`atuin import auto` 把现有 shell 历史导入一次。只有要把历史同步到 Atuin 账号时才需要 `atuin login`。

## mpd

音乐播放守护进程。把音频文件放进 `~/.config/mpd/music`，然后：

```bash
mpd ~/.config/mpd/mpd.conf
mpc update
mpc ls
mpc add <文件>
mpc play
mpc status
mpc next
mpc stop
```

`pkill mpd` 停止。再用同一条 `mpd` 命令启动。`rmpc` 是同一个守护进程的全屏界面，先让 mpd 在跑，再执行 `rmpc`。

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

| 类别 | 工具 |
|------|------|
| 基础 | git, stow, fzf, fd, ripgrep |
| Shell | starship, sheldon, eza, bat, zoxide, atuin, fastfetch |
| 编辑器 | neovim, herdr, zed |
| 桌面 | aerospace, ghostty, karabiner-elements, sketchybar, borders |
| 音乐 | mpd, mpc, rmpc |
| 监控 | mactop |
| 开发工具 | shellcheck, shfmt |

## 卸载

```bash
cd ~/dotfiles
stow -D -t ~ zsh git sheldon nvim starship herdr opencode \
  ghostty aerospace karabiner sketchybar borders zed \
  fastfetch atuin mpd rmpc mactop
```

## License

MIT

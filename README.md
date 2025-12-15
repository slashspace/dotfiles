### GNU Stow 使用说明

#### 1. 仓库结构与 Stow 的关系

本仓库使用 GNU Stow 管理各类 dotfiles：顶层每个子目录是一个独立的 *package*，每个 package 内部的目录结构仿照 `$HOME`，Stow 会通过符号链接把它们映射到家目录。

核心相关目录的结构大致如下（节选）：

```text
~/dotfiles
├─ aerospace
│  └─ .config
│     └─ aerospace
│        └─ aerospace.toml
├─ ghostty
│  └─ .config
│     └─ ghostty
│        ├─ config
│        ├─ config-default
│        ├─ shaders
│        └─ themes
├─ karabiner
│  └─ .config
│     └─ karabiner
│        ├─ assets
│        ├─ automatic_backups
│        └─ karabiner.json
├─ sketchybar
│  └─ .config
│     └─ sketchybar
│        ├─ colors.sh
│        ├─ icons.sh
│        ├─ helper
│        ├─ items
│        ├─ plugins
│        └─ sketchybarrc
├─ starship
│  └─ .config
│     └─ starship
│        └─ starship.toml
├─ zsh
│  ├─ .zshrc
│  ├─ zshrc-common.sh
│  ├─ colorscheme-set.sh
│  └─ modules
│     ├─ alias.sh
│     ├─ colors.sh
│     └─ history.sh
├─ colorscheme
│  ├─ active
│  ├─ list
│  └─ colorscheme-vars.sh
├─ scripts
│  ├─ fzf_listoldfiles.sh
│  ├─ fzf-git.sh
│  └─ zoxide_openfiles_nvim.sh
└─ README.md
```

在上面的树中：

- `aerospace`、`ghostty`、`karabiner`、`sketchybar`、`starship`、`zsh` 等目录都是 Stow 的 package。
- 每个 package 内的 `.config/...`、`.zshrc` 等路径，都会通过 Stow 链接到家目录下对应的位置（例如 `~/.config/...`、`~/.zshrc`）。
- 顶层的 `README.md` 等普通文件不会被 Stow 当作 package 处理。

Stow 的基本理念是：

- **stow 目录（`-d`）**：存放各个 package 的根目录（这里是仓库根目录，例如 `~/dotfiles`）。
- **target 目录（`-t`）**：要把配置链接到的目标目录（这里通常是 `$HOME`，即 `~`）。
- **每个子目录是一个 package**：例如 `aerospace`、`ghostty`、`zsh` 等。

当你在 `~/dotfiles` 下执行：

```bash
stow aerospace
```

等价于：

```bash
stow -d . -t .. aerospace
```

会在 `~`（父目录）下建立对应的符号链接：

- `~/.config/aerospace` → `~/dotfiles/aerospace/.config/aerospace`
- `~/.config/aerospace/aerospace.toml` 最终指向 `~/dotfiles/aerospace/.config/aerospace/aerospace.toml`

同理：

```bash
stow zsh
```

会在 `~` 下创建：

- `~/.zshrc` → `~/dotfiles/zsh/.zshrc`
- 以及 `zsh` 目录下对应的其他文件/目录链接。

#### 2. 核心命令与常用流程

在本仓库中使用 Stow 的典型流程：

```bash
# 1. 进入 dotfiles 仓库
cd ~/dotfiles

# 2. 先用 dry-run 预览（推荐）
stow -nv aerospace

# 3. 确认无误后真正执行
stow aerospace

# 4. 其他 package 同理
stow ghostty
stow karabiner
stow sketchybar
stow starship
stow zsh
```

常用参数：

- **`stow <package>`**：在当前目录（stow 目录）下，将 `<package>` 这个子目录里的内容，以符号链接形式安装到其父目录（默认 target 为 `..`）。
- **`-d <dir>`**：指定 stow 目录（默认为当前目录）。
- **`-t <dir>`**：指定 target 目录（默认为 stow 目录的父目录）。
- **`-n` / `--no`**：dry-run，只显示将要做什么，不实际改动。
- **`-v`**：verbose，显示详细输出。
- **`-D <package>`**：unfold / delete，删除该 package 创建的符号链接。
- **`-R <package>`**：restow，先删除再重新 stow，用于更新/重建链接。

示例：把 `zsh` 配置链接到 `$HOME`：

```bash
cd ~/dotfiles
stow -nv zsh   # 预览
stow zsh       # 真正执行
```

#### 3. `stow .` 的隐藏行为（重点）

在类似本仓库这种结构下，经常可以看到：

```bash
cd ~/dotfiles
stow .
```

很容易直觉地理解成「把当前目录整个当成一个 package stow 到 `$HOME`」，
但实际上 **GNU Stow 对 `.` 有特殊行为**：

- `stow .` 的含义是：**把当前 stow 目录下所有非忽略的子目录，当作独立的 package，一次性全部 stow 到 target**。
- 默认情况下：
  - stow 目录（`-d`）是当前目录 `.`（这里是 `~/dotfiles`）。
  - target 目录（`-t`）是 `..`，也就是 `~/`。

用树形目录来理解就是：

```text
stow 目录: ~/dotfiles

~/dotfiles
├─ aerospace      # 被当作 package
├─ ghostty        # 被当作 package
├─ karabiner      # 被当作 package
├─ sketchybar     # 被当作 package
├─ starship       # 被当作 package
├─ zsh            # 被当作 package
├─ colorscheme    # 也会被当作一个 package（如果未被忽略）
├─ scripts        # 同上
└─ README.md      # 普通文件，不是 package
```

在本仓库里执行：

```bash
cd ~/dotfiles
stow .
```

实际等价于：

```bash
stow aerospace colorscheme ghostty karabiner scripts sketchybar starship zsh
```

几个关键点：

- **只 stow 子目录，不会处理根目录普通文件**：
  顶层的 `README.md` 这种普通文件不会被链接到 `~/README.md`，因为 Stow 只把子目录当作 package。
- **`stow .` 不是「把整个 dotfiles 仓库当成一个 package」**：
  而是「把当前目录下所有 *子目录* 一次性 stow」。
- **Stow 有默认忽略规则**：
  比如 `.git`、`RCS`、`CVS` 等目录不会被当成 package，如果存在 `.stow-local-ignore` 还会应用其中的忽略规则。

#### 4. 在本仓库中安全使用 `stow .` 的方式

如果希望“一键安装”本仓库下的所有配置，可以这样做：

```bash
cd ~/dotfiles

# 先 dry-run 看看会创建/修改哪些链接（强烈推荐）
stow -nv .

# 确认输出都符合预期后再真正执行
stow .
```

`stow -nv .` 会输出类似：

```text
LINK: .config/aerospace -> ../dotfiles/aerospace/.config/aerospace
LINK: .config/ghostty -> ../dotfiles/ghostty/.config/ghostty
LINK: .config/karabiner -> ../dotfiles/karabiner/.config/karabiner
LINK: .config/sketchybar -> ../dotfiles/sketchybar/.config/sketchybar
LINK: .config/starship -> ../dotfiles/starship/.config/starship
LINK: .zshrc -> dotfiles/zsh/.zshrc
...
```

确认路径都指向期望的位置后，再执行不带 `-n` 的命令：

```bash
stow .
```

#### 5. 卸载与更新单个 package

- **卸载单个 package**（删除对应的 symlink，不会删掉仓库里的文件）：

  ```bash
  cd ~/dotfiles
  stow -D zsh
  ```

  这会删除 `~/.zshrc` 等由 `zsh` package 创建的符号链接。

- **更新/重建单个 package 的链接**（例如调整了目录结构）：

  ```bash
  cd ~/dotfiles
  stow -R zsh
  ```

#### 6. 常见坑与注意事项

- **在正确的目录执行 `stow .`**：
  只有在 `~/dotfiles` 下执行 `stow .`，target 才是 `~`。如果在 `~` 目录执行 `stow .`，Stow 会把 `~` 当作 stow 目录、把其父目录 `/Users` 当作 target，可能尝试把整个 home 目录下的子目录 stow 到 `/Users`，风险很大。

- **养成先 dry-run 的习惯**：

  ```bash
  cd ~/dotfiles
  stow -nv .       # 或者 stow -nv zsh
  ```

  确认输出中每一条 `LINK:` 的源路径和目标路径都符合预期，再执行真正的：

  ```bash
  stow .
  # 或
  stow zsh
  ```

- **避免一个目标文件被多个 package 管理**：
  如果两个 package 中都有同一个相对路径（比如 `zsh/.zshrc` 和 `scripts/.zshrc`），`stow .` 会产生冲突。建议一个目标路径只由一个 package 负责，或者在 `.stow-local-ignore` 里排除不需要 stow 的目录/文件。

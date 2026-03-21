# vscode-neovim-shortcuts.md：Keybindings（快捷键）中文翻译

来源：vscode-neovim 官方 README 的 **⌨️ Keybindings (shortcuts)** 部分  
链接：[https://github.com/vscode-neovim/vscode-neovim/blob/master/README.md#%EF%B8%8F-keybindings-shortcuts](https://github.com/vscode-neovim/vscode-neovim/blob/master/README.md#%EF%B8%8F-keybindings-shortcuts)

---

## 主要内容概述

### 快捷键分三类

| 类型 | 由谁提供 | 作用概述 |
|---|---|---|
| Neovim keybindings | 扩展/你的 `init.vim` | 负责 Neovim 自身行为（跳转、缓冲区管理、文本对象等） |
| VSCode keybindings | 扩展的 `package.json` 或你的 VS Code 配置 | 负责调用 VSCode 能力，让 VSCode 更“像 Vim” |
| VSCode passthrough keybindings | 扩展的 `package.json` 或你的 VS Code 配置 | 把按键“透传”给嵌入式 Neovim（避免 VS Code 抢走按键） |

### 文档强调的规则

1. **特殊键（控制键/修饰键/非字母数字）默认不保证全都透传**。需要在 VS Code 键位配置里明确提供（或通过扩展的默认规则提供）。
2. 文档建议用 VS Code 的 `Preferences: Open Keyboard Shortcuts` 搜索 `neovim`，查看你当前环境最终生效的完整列表。
3. 在 Neovim 内可用 `:help` 查看按键/命令的帮助（文档示例：`:help :split`、`:help zo`；以及 `<C-...>` 相关用 `CTRL-...` 表达）。

---

## Keybinding Passthroughs（透传规则）要点

### Insert 模式控制键透传

| 项 | 默认值 |
|---|---|
| `vscode-neovim.ctrlKeysForInsertMode` | `["a", "d", "h", "j", "m", "o", "r", "t", "u", "w"]` |

### Normal 模式控制键透传

| 项 | 默认值 |
|---|---|
| `vscode-neovim.ctrlKeysForNormalMode` | `["a", "b", "d", "e", "f", "h", "i", "j", "k", "l", "m", "o", "r", "t", "u", "v", "w", "x", "y", "z", "/", "]"]` |

### Cmdline 模式特殊键透传（始终启用）

| 组 | 说明 |
|---|---|
| Tab、Up、Down | 始终透传 |
| Ctrl 键 | `<C-h> <C-w> <C-u> <C-n> <C-p> <C-l> <C-g> <C-t>` |
| 所有 `<C-r>` 前缀键 | 始终透传 |

### 进一步可配置项

| 项 | 目的 |
|---|---|
| `editorLangIdExclusions` | 对特定 filetype 禁用扩展定义的部分 keybindings |
| 通过 `keybindings.json` 移除冲突 | 若默认设置不够，可手动移除/覆盖 VSCode 或 passthrough 的按键 |

---

## 内置快捷键完整翻译（按 README 表格）

> 下表的“命令”是 VS Code command id（保留英文标识，便于你在 VS Code 里搜索）。

### Code navigation bindings（代码导航）

| 按键 | VSCode command（命令） | 中文含义 |
|---|---|---|
| `=` / `==` | `editor.action.formatSelection` | 格式化选区 |
| `gh` / `K` | `editor.action.showHover` | 显示悬浮提示（Hover） |
| `gd` / `<C-]>` | `editor.action.revealDefinition` | 跳转到定义（Definition） |
| `gf` | `editor.action.revealDeclaration` | 跳转到声明（Declaration） |
| `gH` | `editor.action.referenceSearch.trigger` | 触发引用搜索（References） |
| `gO` | `workbench.action.gotoSymbol` | 按符号导航（Go to Symbol） |
| `<C-w>gd` / `<C-w>gf` | `editor.action.revealDefinitionAside` | 在旁边打开定义（Aside） |
| `gD` | `editor.action.peekDefinition` | 预览定义（Peek Definition） |
| `gF` | `editor.action.peekDeclaration` | 预览声明（Peek Declaration） |
| `Tab` | `togglePeekWidgetFocus` | 在 peek 编辑器与参考列表间切换焦点 |
| `<C-n>` / `<C-p>` | （文档描述同一条） | 在列表/参数提示/建议/快速打开/命令行历史/peek 引用列表间导航 |

### Explorer/list navigation bindings（资源管理器/列表导航）

| 按键 | VSCode command（命令） | 中文含义 |
|---|---|---|
| `j` 或 `k` | `list.focusDown/Up` | 向下/向上聚焦列表项 |
| `h` 或 `l` | `list.collapse/select` | 折叠 / 选择（select） |
| `Enter` | `list.select` | 选择当前项 |
| `gg` | `list.focusFirst` | 聚焦第一个项 |
| `G` | `list.focusLast` | 聚焦最后一个项 |
| `o` | `list.toggleExpand` | 展开/收起 |
| `<C-u>` 或 `<C-d>` | `list.focusPageUp/Down` | 上一页/下一页聚焦 |
| `zo` 或 `zO` | `list.expand` | 展开 |
| `zc` | `list.collapse` | 收起 |
| `zC` | `list.collapseAllToFocus` | 收起到当前聚焦层级 |
| `za` 或 `zA` | `list.toggleExpand` | 切换展开 |
| `zm` 或 `zM` | `list.collapseAll` | 全部收起 |
| ` / ` 或 `Escape` | `list.toggleKeyboardNavigation` | 切换键盘导航模式 |

### Explorer file manipulation bindings（资源管理器文件操作）

| 按键 | VSCode command（命令） | 中文含义 |
|---|---|---|
| `r` | `renameFile` | 重命名 |
| `d` | `deleteFile` | 删除 |
| `y` | `filesExplorer.copy` | 复制 |
| `x` | `filesExplorer.cut` | 剪切 |
| `p` | `filesExplorer.paste` | 粘贴 |
| `v` | `explorer.openToSide` | 侧边打开 |
| `a` | `explorer.newFile` | 新建文件 |
| `A` | `explorer.newFolder` | 新建文件夹 |
| `R` | `workbench.files.action.refreshFilesExplorer` | 刷新文件资源管理器 |

### Hover widget manipulation bindings（悬浮窗操作）

| 按键 | VSCode command（命令） | 中文含义 |
|---|---|---|
| `K` | `editor.action.showHover` | 显示悬浮内容 |
| `h` | `editor.action.scrollLeftHover` | 悬浮内容向左滚动 |
| `j` | `editor.action.scrollDownHover` | 悬浮内容向下滚动 |
| `k` | `editor.action.scrollUpHover` | 悬浮内容向上滚动 |
| `l` | `editor.action.scrollRightHover` | 悬浮内容向右滚动 |
| `gg` | `editor.action.goToTopHover` | 跳到悬浮顶部 |
| `G` | `editor.action.goToBottomHover` | 跳到悬浮底部 |
| `<C-f>` | `editor.action.pageDownHover` | 悬浮下一页 |
| `<C-b>` | `editor.action.pageUpHover` | 悬浮上一页 |


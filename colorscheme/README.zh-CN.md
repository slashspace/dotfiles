# 颜色方案管理系统（Colorscheme System）

这是整个项目的核心，实现了所有应用的颜色统一管理。

## 工作流程
```
用户选择颜色方案
    ↓
colorscheme-selector.sh (使用 fzf 交互式选择)
    ↓
colorscheme-set.sh (应用颜色方案)
    ↓
┌─────────────────────────────────────┐
│ 1. 复制到 active-colorscheme.sh    │
│ 2. 生成各应用的配置文件：           │
│    - kitty/active-theme.conf        │
│    - ghostty/ghostty-theme          │
│    - btop/themes/btop-theme.theme   │
│    - starship-config/active-config.toml │
│ 3. 设置 tmux 颜色                   │
│ 4. 重新加载 sketchybar              │
│ 5. 设置壁纸                         │
│ 6. 重启 yabai                       │
└─────────────────────────────────────┘
```

## 文件结构
- `colorscheme/list/` - 所有可用的颜色方案文件（如 `batman.sh`, `catppuccin-mocha.sh` 等）
- `colorscheme/active/active-colorscheme.sh` - 当前激活的颜色方案
- `colorscheme/colorscheme-vars.sh` - 颜色方案变量定义（指定默认方案）
- `colorscheme/colorscheme-selector.sh` - 交互式颜色方案选择器
- `zsh/colorscheme-set.sh` - 颜色方案应用脚本

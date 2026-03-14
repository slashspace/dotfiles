# SketchyBar 模块分类

模块按维护状态分为两类，由主配置通过 `load_items.sh` 统一加载。

## Active（当前启用）

- `apple.sh` — 系统菜单（偏好、活动、锁屏）
- `spaces.sh` — AeroSpace 工作区条（0–9、当前工作区应用）
- `spotify.sh` — Spotify 状态
- `calendar.sh` — 日期时间
- `brew.sh` — Homebrew 更新
- `dnd.sh` — 勿扰模式
- `github.sh` — GitHub 通知
- `wifi.sh` — Wi‑Fi 状态
- `battery.sh` — 电池
- `volume.sh` — 音量（右击切换输出）
- `memory.sh` — 内存
- `cpu.sh` — CPU（含 top 进程）

## Experimental（可选，默认不加载）

需要时在 `load_items.sh` 中取消对应 `source` 注释即可启用。

- `front_app.sh` — 当前前台应用名（与 spaces 条中的当前工作区应用有重叠）
- `mic.sh` — 麦克风名称与输入音量
- `media.sh` — 媒体键/播放状态
- `timer.sh` — 计时器

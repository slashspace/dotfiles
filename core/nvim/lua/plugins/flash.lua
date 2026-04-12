-- Plugins: flash.nvim
-- https://github.com/folke/flash.nvim
--
-- ## 作用（总体）
-- 在窗口「可见区域」里快速把光标移到目标：先输入要匹配的字符（可联想为智能版 f/t），匹配处会出现
-- 标签；再按标签键即可跳过去。比单次 f/F 更适合跨较远位置、多匹配筛选。另提供按 Treesitter
-- 节点跳转、与 operator（d/y/c 等）结合的「远端选区」等模式。
--
-- ## 场景与用法（对应本文件 keys）
--
-- 1) s → require("flash").jump()   （Normal / Visual / Operator-pending）
--    - Normal：按 s，输入若干字符缩小匹配范围，界面会给候选打标签，按标签跳转。
--    - Visual：先选中一块再 s，在可见范围内用 Flash 把选区改到新的目标位置（行为随版本以实际为准）。
--    - Operator-pending：如 d s …、y s …，用 Flash 在屏幕上标出要删/要复制的范围，相当于把 Flash 当 motion。
--    注意：默认 Vim 的 s 是「删一字并插入」；本配置用 Flash 占用了 s/S，与 mini.surround 的 sa/sd… 不冲突。
--
-- 2) S → treesitter()   （n / x / o）
--    按语法树在节点间跳（函数、参数、字符串等），适合按「代码结构」移动而非纯字符。
--
-- 3) r → remote()   （仅 Operator-pending）
--    先按操作符（如 d、y、c），再 r，用 Flash 在别处选中范围，把操作应用到那块区域（远端操作）。
--
-- 4) R → treesitter_search()   （Operator-pending / Visual）
--    在 Treesitter 语义下搜索/选择结构，与纯字符 Flash 互补；嵌套较深时便于选对节点范围。
--
-- 5) <C-s> → toggle()   （命令行模式 c）
--    在 / 或 : 等命令行输入时，开关 Flash 对搜索的增强（具体表现依 opts 而定）。
--
-- 更多：:h flash.nvim 或仓库 README。

return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
}

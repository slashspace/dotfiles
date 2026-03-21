-- 基础编辑器选项

-- 设置 leader 键
vim.g.mapleader = " "

local opt = vim.opt
-- 设置 timeout 和 timeoutlen，用于设置等待按键组合的时间
opt.timeout = true
opt.timeoutlen = 500

-- 界面
opt.number = true
opt.cursorline = true
opt.laststatus = 2
opt.showcmd = true
opt.ruler = true
opt.wrap = false

-- 缩进
opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4

-- 搜索时高亮显示
opt.hlsearch = true
opt.incsearch = true
-- 括号/匹配符短暂跳转匹配（有助于成对符号检查）
opt.showmatch = true
-- 搜索时忽略大小写
opt.ignorecase = true
-- 若搜索模式里含大写字母，则不再忽略大小写
opt.smartcase = true


-- 选择
opt.selection = "exclusive"
opt.selectmode = { "mouse", "key" }


-- 与系统剪贴板互通
opt.clipboard = { "unnamedplus" }

-- 关闭 swap/backup，减少干扰
opt.swapfile = false
opt.backup = false

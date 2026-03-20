-- Basic editor options (terminal defaults).
-- vscode-neovim will still set vim.g.vscode; we keep options lightweight to avoid visual/perf issues.

local opt = vim.opt

-- UI
opt.number = true
opt.cursorline = true
opt.laststatus = 2
opt.showcmd = true
opt.ruler = true
opt.cmdheight = 3
opt.mouse = "a"

-- Editing behavior
opt.autoread = true
opt.autoindent = true
opt.smartindent = true
opt.ignorecase = true
opt.hlsearch = true
opt.incsearch = true
opt.wrap = false

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4

-- Search / selection
opt.selection = "exclusive"
opt.selectmode = { "mouse", "key" }
opt.showmatch = true

-- Clipboard: macOS + terminal
-- Prefer unnamedplus so it works with system clipboard providers.
opt.clipboard = { "unnamedplus" }

-- Disable swap/backup noise
opt.swapfile = false
opt.backup = false

-- Colorscheme
pcall(vim.cmd.colorscheme, "desert")

-- iTerm2 cursor shape (optional; no effect in other terminals)
if vim.env.TERM_PROGRAM and vim.env.TERM_PROGRAM:match("iTerm") then
  -- Use the same escape sequences as the legacy vimrc.
  -- ESC ] 50 ; CursorShape = 1 BEL  / 0 for normal mode
  vim.o.t_SI = "\x1b]50;CursorShape=1\x07" -- insert mode
  vim.o.t_EI = "\x1b]50;CursorShape=0\x07" -- normal mode
end

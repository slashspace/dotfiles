-- Keymaps for terminal Neovim only.

local map = vim.keymap.set

-- VSCode Neovim extension sets vim.g.vscode=true.
local is_vscode = vim.g.vscode == true

-- Escape helper: jj -> <Esc>
-- Only enable in terminal to avoid double-binding in vscode-neovim.
if not is_vscode then
  vim.o.timeout = true
  vim.o.timeoutlen = 300
  map("i", "jj", "<Esc>", { silent = true, noremap = true })
end

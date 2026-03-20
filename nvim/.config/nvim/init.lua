-- Neovim entrypoint (terminal + vscode-neovim).
-- We keep modules small and load them in order.

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.plugins")

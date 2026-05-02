-- Neovim entrypoint (terminal + vscode-neovim).
-- We keep modules small and load them in order.

-- 目的：代理开着时自动走代理，方便在国内或受限网络下装插件、下 LSP 等
-- 前提：你本机代理确实监听在 7890；若端口不同，要改成你的端口。
pcall(function()
  if vim.fn.sockconnect('tcp', '127.0.0.1:7890') ~= 0 then
    vim.env.http_proxy = 'http://127.0.0.1:7890' -- set http_proxy=http://127.0.0.1:7890
    vim.env.https_proxy = 'http://127.0.0.1:7890' -- set https_proxy=http://127.0.0.1:7890
  end
end)

-- Load generated theme globals (set by `dotfiles theme apply`)
do
  local dotfiles = vim.env.DOTFILES_DIR or (vim.env.HOME .. "/dotfiles")
  local theme_file = dotfiles .. "/system/themes/generated/nvim-theme.lua"
  local f = loadfile(theme_file)
  if f then f() end
end

require("config.options")
require("config.keymaps")
require("config.lazy")
require("config.vscode_keymaps")

-- Apply colorscheme from theme engine (after plugins are loaded)
if vim.g.theme_colorscheme then
  vim.cmd.colorscheme(vim.g.theme_colorscheme)
end

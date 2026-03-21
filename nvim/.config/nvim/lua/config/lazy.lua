-- 插件入口：只负责安装并启动 lazy.nvim；具体插件在 lua/plugins/ 下拆分维护。

-- lazy.nvim 安装路径
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 如果 lazy.nvim 不存在，则克隆仓库
if vim.fn.isdirectory(lazypath) == 0 then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- 启动 lazy.nvim
require("lazy").setup({
  spec = {
    -- 插件列表
    { import = "plugins" },
  },
})

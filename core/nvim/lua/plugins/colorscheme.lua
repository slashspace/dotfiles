-- Colorschemes used by the dotfiles theme system.
-- Each palette in system/themes/palettes/*.sh sets THEME_NVIM_COLORSCHEME +
-- THEME_NVIM_STYLE; nvim renderer writes those into generated/nvim-theme.lua
-- which init.lua sources before applying `vim.cmd.colorscheme`.
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = function()
      return { flavour = vim.g.theme_style or "mocha" }
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    lazy = false,
    priority = 1000,
    opts = function()
      return { contrast = vim.g.theme_style or "dark" }
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    lazy = false,
    priority = 1000,
    opts = function()
      return { theme = vim.g.theme_style or "wave" }
    end,
  },
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    lazy = false,
    priority = 1000,
    opts = function()
      return { style = vim.g.theme_style or "moon" }
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = function()
      return { variant = vim.g.theme_style or "moon" }
    end,
  },
  {
    "joegoggin/matrix.nvim",
    name = "matrix",
    lazy = false,
    priority = 1000,
  },
}

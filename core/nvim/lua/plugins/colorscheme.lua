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
      return {
        theme = vim.g.theme_style or "dragon",
      }
    end,
  },
  {
    "lifepillar/vim-solarized8",
    name = "solarized8",
    lazy = false,
    priority = 1000,
  },
  {
    "Mofiqul/dracula.nvim",
    name = "dracula",
    lazy = false,
    priority = 1000,
  },
  {
    "shaunsingh/nord.nvim",
    name = "nord",
    lazy = false,
    priority = 1000,
  },
  {
    "neanias/everforest-nvim",
    name = "everforest",
    lazy = false,
    priority = 1000,
    opts = function()
      return {
        background = vim.g.theme_style or "hard",
      }
    end,
  },
  {
    "loctvl842/monokai-pro.nvim",
    name = "monokai-pro",
    lazy = false,
    priority = 1000,
    opts = function()
      return {
        filter = vim.g.theme_style or "classic",
      }
    end,
  },
  {
    "navarasu/onedark.nvim",
    name = "onedark",
    lazy = false,
    priority = 1000,
    opts = function()
      return {
        style = vim.g.theme_style or "dark",
      }
    end,
  },
  {
    "joegoggin/matrix.nvim",
    name = "matrix",
    lazy = false,
    priority = 1000,
  },
}

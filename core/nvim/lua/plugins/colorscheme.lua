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
    "dracula/vim",
    name = "dracula",
    lazy = false,
    priority = 1000,
  },
  {
    "neanias/everforest-nvim",
    name = "everforest",
    lazy = false,
    priority = 1000,
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
    "shaunsingh/nord.nvim",
    name = "nord",
    lazy = false,
    priority = 1000,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = function()
      return { variant = vim.g.theme_style or "main" }
    end,
  },
  {
    "maxmx03/solarized.nvim",
    name = "solarized",
    lazy = false,
    priority = 1000,
  },
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    lazy = false,
    priority = 1000,
    opts = function()
      return { style = vim.g.theme_style or "night" }
    end,
  },
}

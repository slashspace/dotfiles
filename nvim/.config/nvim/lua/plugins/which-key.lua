-- Plugins: which-key.nvim
-- https://github.com/folke/which-key.nvim

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "显示快捷键",
      },
    },
  },
}

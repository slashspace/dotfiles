-- nvim-notify：需显式 background_colour，否则无法从 NotifyBackground 推断透明度基准色
-- https://github.com/rcarriga/nvim-notify
return {
  "rcarriga/nvim-notify",
  lazy = false,
  priority = 1000,
  config = function()
    require("notify").setup({
      -- 与常见深色主题一致；若改主题可改为与 Normal/guibg 相同
      background_colour = "#000000",
    })
  end,
}

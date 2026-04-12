
-- { 模式, lhs, rhs [, 额外 opts 表，如 { desc = "..." } ] }
local keymaps = {
  { "o", "L", "g_", { desc = "操作模式移动到行尾" } },
  { "o", "H", "^", { desc = "操作模式：移动到行首" } },
  { "x", "H", "^", { desc = "可视模式：选区到行首（首非空）" } },
  { "x", "L", "g_", { desc = "可视模式：选区到行尾（末非空）" } },

  { "n", "J", "5j", { desc = "普通模式：向下移动 5 行" } },
  { "n", "K", "5k", { desc = "普通模式：向上移动 5 行" } },

  { "n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "普通模式：退出时清除搜索高亮" } },
  { "n", "<leader>s", "<cmd>w<cr>", { desc = "普通模式：保存文件" } },
}

for _, m in ipairs(keymaps) do
  vim.keymap.set(
    m[1],
    m[2],
    m[3],
    vim.tbl_extend("force", { noremap = true, silent = true }, m[4] or {})
  )
end

-- 终端 Neovim（非 vscode）下生效：jj -> <Esc>
if not vim.g.vscode then
  vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true, desc = "插入模式：退出插入模式" })
end

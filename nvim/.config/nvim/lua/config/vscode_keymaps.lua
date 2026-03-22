-- 只适用于 vscode-neovim 扩展
if not vim.g.vscode then
  return
end

local ok, vscode = pcall(require, "vscode")
if not ok or not vscode or not vscode.action then
  return
end


-- { mode, key, vscode command, description }
local vscode_mappings = {
  { "n", "u", "undo", { desc = "VS Code 撤销" } },

  -- 按「词段」移动光标
  { 'n', 'w', 'cursorWordPartRight', { desc = "按词段向右移动光标" } },
  { 'n', 'b', 'cursorWordPartLeft', { desc = "按词段向左移动光标" } },
  { 'v', 'w', 'cursorWordPartRightSelect', { desc = "按词段向右选择" } },
  { 'v', 'b', 'cursorWordPartLeftSelect', { desc = "按词段向左选择" } },

  -- 代码跳转
  { 'n', '<leader>gh', 'editor.action.showHover', { desc = "显示悬浮提示" } },
  { 'n', '<leader>gd', 'editor.action.revealDefinition', { desc = "跳转到定义" } },
  { 'n', '<leader>gi', 'editor.action.goToImplementation', { desc = "跳转到实现" } },
  { 'n', '<leader>gr', 'editor.action.goToReferences', { desc = "跳转到引用" } },
  { 'n', '<leader>gs', 'workbench.action.gotoSymbol', { desc = "跳转到符号" } },
  { 'n', '<leader>gS', 'workbench.action.showAllSymbols', { desc = "显示所有符号" } },
  { 'n', '<leader>gl', 'workbench.action.gotoLine', { desc = "跳转到行" } },
  { 'n', '<leader>go', 'workbench.action.showAllEditors', { desc = "显示所有打开的文件" } },
  { 'n', '<leader>nj', 'workbench.action.navigateBack', { desc = "向后导航" } },
  { 'n', '<leader>nk', 'workbench.action.navigateForward', { desc = "向前导航" } },

  -- 查找、替换与重构
  { 'n', '<leader>ff', 'actions.find', { desc = "查找" } },
  { 'n', '<leader>fR', 'editor.action.startFindReplaceAction', { desc = "开始查找替换" } },
  { 'n', '<leader>fg', 'workbench.action.findInFiles', { desc = "在文件中查找, global: 全局" } },
  { 'n', '<leader>rg', 'workbench.action.replaceInFiles', { desc = "在文件中替换, global: 全局" } },
  { 'n', '<leader>rn', 'editor.action.rename', { desc = "重命名" } },
  { 'n', '<leader>rf', 'editor.action.refactor', { desc = "重构" } },
  { 'n', '<leader>qf', 'editor.action.quickFix', { desc = "快速修复" } },
  { 'n', '<leader>sg', 'editor.action.triggerSuggest', { desc = "触发建议" } },

  -- 文件与工作区
  { 'n', '<leader>cp', 'copyFilePath', { desc = "复制文件路径" } },
  { 'n', '<leader>cr', 'copyRelativeFilePath', { desc = "复制相对文件路径" } },
  { 'n', '<leader>rl', 'workbench.action.openRecent', { desc = "打开最近文件" } },
  { 'n', '<leader>cf', 'workbench.action.closeActiveEditor', { desc = "关闭活动编辑器" } },
  { 'n', '<leader>fa', 'workbench.action.closeAllEditors', { desc = "关闭所有编辑器" } },
  { 'n', '<leader>rw', 'workbench.action.reloadWindow', { desc = "重新加载窗口" } },

  -- 编辑器标签页（当前组内）
  { 'n', '<leader>tj', 'workbench.action.nextEditor', { desc = "下一个标签页" } },
  { 'n', '<leader>tk', 'workbench.action.previousEditor', { desc = "上一个标签页" } },

  -- 窗口布局
  { 'n', '<leader>w\\', 'workbench.action.splitEditor', { desc = "水平分割编辑器" } },
  { 'n', '<leader>w-', 'workbench.action.splitEditorDown', { desc = "垂直分割编辑器" } },
  { 'n', '<leader>wa', 'workbench.action.evenEditorWidths', { desc = "均匀分配编辑器宽度" } },
  { "n", "<leader>wh", "workbench.action.focusLeftGroup", { desc = "聚焦左侧编辑器" } },
  { "n", "<leader>wj", "workbench.action.focusBelowGroup", { desc = "聚焦下方编辑器" } },
  { "n", "<leader>wk", "workbench.action.focusAboveGroup", { desc = "聚焦上方编辑器" } },
  { "n", "<leader>wl", "workbench.action.focusRightGroup", { desc = "聚焦右侧编辑器" } },

}


for _, m in ipairs(vscode_mappings) do
  local mode, key, command, desc = m[1], m[2], m[3], m[4]
  local desc_str = desc and (type(desc) == "table" and desc.desc or desc) or nil
  vim.keymap.set(mode, key, function()
    vscode.action(command)
  end, { noremap = true, silent = true, desc = desc_str })
end

-- Proxy for plugin and LSP installs when a local proxy is listening.
pcall(function()
    if vim.fn.sockconnect("tcp", "127.0.0.1:7890") ~= 0 then
        vim.env.http_proxy = "http://127.0.0.1:7890"
        vim.env.https_proxy = "http://127.0.0.1:7890"
    end
end)

-- Nightly UI. Stable Neovim simply skips this.
pcall(function()
    require("vim._core.ui2").enable({
        enable = true,
        msg = {
            target = "cmd",
            pager = { height = 1 },
            msg = { height = 0.5, timeout = 4500 },
            dialog = { height = 0.5 },
            cmd = { height = 0.5 },
        },
    })
end)

require("sethy.core")
require("sethy.lazy")

if vim.g.vscode then
    require("config.vscode_keymaps")
else
    require("current-theme")
end

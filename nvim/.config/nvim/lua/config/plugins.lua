-- Plugin bootstrap + terminal LSP/completion/format stack.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local function bootstrap_lazy()
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
  vim.opt.rtp:prepend(lazypath)
end

bootstrap_lazy()

local is_vscode = vim.g.vscode == true

local function lsp_on_attach(client, bufnr)
  -- Minimal keymaps for code navigation/actions.
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local buf_map = function(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  buf_map("n", "gd", vim.lsp.buf.definition)
  buf_map("n", "gr", vim.lsp.buf.references)
  buf_map("n", "K", vim.lsp.buf.hover)
  buf_map("n", "<leader>rn", vim.lsp.buf.rename)
  buf_map("n", "<leader>ca", vim.lsp.buf.code_action)
  buf_map("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end)
end

require("lazy").setup({
  -- Only enable LSP/cmp/format plugins in terminal.
  {
    "neovim/nvim-lspconfig",
    enabled = not is_vscode,
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Integrate nvim-cmp capabilities if it is available.
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp and cmp_lsp and cmp_lsp.default_capabilities then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      -- Ensure a good baseline across common languages.
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
        pyright = {},
        tsserver = {},
        gopls = {},
        rust_analyzer = {},
      }

      for name, cfg in pairs(servers) do
        cfg = cfg or {}
        cfg.capabilities = cfg.capabilities or capabilities
        cfg.on_attach = cfg.on_attach or lsp_on_attach

        -- Neovim 0.11+ best practice: configure via vim.lsp.config/enable.
        -- This avoids nvim-lspconfig's deprecated "framework" require() path.
        vim.lsp.config(name, cfg)
        vim.lsp.enable(name)
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    enabled = not is_vscode,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    enabled = not is_vscode,
    config = function()
      -- Only used to install servers; config is handled by nvim-lspconfig above.
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "tsserver", "gopls", "rust_analyzer" },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    enabled = not is_vscode,
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      local cmp = require("cmp")
      local ok_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = ok_lsp and cmp_nvim_lsp.default_capabilities() or nil

      cmp.setup({
        completion = { completeopt = "menu,menuone,noinsert" },
        snippet = { expand = function() end }, -- no snippets by default
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
        },
      })
    end,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    enabled = not is_vscode,
    config = function()
      -- Loaded as a dependency by cmp.
    end,
  },
  {
    "stevearc/conform.nvim",
    enabled = not is_vscode,
    event = { "BufWritePre" },
    config = function()
      require("conform").setup({
        format_on_save = {
          timeout_ms = 1000,
          lsp_fallback = true,
        },
      })
    end,
  },
})

return {
  {
    -- Used for completion, annotations and signatures of Neovim apis
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      "saghen/blink.cmp",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = desc })
          end

          map("ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })
          map("gr", require("telescope.builtin").lsp_references, "goto references")
          map("gd", require("telescope.builtin").lsp_definitions, "goto definition")
          map("gD", vim.lsp.buf.declaration, "goto declaration")
          map("gi", require("telescope.builtin").lsp_implementations, "goto implementation")
          map("gt", require("telescope.builtin").lsp_type_definitions, "goto type definition")
          map("gR", vim.lsp.buf.rename, "Rename")

          map("gO", require("telescope.builtin").lsp_document_symbols, "Document symbols")
          map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace symbols")

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map("<leader>h", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "Toggle inlay hints")
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config({
        severity_sort = true,
        float = {
          border = "rounded",
          source = "if_many",
        },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        },
        virtual_text = {
          spacing = 2,
          format = function(diagnostic)
            local source = diagnostic.source and ("[" .. diagnostic.source .. "] ") or ""
            return source .. diagnostic.message
          end,
        },
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        stylua = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
        basedpyright = {
          handlers = {
            ["textDocument/publishDiagnostics"] = function() end,
          },
          settings = {
            basedpyright = {
              analysis = {
                extraPaths = { "./backend", "./src" },
                exclude = {
                  "**/frontend",
                  "**/node_modules",
                  "**/.ruff_cache",
                  "**/.mypy_cache",
                  "**/.pytest_cache",
                  "**/dist",
                  "**/build",
                  "**/__pycache__",
                },
              },
            },
          },
        },
        vtsls = {},
        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
            format = false, -- Let conform handle formatting
          },
        },
        prettier = {},
        terraformls = {},
        sqlfmt = {},
      }

      ---@type MasonLspconfigSettings
      ---@diagnostic disable-next-line: missing-fields
      require("mason-lspconfig").setup({
        automatic_enable = vim.tbl_keys(servers or {}),
      })

      require("mason-tool-installer").setup({ ensure_installed = vim.tbl_keys(servers) })

      -- Installed LSPs are configured and enabled automatically with mason-lspconfig
      -- The loop below is for overriding the default configuration of LSPs with the ones in the servers table
      for server_name, config in pairs(servers) do
        vim.lsp.config(server_name, config)
      end
    end,
  },
}

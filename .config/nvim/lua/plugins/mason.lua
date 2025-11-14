return {
  {
    "mason-org/mason.nvim",
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      "saghen/blink.cmp",
    },
    opts = {},
    config = function()
      require("mason").setup()

      -- Install LSP servers and formatters via mason-tool-installer
      require("mason-tool-installer").setup({
        ensure_installed = {
          "lua-language-server",
          "basedpyright",
          "ty",
          "pyrefly",
          "vtsls",
          "eslint-lsp",
          "terraform-ls",
          "stylua",
          "prettier",
          "sqlfmt",
          "ruff",
        },
      })
    end,
  },
}

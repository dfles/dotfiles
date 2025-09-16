return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" },
        toml = { "taplo" },
        markdown = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        sql = { "sqlfmt" },
        _ = { "trim_whitespace" },
      },
    },
  },
}

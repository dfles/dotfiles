local venv = os.getenv("VIRTUAL_ENV")

return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "ruff", "mypy" },
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft

      -- Override mypy to use venv if available (keep default config otherwise)
      if venv then
        lint.linters.mypy.cmd = venv .. "/bin/mypy"
      end

      -- Override ruff to use venv if available
      if venv then
        lint.linters.ruff.cmd = venv .. "/bin/ruff"
      end

      -- Create autocommand to trigger linting
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}

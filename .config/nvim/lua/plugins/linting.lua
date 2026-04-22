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

      -- mypy's default parser requires a trailing [error-code], which
      -- reveal_type / note lines lack, so they get dropped.
      local parser = require("lint.parser")
      local note_parser = parser.from_pattern(
        "([^:]+):(%d+):(%d+):(%d+):(%d+): (note): (.*)",
        { "file", "lnum", "col", "end_lnum", "end_col", "severity", "message" },
        { note = vim.diagnostic.severity.HINT },
        { source = "mypy" },
        { end_col_offset = 0 }
      )
      local default_parser = lint.linters.mypy.parser
      lint.linters.mypy.parser = function(output, bufnr, linter_cwd)
        local diags = default_parser(output, bufnr, linter_cwd)
        vim.list_extend(diags, note_parser(output, bufnr, linter_cwd))
        return diags
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

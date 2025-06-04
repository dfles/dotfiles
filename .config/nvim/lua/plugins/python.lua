local venv = os.getenv("VIRTUAL_ENV")

return {
  -- Linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "flake8", "mypy" },
      },
    },
    linters = {
      flake8 = {
        cmd = function()
          return venv and (venv .. "/bin/flake8") or "flake8"
        end,
        args = { "--format=%(code)s:%(text)s" },
        stdin = false,
        ignore_exitcode = true,
      },
      -- A lot of effort to use dmypy. Is it worth it? Maybe.
      mypy = {
        cmd = function()
          return venv and (venv .. "/bin/dmypy") or "dmypy"
        end,
        args = {
          "check",
          "--",
          function()
            return vim.fn.expand("%:p")
          end,
        },
        ignore_exitcode = true,
        stdin = false,
        parser = function(output, bufnr)
          local diagnostics = {}
          for line in vim.gsplit(output, "\n", { trimempty = true }) do
            local path, row, col, msg = line:match("^(.-):(%d+):(%d+): (.+)$")
            if path and row and col and msg then
              table.insert(diagnostics, {
                lnum = tonumber(row) - 1,
                col = tonumber(col) - 1,
                end_lnum = tonumber(row) - 1,
                end_col = tonumber(col),
                severity = vim.diagnostic.severity.WARN,
                source = "dmypy",
                message = msg,
              })
            end
          end
          return diagnostics
        end,
      },
    },
  },
  -- Formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "black" },
      },
      formatters = {
        black = {
          command = function()
            return venv and (venv .. "/bin/black") or "black"
          end,
          args = { "--quiet", "-" },
          stdin = true,
        },
      },
    },
  },
}

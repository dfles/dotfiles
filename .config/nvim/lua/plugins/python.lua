local venv = os.getenv("VIRTUAL_ENV")

local function load_env_file(filepath)
  local env = {}
  local file = io.open(filepath, "r")
  if not file then
    return env
  end

  for line in file:lines() do
    local key, value = line:match("^([%w_]+)%s*=%s*(.+)$")
    if key and value then
      -- Strip optional surrounding quotes
      value = value:gsub("^['\"](.-)['\"]$", "%1")
      env[key] = value
    end
  end

  file:close()
  return env
end

local debug_configs = {
  {
    type = "python",
    request = "launch",
    name = "Django Test",
    program = "${workspaceFolder}/backend/manage.py",
    args = function()
      -- Extract the part after "backend/"
      local guessed_path = vim.fn.expand("%:p:r"):match("backend/(.+)")
      if guessed_path then
        guessed_path = guessed_path:gsub("%.py", ""):gsub("/", ".")
      else
        guessed_path = ""
      end

      local test_path = vim.fn.input("Test file (e.g. app.test_jedi): ", guessed_path)
      if test_path == nil or test_path == "" then
        error("No test path provided")
      end

      return { "test", "--noinput", "--nomigrations", "--exclude-tag=aft", test_path }
    end,
    django = true,
    justMyCode = false,
    console = "integratedTerminal",
    env = load_env_file(vim.fn.getcwd() .. "/.env"),
  },
}

return {
  -- LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          -- Disable publishing diagnostics
          handlers = {
            ["textDocument/publishDiagnostics"] = function() end,
          },
        },
      },
    },
  },
  -- Linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "ruff", "mypy" },
      },
    },
    linters = {
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
  -- Maybe this should move to its own "formatting" plugin?
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" },
        toml = { "taplo" },
      },
    },
  },
  -- Debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      require("dap-python").setup(os.getenv("VIRTUAL_ENV") .. "/bin/python")
      dap.configurations.python = debug_configs

      -- Optional keymaps
      vim.keymap.set("n", "<F5>", dap.continue)
      vim.keymap.set("n", "<F10>", dap.step_over)
      vim.keymap.set("n", "<F11>", dap.step_into)
      vim.keymap.set("n", "<c+F11>", dap.step_out)
      vim.keymap.set("n", "<F12>", dap.step_out)
      vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<Leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Conditional breakpoint" })
      vim.keymap.set("n", "<Leader>dr", dap.restart, { desc = "Restart" })

      vim.keymap.set("n", "<Leader>dt", dap.terminate, { desc = "Stop debugging" })

      -- Auto open/close UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}

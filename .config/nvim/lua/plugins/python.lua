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

local function get_path_root(modulepath)
  local first_part = modulepath:match("^([^.]+)")
  return first_part
end

local function file_exists(filename)
  local file = io.open(filename, "r") -- Attempt to open the file in read mode
  if file then
    file:close() -- Close the file if it was successfully opened
    return true
  else
    return false
  end
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

      -- Check if there's a testsettings file we should include
      local args = { "test", "--noinput", "--nomigrations", "--exclude-tag=aft" }

      if guessed_path and guessed_path ~= "" then
        -- First, check for local testsettings (same directory as test file)
        local current_dir = vim.fn.expand("%:p:h"):match("backend/(.+)")
        local local_test_settings_file = "backend/" .. current_dir .. "/test/testsettings.py"

        -- Then, check for app-level testsettings
        local app_root = get_path_root(guessed_path)
        local app_test_settings_file = "backend/" .. app_root .. "/test/testsettings.py"

        -- Prefer local testsettings over app-level testsettings
        if file_exists(local_test_settings_file) then
          local test_settings = "--settings=" .. current_dir:gsub("/", ".") .. ".test.testsettings"
          table.insert(args, test_settings)
          print("Using local test settings: " .. test_settings)
        elseif file_exists(app_test_settings_file) then
          local test_settings = "--settings=" .. app_root .. ".test.testsettings"
          table.insert(args, test_settings)
          print("Using app-level test settings: " .. test_settings)
        end
      end

      table.insert(args, test_path)
      return args
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
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "off",
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
                autoSearchPaths = true,
                autoImportCompletions = true,
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
          on_attach = function(client, bufnr)
            -- Disable basedpyright diagnostics completely
            -- We use mypy via nvim-lint instead for type checking
            client.server_capabilities.diagnosticProvider = nil
          end,
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
    config = function(_, opts)
      local lint = require("lint")

      -- Set up linters by filetype
      lint.linters_by_ft = opts.linters_by_ft

      -- Configure custom mypy linter using dmypy
      lint.linters.mypy = {
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
      }
    end,
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
      -- Gracefully handle not having a python virtual env active.
      -- In general this debugging should be re-thought so we can support multiple debuggers.
      local pycmd = "python3"
      if os.getenv("VIRTUAL_ENV") then
        pycmd = os.getenv("VIRTUAL_ENV") .. "/bin/python"
      end

      require("dap-python").setup(pycmd)
      dap.configurations.python = debug_configs
      vim.keymap.set("n", "<F5>", dap.continue)
      vim.keymap.set("n", "<F10>", dap.step_over)
      vim.keymap.set("n", "<F11>", dap.step_into)
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

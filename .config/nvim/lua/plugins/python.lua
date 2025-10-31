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
  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local dap = require("dap")

      require("dap-python").setup()
      dap.configurations.python = debug_configs
    end,
  },
}

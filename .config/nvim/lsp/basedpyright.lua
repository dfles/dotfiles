---@type vim.lsp.Config
return {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "requirements.txt",
    ".git",
  },
  single_file_support = true,
  handlers = {
    ["textDocument/publishDiagnostics"] = function() end,
    ["window/logMessage"] = function(err, result, ctx, config)
      -- Suppress enumeration warnings
      if result and result.message and result.message:match("Enumeration of workspace") then
        return
      end
      -- Call default handler for other messages
      vim.lsp.handlers["window/logMessage"](err, result, ctx, config)
    end,
  },
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = false, -- Disable workspace scanning
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        extraPaths = { "./backend" },
        exclude = {
          "**/frontend",
          "**/node_modules",
          "**/.ruff_cache",
          "**/.mypy_cache",
          "**/.pytest_cache",
          "**/dist",
          "**/build",
          "**/__pycache__",
          "**/.venv",
          "**/venv",
          "**/.git",
          "./frontend",
          "./node_modules",
          "./.ruff_cache",
          "./.mypy_cache",
          "./.pytest_cache",
          "./dist",
          "./build",
          "./__pycache__",
          "./.venv",
          "./venv",
          "./.git",
        },
        ignore = { "*" },
        indexing = false, -- Disable background indexing
      },
    },
  },
}

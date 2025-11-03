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
  },
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
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
        },
        ignore = { "*" }, -- Only analyze open files
      },
    },
  },
}

return {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
  single_file_support = true,
  handlers = {
    ["textDocument/publishDiagnostics"] = function() end,
  },
  settings = {
    basedpyright = {
      analysis = {
        extraPaths = { "./backend", "./src" },
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
}

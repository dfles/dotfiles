---@type vim.lsp.Config
return {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_markers = {
    "ty.toml",
    "pyproject.toml",
    ".git",
  },
  single_file_support = true,
  settings = {
    ty = {
      diagnosticMode = "off",
    },
  },
}

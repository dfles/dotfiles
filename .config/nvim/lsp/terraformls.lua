return {
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "terraform-vars" },
  root_markers = {
    ".terraform",
    ".git",
  },
  single_file_support = true,
}

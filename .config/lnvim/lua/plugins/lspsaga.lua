return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    lightbulb = {
      enable = true,
      sign = true,
      virtual_text = false,
    },
    ui = {
      code_action = "",
    },
  },
}

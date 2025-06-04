return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- optional, for icons
    "nvim-treesitter/nvim-treesitter", -- optional, for better UI
  },
  config = function()
    require("lspsaga").setup({})
  end,
}

return {
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      float = {
        max_width = 120,
        max_height = 30,
      },
      keymaps = {
        ["<Esc><Esc>"] = "actions.close",
      },
    },
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    keys = {
      { "<leader>E", "<cmd>Oil<cr>", desc = "Explorer (buffer)" },
      { "<leader>e", "<cmd>Oil --float<cr>", desc = "Explorer (float)" },
    },
    lazy = false,
  },
}

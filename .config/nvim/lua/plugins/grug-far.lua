return {
  {
    "MagicDuck/grug-far.nvim",
    config = function()
      require("grug-far").setup({})
    end,
    keys = {
      { "<leader>sr", "<cmd>GrugFar<CR>", desc = "grug-far" },
    },
  },
}

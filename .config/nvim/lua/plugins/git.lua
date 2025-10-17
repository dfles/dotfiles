return {
  {
    "akinsho/git-conflict.nvim",
    config = function()
      require("git-conflict").setup({
        highlights = {
          incoming = "DiffText",
          current = "DiffAdd",
        },
        disable_diagnostics = true,
      })
    end,
    keys = {
      { "<leader>gp", "<Plug>(git-conflict-prev-conflict)", desc = "Previous conflict" },
      { "<leader>gn", "<Plug>(git-conflict-next-conflict)", desc = "Next conflict" },
      { "<leader>go", "<Plug>(git-conflict-ours)", desc = "Conflict: Keep current" },
      { "<leader>gt", "<Plug>(git-conflict-theirs)", desc = "Conflict: Keep incoming" },
      { "<leader>gb", "<Plug>(git-conflict-both)", desc = "Conflict: Keep both" },
      { "<leader>gx", "<Plug>(git-conflict-none)", desc = "Conflict: Remove conflict" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300,
        virt_text_pos = "eol", -- eol/right_align
      },
      current_line_blame_formatter = "        <author>, <author_time:%Y-%m-%d> - <summary>",
    },
    keys = {
      { "<leader>gi", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle blame" },
      { "<leader>gI", "<cmd>Gitsigns blame<CR>", desc = "Full blame" },
    },
  },
}

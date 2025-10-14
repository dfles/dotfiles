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
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300,
        virt_text_pos = "eol", -- eol/right_align
      },
      current_line_blame_formatter = "        <author>, <author_time:%Y-%m-%d> - <summary>",
    },
  },
}

return {
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
      preset = "helix",
      -- Top-level groupings
      spec = {
        { "<leader>f", group = "files" },
        { "<leader>s", group = "search" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>g", group = "git" },
        { "<leader>d", group = "debug" },
      },
    },
    keys = {
      { -- Global which-key. Maybe someday I won't need it. Not today.
        "<leader>?",
        function()
          require("which-key").show({ global = true })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}

return {
  -- Code outline and navigation
  {
    "stevearc/aerial.nvim",
    opts = {
      backends = { "treesitter", "lsp", "markdown", "man" },
      layout = {
        width = 30,
        default_direction = "right",
        placement = "window",
      },
      show_guides = true,
      filter_kind = false,

      -- File type specific configurations
      markdown = {
        update_when = "insert_leave",
      },

      -- Enable for specific file types
      attach_mode = "window",

      -- Treesitter symbol kinds to show
      treesitter = {
        update_delay = 300,
      },
    },
    keys = {
      { "<leader>o", "<cmd>AerialToggle<cr>", desc = "Toggle outline" },
      { "<leader>O", "<cmd>AerialNavToggle<cr>", desc = "Outline navigation" },
    },
    config = function(_, opts)
      require("aerial").setup(opts)

      -- Auto-open aerial for supported file types (optional)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown" },
        callback = function()
          require("aerial").open()
        end,
      })
    end,
  },
}

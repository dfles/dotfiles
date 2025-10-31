-- Smaller, essential configs that I'm too lazy to break out into individual files
return {
  { "NMAC427/guess-indent.nvim", opts = {} },
  { "windwp/nvim-autopairs", opts = {} },
  { -- Highlight todo, notes, etc in comments
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
  { -- Collection of various small independent plugins/modules
    "echasnovski/mini.nvim",
    config = function()
      -- Better Around/Inside textobjects
      -- Examples:
      --  - va)  - Visually select Around [)]paren
      --  - yinq - Yank Inside Next Quote
      --  - ci'  - Change Inside [']quote
      require("mini.ai").setup({ n_lines = 500 })
      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      -- - saiw) - Surround Add Inner Word [)]Paren
      -- - sd'   - Surround Delete [']quotes
      -- - sr)'  - Surround Replace [)] [']
      require("mini.surround").setup()

      local statusline = require("mini.statusline")
      statusline.setup({ use_icons = true })

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return "%2l:%-2v"
      end
    end,
  },
  { -- Zen(ish) mode with note taking in the gutters
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    opts = {
      width = 150,
    },
    keys = {
      { "<leader>z", "<cmd>NoNeckPain<cr>", desc = "Toggle centered window" },
    },
  },
}

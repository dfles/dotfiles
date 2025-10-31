return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-tree/nvim-web-devicons", enabled = true },
    },
    config = function()
      --  Insert mode: <c-/>
      --  Normal mode: ?
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-s>"] = "select_vertical",
              ["<C-h>"] = "select_horizontal",
            },
            n = {
              ["<C-s>"] = "select_vertical",
              ["<C-h>"] = "select_horizontal",
            },
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })
      -- Optionally load fzf
      pcall(require("telescope").load_extension, "fzf")

      -- See `:help telescope.builtin`
      local builtin = require("telescope.builtin")
      -- Files/buffers
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Open buffers" })
      vim.keymap.set("n", "<leader>fn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "nvim files" })

      vim.keymap.set("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "Fuzzy search current buffer" })

      vim.keymap.set("n", "<leader>f/", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live grep in open files",
        })
      end, { desc = "Search in open files" })

      -- Search
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help" })
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Keymaps" })
      vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "Search select Telescope" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Search current word" })
      vim.keymap.set("n", "<leader>s/", builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })
      vim.keymap.set("n", "<leader>sR", builtin.resume, { desc = "Resume search" })
    end,
  },
}

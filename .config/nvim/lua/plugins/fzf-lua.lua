return {
  {
    "ibhagwan/fzf-lua",
    event = "VimEnter",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", enabled = true },
    },
    config = function()
      local fzf = require("fzf-lua")

      fzf.setup({
        winopts = {
          height = 0.85,
          width = 0.80,
          border = "none",
          preview = {
            horizontal = "right:48%",
            border = "none",
            scrollbar = false,
          },
        },
        fzf_opts = {
          ["--padding"] = "1,2,1,2",
          ["--margin"] = "0",
        },
        hls = {
          normal = "Normal",
          border = "Normal",
          preview_normal = "Normal",
        },
        keymap = {
          builtin = {
            ["<C-l>"] = "toggle-preview",
          },
          fzf = {
            ["ctrl-a"] = "select-all",
            ["ctrl-q"] = "accept",
          },
        },
        actions = {
          files = {
            ["default"] = fzf.actions.file_edit,
            ["ctrl-s"] = fzf.actions.file_vsplit,
            ["ctrl-q"] = fzf.actions.file_sel_to_qf,
          },
        },
        files = {
          prompt = "Files❯ ",
        },
        grep = {
          prompt = "Rg❯ ",
        },
      })

      -- Files/buffers
      vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
      vim.keymap.set("n", "<leader><leader>", fzf.buffers, { desc = "Open buffers" })
      vim.keymap.set("n", "<leader>fn", function()
        fzf.files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "nvim files" })

      vim.keymap.set("n", "<leader>/", fzf.blines, { desc = "Fuzzy search current buffer" })

      vim.keymap.set("n", "<leader>f/", function()
        fzf.live_grep({ grep_open_files = true })
      end, { desc = "Search in open files" })

      -- Search
      vim.keymap.set("n", "<leader>sh", fzf.helptags, { desc = "Help" })
      vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "Keymaps" })
      vim.keymap.set("n", "<leader>ss", fzf.builtin, { desc = "Search select fzf-lua" })
      vim.keymap.set("n", "<leader>sw", fzf.grep_cword, { desc = "Search current word" })
      vim.keymap.set("n", "<leader>s/", fzf.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>sd", fzf.diagnostics_document, { desc = "Diagnostics" })
      vim.keymap.set("n", "<leader>sR", fzf.resume, { desc = "Resume search" })
    end,
  },
}

-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

require("options")
require("keymaps")
require("autocmd")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require("lazy").setup({
  { "NMAC427/guess-indent.nvim", opts = {} },
  { "windwp/nvim-autopairs", opts = {} },
  { -- Highlight todo, notes, etc in comments
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
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
      statusline.setup({ use_icons = vim.g.have_nerd_font })

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return "%2l:%-2v"
      end
    end,
  },
  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      "bash",
      "diff",
      "go",
      "gomod",
      "gosum",
      "html",
      "javascript",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "sql",
      "terraform",
      "toml",
      "typescript",
      "vim",
      "vimdoc",
      ensure_installed = {},
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- Folding
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end,
  },
  -- Zen(ish) mode with note taking in the gutters
  {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    opts = {
      width = 150,
    },
    keys = {
      { "<leader>z", "<cmd>NoNeckPain<cr>", desc = "Toggle centered window" },
    },
  },
  -- Additional, more involved plugin config
  { import = "plugins" },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

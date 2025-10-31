return {
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
}

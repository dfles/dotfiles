return {
  { "EdenEast/nightfox.nvim", lazy = false, priority = 1000 },
  {
    "zenbones-theme/zenbones.nvim",
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Disable italics because I'm not a fan.
      local grpid = vim.api.nvim_create_augroup("custom_highlights", {})
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = grpid,
        pattern = "*bones",
        command = "hi Comment  gui=NONE |" .. "hi Constant gui=NONE",
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawabones",
    },
  },
}

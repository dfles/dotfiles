-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.relativenumber = false
vim.opt.mouse = "a"

vim.lsp.inlay_hint.enable(true)

vim.o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize"

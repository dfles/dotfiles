-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>gb", function()
  require("gitsigns").toggle_current_line_blame()
end, { desc = "Toggle Git Blame" })

vim.keymap.set("n", "gh", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek definition" })
vim.keymap.set("n", "gH", "<cmd>Lspsaga peek_type_definition<CR>", { desc = "Peek type definition" })

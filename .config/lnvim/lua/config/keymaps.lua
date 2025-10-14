-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Git
vim.keymap.set("n", "<leader>gb", function()
  require("gitsigns").toggle_current_line_blame()
end, { desc = "Toggle Git Blame" })

vim.keymap.set("n", "<leader>gB", function()
  require("gitsigns").blame_line({ full = true })
end, { desc = "Git Blame Full" })

vim.keymap.set("n", "<leader>gN", "<Plug>(git-conflict-prev-conflict)", { desc = "Previous conflict" })
vim.keymap.set("n", "<leader>gn", "<Plug>(git-conflict-next-conflict)", { desc = "Next conflict" })
vim.keymap.set("n", "<leader>go", "<Plug>(git-conflict-ours)", { desc = "Conflict: Keep current" })
vim.keymap.set("n", "<leader>gt", "<Plug>(git-conflict-theirs)", { desc = "Conflict: Keep incoming" })
vim.keymap.set("n", "<leader>gb", "<Plug>(git-conflict-both)", { desc = "Conflict: Keep both" })
vim.keymap.set("n", "<leader>g0", "<Plug>(git-conflict-none)", { desc = "Conflict: Remove conflict" })

-- LSP
vim.keymap.set("n", "gh", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek definition" })
vim.keymap.set("n", "gH", "<cmd>Lspsaga peek_type_definition<CR>", { desc = "Peek type definition" })

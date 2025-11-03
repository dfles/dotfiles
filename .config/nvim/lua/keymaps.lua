-- Surely this will stop me from using arrow keys
for _, mode in ipairs({ "n", "v", "i" }) do
  vim.keymap.set(mode, "<Up>", "<Nop>", { noremap = true, silent = true })
  vim.keymap.set(mode, "<Down>", "<Nop>", { noremap = true, silent = true })
  vim.keymap.set(mode, "<Left>", "<Nop>", { noremap = true, silent = true })
  vim.keymap.set(mode, "<Right>", "<Nop>", { noremap = true, silent = true })
  vim.keymap.set(mode, "<BS>", "<Nop>", { noremap = true, silent = true })
end

vim.keymap.set("n", "<leader>bo", "<cmd>%bd|e#<CR>", { desc = "Close other buffers" })
-- Delete current buffer without closing window
vim.keymap.set("n", "<leader>bd", "<cmd>bp<bar>sp<bar>bn<bar>bd<CR>", { desc = "Delete buffer" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Surely this will stop me from using arrow keys
for _, mode in ipairs({ "n", "v", "i" }) do
  vim.keymap.set(mode, "<Up>", "<Nop>", { noremap = true, silent = true })
  vim.keymap.set(mode, "<Down>", "<Nop>", { noremap = true, silent = true })
  vim.keymap.set(mode, "<Left>", "<Nop>", { noremap = true, silent = true })
  vim.keymap.set(mode, "<Right>", "<Nop>", { noremap = true, silent = true })
end

-- Path yanking
vim.keymap.set("n", "<leader>by", ":let @+=expand('%:.')<cr>", { desc = "Yank relative path" })
vim.keymap.set("n", "<leader>bY", ":let @+=@%<cr>", { desc = "Yank absolute path" })

vim.keymap.set("n", "<leader>ba", "<cmd>%bd<cr>", { desc = "Delete all buffers" })
vim.keymap.set("n", "<leader>bo", "<cmd>%bd|e#<cr>", { desc = "Delete other buffers" })
-- Delete current buffer without closing window
vim.keymap.set("n", "<leader>bd", "<cmd>bp<bar>sp<bar>bn<bar>bd<cr>", { desc = "Delete current buffer" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<leader>ud", function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
end, { desc = "Toggle diagnostics" })

vim.keymap.set("n", "<leader>uh", function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
end, { desc = "Toggle inlay hints" })

-- Toggle relativenumber to make referencing line numbers while pairing simpler.
vim.keymap.set("n", "<leader>un", function()
  vim.o.relativenumber = not vim.o.relativenumber
end, { desc = "Toggle relative line numbers" })

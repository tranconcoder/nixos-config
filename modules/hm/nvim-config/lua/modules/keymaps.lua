vim.keymap.set("n", "<Tab>", "<C-^>", { desc = "Switch to alternate buffer" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Save file
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>write<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix list" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Close current buffer
vim.keymap.set("n", "<C-w>", "<cmd>bdelete<CR>", { desc = "Close current buffer" })

-- Window navigation
vim.keymap.set("n", "<A-h>", "<C-w><C-h>", { desc = "Move to left window" })
vim.keymap.set("n", "<A-l>", "<C-w><C-l>", { desc = "Move to right window" })
vim.keymap.set("n", "<A-j>", "<C-w><C-j>", { desc = "Move to lower window" })
vim.keymap.set("n", "<A-k>", "<C-w><C-k>", { desc = "Move to upper window" })


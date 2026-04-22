vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<leader>nh", ":nohlsearch<CR>")

map("n", "j", "gj")
map("n", "k", "gk")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

map("n", "<leader>+", "<C-w>5>")
map("n", "<leader>-", "<C-w>5<")

map("n", "<leader>sv", "<C-w>v")
map("n", "<leader>sh", "<C-w>s")
map("n", "<leader>sc", "<C-w>c")
map("n", "<leader>so", "<C-w>o")

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>")

map("n", "<leader>qq", "<cmd>qa<cr>")

map({ "n", "v" }, "<leader>y", '"+y')
map({ "n", "v" }, "<leader>p", '"+p')
map("n", "<leader>yyp", "yyP")
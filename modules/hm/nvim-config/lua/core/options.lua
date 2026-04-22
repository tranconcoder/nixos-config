local opt = vim.opt

opt.laststatus = 3
opt.showmode = false
opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.mouse = "a"
opt.splitright = true
opt.splitbelow = true
opt.completeopt = "menu,menuone,noselect"
opt.shortmess:append("c")
opt.wildmode = "longest:full"
opt.timeoutlen = 400

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.colorcolumn = "80"

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.undofile = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.termguicolors = true
opt.guifont = "JetBrainsMono Nerd Font:h14"

opt.updatetime = 200
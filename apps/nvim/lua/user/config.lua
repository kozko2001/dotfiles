
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2  -- use 2 chars for numbers 
vim.opt.mouse = "a" -- enable mouse
vim.opt.clipboard = "unnamedplus" -- use system clipboard


vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true   -- convert tabs to spaces
vim.opt.smartindent = true
vim.opt.wrap = false       -- not wrap lines

vim.opt.swapfile = false

vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true -- search with ignoring case

vim.opt.termguicolors = true

vim.opt.scrolloff = 8      -- have at least 8 after the cursor
vim.opt.sidescroll = 8     -- have 8 chars left and right of the cursor
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50


vim.opt.foldcolumn = '1'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.opt.foldenable = true
vim.opt.showtabline = 0 -- hide tabbar
vim.opt.laststatus = 3

vim.opt.completeopt = "menuone,preview"

vim.g.maplocalleader = ","

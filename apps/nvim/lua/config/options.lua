vim.g.mapleader = " "
vim.g.maplocalleader = ","

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.mouse = "a"
opt.clipboard = "unnamedplus"

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

opt.splitright = true
opt.splitbelow = true

opt.swapfile = false
opt.backup = false
opt.undofile = true

opt.updatetime = 250
opt.timeoutlen = 400

opt.completeopt = { "menuone", "noselect", "popup" }

opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Neovim 0.11+: global float border for hover/diagnostics/completion docs.
vim.o.winborder = "rounded"
-- Neovim 0.10+: live preview of :s and friends in a split.
vim.o.inccommand = "split"

-- Native LSP folding (Neovim 0.10+) instead of a folding plugin.
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
opt.foldlevel = 99
opt.foldtext = ""

-- Per-project overrides: drop a `.nvim.lua` in a project root and it is
-- auto-sourced (with a one-time trust prompt via :h 'secure').
vim.o.exrc = true
vim.o.secure = true

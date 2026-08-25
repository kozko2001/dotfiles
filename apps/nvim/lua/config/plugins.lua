-- Neovim 0.12 native package manager (:h vim.pack). No lazy.nvim.
-- Update with :lua vim.pack.update() ; remove by deleting from this list
-- then running :lua vim.pack.del({"name"}).
vim.pack.add({
  "https://github.com/echasnovski/mini.nvim",
  "https://github.com/catppuccin/nvim",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
})

-- Colorscheme: catppuccin, flavors latte/frappe/macchiato/mocha.
require("catppuccin").setup({
  flavor = "mocha",
})
pcall(vim.cmd.colorscheme, "catppuccin")

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
  -- Obsidian vault support (see lua/obsidian_vault.lua). Community fork, no hard deps.
  {
    src = "https://github.com/obsidian-nvim/obsidian.nvim",
    version = vim.version.range("*"), -- latest release tag
  },
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

-- Colorscheme: catppuccin, flavors latte/frappe/macchiato/mocha.
require("catppuccin").setup({
  flavor = "mocha",
})
pcall(vim.cmd.colorscheme, "catppuccin")

return {
	-- { 'rose-pine/neovim', name = 'rose-pine' }
  { 
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "frappe",
      integrations = {
        cmp = true,
        nvimtree = true,
        telescope = true,
        notify = true,
        neogit = true,
        markdown = true,
        leap = true,
        treesitter = true,
      }
    },
    config = function (_, opts)
      require("catppuccin").setup(opts)
    end
  }
}


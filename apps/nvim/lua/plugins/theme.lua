return {
	-- { 'rose-pine/neovim', name = 'rose-pine' }
	-- {
	--   "catppuccin/nvim",
	--   name = "catppuccin",
	--   opts = {
	--     flavour = "frappe",
	--     integrations = {
	--       cmp = true,
	--       nvimtree = true,
	--       telescope = true,
	--       notify = true,
	--       neogit = true,
	--       markdown = true,
	--       leap = true,
	--       treesitter = true,
	--     }
	--   },
	--   config = function (_, opts)
	--     require("catppuccin").setup(opts)
	--   end
	-- }
	--
	{
		"0xstepit/flow.nvim",
		lazy = false,
		tag = "v2.0.0",
		priority = 1000,
		enabled = true,
		opts = {
			theme = {
				style = "dark", -- "dark" or "light"
				contrast = "default", -- "default" or "high"
				transparent = false,
			},
			colors = {
				mode = "default",
				fluo = "orange", -- "pink", "cyan", "yellow", "orange", "green"
			},
			ui = {
				borders = "fluo", -- "theme", "inverse", "fluo", "none"
				aggressive_spell = false,
			},
		},
		config = function(_, opts)
			require("flow").setup(opts)
			vim.cmd("colorscheme flow")
		end,
	},
}

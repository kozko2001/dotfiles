return {
	"nvim-neotest/neotest",
	enabled = true,
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"jfpedroza/neotest-elixir",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("rustaceanvim.neotest"),
				require("neotest-elixir"),
			},
		})
	end,
}

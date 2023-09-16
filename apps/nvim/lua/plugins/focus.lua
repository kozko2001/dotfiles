return {
	"beauwilliams/focus.nvim",
	enabled = false,
	config = function()
		require("focus").setup()
	end,
	event = "VeryLazy",
}

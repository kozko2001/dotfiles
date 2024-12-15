return {
	"echasnovski/mini.bracketed",
	version = false,
	event = "VeryLazy",
	config = function()
		require("mini.bracketed").setup({
			comment = { suffix = "" },
			indent = { suffix = "" },
			file = { suffix = "" },
			treesitter = { suffix = "" },
			oldfiles = { suffix = "" },
			window = { suffix = "" },
			jump = { suffix = "" },
		})
	end,
}

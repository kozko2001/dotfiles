return {
	"epwalsh/obsidian.nvim",
	version = "*",
	ft = "markdown",
	lazy = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "Vault",
				path = "~/personal-notes/PersonalNotes/",
			},
		},
	},
}

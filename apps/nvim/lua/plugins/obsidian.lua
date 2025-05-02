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
				path = "~/logseq/obsidian-notes-2",
			},
		},
	},
}

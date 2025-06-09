---
--- better diffs :D
--- :DiffviewOpen diff working with index
return {
	"sindrets/diffview.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		require("diffview").setup({
			diff_binaries = false, -- Show diffs for binaries
			enhanced_diff_hl = true, -- Better diff highlighting
			use_icons = true, -- Requires nvim-web-devicons
			show_help_hints = true, -- Show hints for help panel
			view = {
				default = {
					layout = "diff2_horizontal", -- or "diff2_vertical"
				},
			},
		})
	end,
}

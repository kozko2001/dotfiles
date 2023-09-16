
return {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    keys = {
	{ "<leader>ff", "<cmd>Telescope find_files <CR>", desc = "Find files" },
	{ "<leader>fg", "<cmd>Telescope live_grep <CR>", desc = "Find in files" },
	{ "<leader>fb", "<cmd>Telescope buffers <CR>", desc = "Find buffer" },
    },
    config = function ()
        require("telescope").setup({})
    end,
    dependencies = { 'nvim-lua/plenary.nvim' }
}

return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		lazy = true,
		config = function()
			-- This is where you modify the settings for lsp-zero
			-- Note: autocompletion settings will not take effect

			require("lsp-zero.settings").preset({})
		end,
	},

	-- Autocompletion
	-- {
	-- 	"hrsh7th/nvim-cmp",
	-- 	event = "InsertEnter",
	-- 	dependencies = {
	-- 		{
	-- 			"L3MON4D3/LuaSnip",
	-- 			dependencies = {
	-- 				"rafamadriz/friendly-snippets",
	-- 				config = function()
	-- 					require("luasnip.loaders.from_vscode").lazy_load()
	-- 				end,
	-- 			},
	-- 		},
	-- 		{ "hrsh7th/cmp-buffer" },
	-- 		{ "hrsh7th/cmp-path" },
	-- 		{ "hrsh7th/cmp-nvim-lsp" },
	-- 		{
	-- 			"saadparwaiz1/cmp_luasnip",
	-- 		},
	-- 	},
	-- 	config = function()
	-- 		-- Here is where you configure the autocompletion settings.
	-- 		-- The arguments for .extend() have the same shape as `manage_nvim_cmp`:
	-- 		-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp
	--
	-- 		require("lsp-zero.cmp").extend()
	--
	-- 		-- And you can configure cmp even more, if you want to.
	-- 		local cmp = require("cmp")
	-- 		local cmp_action = require("lsp-zero.cmp").action()
	--
	-- 		cmp.setup({
	-- 			completion = { completeopt = "menu,menuone,noinsert" },
	-- 			sources = {
	-- 				{ name = "path" },
	-- 				{ name = "nvim_lsp" },
	-- 				{ name = "buffer", keyword_length = 3 },
	-- 				{ name = "luasnip", keyword_length = 1 },
	-- 			},
	-- 			mapping = {
	-- 				["<C-space>"] = cmp.mapping.complete(),
	-- 				["<C-f>"] = cmp_action.luasnip_jump_forward(),
	-- 				["<C-b>"] = cmp_action.luasnip_jump_backward(),
	-- 			},
	-- 		})
	-- 	end,
	-- }, -- LSP
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		version = "v0.*",
		opts = {
			keymap = { preset = "default" },
			apppearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			signature = { enabled = true },
		},
	},
	{
		"neovim/nvim-lspconfig",
		cmd = "LspInfo",
		event = { "BufRead", "BufNewFile" },
		dependencies = {
			-- { "hrsh7th/cmp-nvim-lsp" },
			{ "williamboman/mason-lspconfig.nvim", "saghen/blink.cmp" },
			-- { Not using things should be installed using nix
			-- 	"williamboman/mason.nvim",
			-- 	build = function()
			-- 		pcall(vim.cmd, "MasonUpdate")
			-- 	end,
			-- 	opts = {
			-- 		ensure_installed = {
			-- 			"stylua",
			-- 			"shfmt",
			-- 			"flake8",
			-- 			"shellcheck",
			-- 		},
			-- 	},
			-- },
			{
				"folke/neodev.nvim",
				config = function()
					require("neodev").setup({})
				end,
			},
			{
				"kevinhwang91/nvim-ufo",
				dependencies = { "kevinhwang91/promise-async" },
				keys = {
					{ "zR", desc = "open all folds" },
					{ "zM", desc = "close all folds" },
					{ "K", desc = "peek fold or lsp hover" },
				},
				config = function()
					require("ufo").setup()
					vim.keymap.set("n", "zR", require("ufo").openAllFolds)
					vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
					vim.keymap.set("n", "K", function()
						local winid = require("ufo").peekFoldedLinesUnderCursor()
						if not winid then
							vim.lsp.buf.hover()
						end
					end)
				end,
			},
		},
		config = function()
			-- This is where all the LSP shenanigans will live
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local lsp = require("lsp-zero").preset({})

			lsp.on_attach(function(_, bufnr)
				lsp.default_keymaps({ buffer = bufnr })
			end)

			-- (Optional) Configure lua language server for neovim
			require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())
			require("lspconfig").tsserver.setup({})
			require("lspconfig").svelte.setup({})
			require("lspconfig").pyright.setup({})
			require("lspconfig").elixirls.setup({
				cmd = { "elixir-ls" },
			})
			require("lspconfig").clojure_lsp.setup({
				cmd = { "clojure-lsp" },
			})

			require("lspconfig").ocamllsp.setup({})

			lsp.set_server_config({
				capabilities = {
					textDocument = {
						foldingRange = {
							dynamicRegistration = false,
							lineFoldingOnly = true,
						},
					},
				},
			})
			lsp.setup()
		end,
	},
}

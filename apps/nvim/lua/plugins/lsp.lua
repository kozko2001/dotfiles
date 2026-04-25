return {
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		version = "1.*",
		build = "cargo build --release",
		opts = {
			keymap = { preset = "default" },
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},

			signature = { enabled = true, window = { border = "rounded" } },
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 250,
					treesitter_highlighting = true,
					window = { border = "rounded" },
				},
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					lsp = {
						min_keyword_length = 2,
						score_offset = 0,
					},
					path = {
						min_keyword_length = 0,
					},
					snippets = {
						min_keyword_length = 2,
					},
					buffer = {
						min_keyword_length = 5,
						max_items = 5,
					},
				},
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		cmd = "LspInfo",
		event = { "BufRead", "BufNewFile" },
		dependencies = {
			{ "williamboman/mason-lspconfig.nvim", "saghen/blink.cmp" },
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
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
			local capabilities = vim.tbl_deep_extend("force", require("blink.cmp").get_lsp_capabilities(), {
				textDocument = {
					foldingRange = {
						dynamicRegistration = false,
						lineFoldingOnly = true,
					},
				},
			})

			vim.lsp.config("*", { capabilities = capabilities })

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local buf = ev.buf
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf })
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = buf })
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = buf })
					vim.keymap.set("n", "go", vim.lsp.buf.type_definition, { buffer = buf })
					vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = buf })
					vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { buffer = buf })
					vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { buffer = buf })
					vim.keymap.set("n", "<F3>", function() vim.lsp.buf.format() end, { buffer = buf })
					vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, { buffer = buf })
					vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, { buffer = buf })
					vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, { buffer = buf })
				end,
			})

			vim.lsp.config("elixirls", { cmd = { "elixir-ls" } })
			vim.lsp.config("clojure_lsp", { cmd = { "clojure-lsp" } })

			vim.lsp.enable({
				"lua_ls",
				"ts_ls",
				"svelte",
				"pyright",
				"eslint",
				"elixirls",
				"clojure_lsp",
				"ocamllsp",
				"marksman",
			})
		end,
	},
}

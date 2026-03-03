return {
	"mrcjkb/rustaceanvim",
	version = "^8", -- Recommended
	lazy = false, -- This plugin is already lazy
	init = function()
		vim.g.rustaceanvim = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			return {
				server = {
					capabilities = capabilities,
					on_attach = function(_, bufnr)
						-- Reuse lsp-zero default keymaps (gd, gr, K, etc.)
						require("lsp-zero").default_keymaps({ buffer = bufnr })

						-- Override K with rustaceanvim's hover actions (richer than plain hover)
						vim.keymap.set("n", "K", function()
							vim.cmd.RustLsp({ "hover", "actions" })
						end, { buffer = bufnr, desc = "Rust hover actions" })

						-- Code actions via rustaceanvim (supports rust-analyzer extras)
						vim.keymap.set("n", "<leader>ca", function()
							vim.cmd.RustLsp("codeAction")
						end, { buffer = bufnr, desc = "Rust code action" })

						-- Explain errors in a popup
						vim.keymap.set("n", "<leader>ce", function()
							vim.cmd.RustLsp("explainError")
						end, { buffer = bufnr, desc = "Explain error" })

						-- Open Cargo.toml
						vim.keymap.set("n", "<leader>rc", function()
							vim.cmd.RustLsp("openCargo")
						end, { buffer = bufnr, desc = "Open Cargo.toml" })

						-- Run/debug nearest test or binary
						vim.keymap.set("n", "<leader>rr", function()
							vim.cmd.RustLsp("runnables")
						end, { buffer = bufnr, desc = "Rust runnables" })

						vim.keymap.set("n", "<leader>rd", function()
							vim.cmd.RustLsp("debuggables")
						end, { buffer = bufnr, desc = "Rust debuggables" })
					end,

					default_settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
							},
							checkOnSave = {
								command = "clippy",
							},
						},
					},
				},
			}
		end
	end,
}

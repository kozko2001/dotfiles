return {
	{
		"ziontee113/syntax-tree-surfer",
		event = "VeryLazy",
		enabled = true,
		config = function()
			local opts = { noremap = true, silent = true }
			local optsWithDescription = function(desc)
				return { noremap = true, silent = true, desc = desc }
			end
			-- Normal Mode Swapping:
			-- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
			vim.keymap.set("n", "vU", function()
				vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
				return "g@l"
			end, { silent = true, expr = true })

			vim.keymap.set("n", "vD", function()
				vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
				return "g@l"
			end, { silent = true, expr = true })

			-- -- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
			-- vim.keymap.set("n", "vd", function()
			--   vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
			--   return "g@l"
			-- end, { silent = true, expr = true })
			-- vim.keymap.set("n", "vu", function()
			--   vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
			--   return "g@l"
			-- end, { silent = true, expr = true })

			--> If the mappings above don't work, use these instead (no dot repeatable)
			-- vim.keymap.set("n", "vd", '<cmd>STSSwapCurrentNodeNextNormal<cr>', opts)
			-- vim.keymap.set("n", "vu", '<cmd>STSSwapCurrentNodePrevNormal<cr>', opts)
			-- vim.keymap.set("n", "vD", '<cmd>STSSwapDownNormal<cr>', opts)
			-- vim.keymap.set("n", "vU", '<cmd>STSSwapUpNormal<cr>', opts)

			-- Visual Selection from Normal Mode
			vim.keymap.set("n", "vx", "<cmd>STSSelectMasterNode<cr>", opts)
			vim.keymap.set("n", "vn", "<cmd>STSSelectCurrentNode<cr>", opts)

			-- Select Nodes in Visual Mode
			vim.keymap.set("x", "K", "<cmd>STSSelectPrevSiblingNode<cr>", opts)
			vim.keymap.set("x", "J", "<cmd>STSSelectNextSiblingNode<cr>", opts)
			vim.keymap.set("x", "H", "<cmd>STSSelectParentNode<cr>", opts)
			vim.keymap.set("x", "L", "<cmd>STSSelectChildNode<cr>", opts)

			-- Swapping Nodes in Visual Mode
			vim.keymap.set("x", "<A-j>", "<cmd>STSSwapNextVisual<cr>", opts)
			vim.keymap.set("x", "<A-k>", "<cmd>STSSwapPrevVisual<cr>", opts)

			-- Syntax Tree Surfer V2 Mappings
			-- Targeted Jump with virtual_text
			local sts = require("syntax-tree-surfer")
			vim.keymap.set("n", "gp", function() -- only jump to variable_declarations
				sts.targeted_jump({ "parameter", "parameters", "formal_parameters" })
			end, optsWithDescription("tree surfer go to parameters"))
			vim.keymap.set("n", "gii", function() -- only jump to variable_declarations
				sts.targeted_jump({ "import_from_statement", "import_statement", "use_declaration", "use_declaration" })
			end, optsWithDescription("tree surfer go to imports"))
			vim.keymap.set("n", "gf", function() -- only jump to functions
				sts.targeted_jump({
					"function",
					"arrrow_function",
					"function_definition",
					"enum_item",
					"struct_item",
					"impl_item",
					"function_item",
					"method_definition",
				})
				--> In this example, the Lua language schema uses "function",
				--  when the Python language uses "function_definition"
				--  we include both, so this keymap will work on both languages
			end, optsWithDescription("tree surfer - go to function"))
			vim.keymap.set("n", "gj", function() -- jump to all that you specify
				sts.targeted_jump({
					"function",
					"arrow_function",
					"function_definition",
					"arguments",
					"function_item",
					"impl_item",
					"struct_item",
					"enum_item",
					"parameters",
					"parameter",
					"method_definition",
					"formal_parameters",
				})
			end, optsWithDescription("tree surfer go to interesting places"))

			-------------------------------
			-- filtered_jump --
			-- "default" means that you jump to the default_desired_types or your lastest jump types
			vim.keymap.set("n", "<A-n>", function()
				sts.filtered_jump("default", true) --> true means jump forward
			end, opts)
			vim.keymap.set("n", "<A-p>", function()
				sts.filtered_jump("default", false) --> false means jump backwards
			end, opts)

			-------------------------------
			-- filtered_jump --
			-- "default" means that you jump to the default_desired_types or your lastest jump types
			vim.keymap.set("n", "<A-n>", function()
				sts.filtered_jump("default", true) --> true means jump forward
			end, opts)
			vim.keymap.set("n", "<A-p>", function()
				sts.filtered_jump("default", false) --> false means jump backwards
			end, opts)

			-------------------------------
			-- Setup Function example:
			-- These are the default options:
			require("syntax-tree-surfer").setup({
				highlight_group = "STS_highlight",
				disable_no_instance_found_report = false,
				default_desired_types = {
					"function",
					"arrow_function",
					"function_definition",
					"arguments",
					"function_item",
					"impl_item",
					"struct_item",
					"enum_item",
					"parameters",
					"parameter",
				},
				left_hand_side = "fdsawervcxqtzb",
				right_hand_side = "jkl;oiu.,mpy/n",
				icon_dictionary = {
					["if_statement"] = "",
					["else_clause"] = "",
					["else_statement"] = "",
					["elseif_statement"] = "",
					["for_statement"] = "ﭜ",
					["while_statement"] = "ﯩ",
					["switch_statement"] = "ﳟ",
					["function"] = "",
					["function_definition"] = "",
					["variable_declaration"] = "",
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"nvim-treesitter/playground",
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		-- keys = {
		--   { "<c-up>", desc = "Incremental selection" },
		--   { "<bs>",   desc = "Decrement selection",  mode = "x" },
		-- },
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			context_commentstring = { enable = true, enable_autocmd = false },
			ensure_installed = {
				"bash",
				"c",
				"html",
				"javascript",
				"json",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
				"rust",
				"clojure",
        "svelte", 
				"kotlin",
			},
			-- incremental_selection = {
			--   enable = true,
			--   keymaps = {
			--     init_selection = "<C-up>",
			--     node_incremental = "<C-up>",
			--     scope_incremental = false,
			--     node_decremental = "<c-down>",
			--   },
			-- },
		},
		---@param opts TSConfig
		config = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				---@type table<string, boolean>
				local added = {}
				opts.ensure_installed = vim.tbl_filter(function(lang)
					if added[lang] then
						return false
					end
					added[lang] = true
					return true
				end, opts.ensure_installed)
			end
			opts.playground = {
				enable = true,
			}
			require("nvim-treesitter.install").compilers = { "gcc" }
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		-- {
		--   "nvim-treesitter/nvim-treesitter-textobjects",
		--   event = "VeryLazy",
		--   enabled = true,
		--   opts = function()
		--     return {
		--       textobjects = {
		--         move = {
		--           enable = true,
		--           set_jumpts = true,
		--           goto_next_start = {
		--             ["[m"] = "@function.outer",
		--             ["[s"] = "@scope",
		--           },
		--           goto_next_end = {
		--             ["]m"] = "@function.outer",
		--             ["]s"] = "@scope",
		--           }
		--         },
		--         select = {
		--           enable = true,
		--
		--           -- Automatically jump forward to textobj, similar to targets.vim
		--           lookahead = true,
		--
		--           keymaps = {
		--             -- You can use the capture groups defined in textobjects.scm
		--             ["af"] = "@function.outer",
		--             ["if"] = "@function.inner",
		--             ["ac"] = "@class.outer",
		--             -- You can optionally set descriptions to the mappings (used in the desc parameter of
		--             -- nvim_buf_set_keymap) which plugins like which-key display
		--             ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
		--           },
		--           -- You can choose the select mode (default is charwise 'v')
		--           --
		--           -- Can also be a function which gets passed a table with the keys
		--           -- * query_string: eg '@function.inner'
		--           -- * method: eg 'v' or 'o'
		--           -- and should return the mode ('v', 'V', or '<c-v>') or a table
		--           -- mapping query_strings to modes.
		--           selection_modes = {
		--             ["@parameter.outer"] = "v", -- charwise
		--             ["@function.outer"] = "V", -- linewise
		--             ["@class.outer"] = "<c-v>", -- blockwise
		--           },
		--           -- If you set this to `true` (default is `false`) then any textobject is
		--           -- extended to include preceding or succeeding whitespace. Succeeding
		--           -- whitespace has priority in order to act similarly to eg the built-in
		--           -- `ap`.
		--           --
		--           -- Can also be a function which gets passed a table with the keys
		--           -- * query_string: eg '@function.inner'
		--           -- * selection_mode: eg 'v'
		--           -- and should return true of false
		--           include_surrounding_whitespace = true,
		--         },
		--       },
		--     }
		--   end,
		--
		--   config = function(_, opts)
		--     require("nvim-treesitter.configs").setup(opts)
		--   end,
		-- },
	},
}

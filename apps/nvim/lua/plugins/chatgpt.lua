return {
	{
		"frankroeder/parrot.nvim",
		dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim" },
		config = function()
			require("parrot").setup({
				providers = {
					anthropic = {
						api_key = vim.fn.system("age -d -i ~/.ssh/id_rsa ~/.config/nvim/antrophic.age"),
					},
				},
				hooks = {
					Explain = function(prt, params)
						local template = [[
	       Your task is to take the code snippet from {{filename}} and explain it with gradually increasing complexity.
	       Break down the code's functionality, purpose, and key components.
	       The goal is to help the reader understand what the code does and how it works.

	       ```{{filetype}}
	       {{selection}}
	       ```

	       Use the markdown format with codeblocks and inline code.
	       Explanation of the code above:
	       ]]
						local model = prt.get_model("command")
						prt.logger.info("Explaining selection with model: " .. model.name)
						prt.Prompt(params, prt.ui.Target.new, model, nil, template)
					end,

					UnitTests = function(prt, params)
						local template = [[
	       I have the following code from {{filename}}:

	       ```{{filetype}}
	       {{selection}}
	       ```

	       Please respond by writing table driven unit tests for the code above.
	       ]]
						local model_obj = prt.get_model("command")
						prt.logger.info("Creating unit tests for selection with model: " .. model_obj.name)
						prt.Prompt(params, prt.ui.Target.enew, model_obj, nil, template)
					end,
					Complete = function(prt, params)
						local template = [[
	       I have the following code from {{filename}}:

	       ```{{filetype}}
	       {{selection}}
	       ```

	       Please finish the code above carefully and logically.
	       Respond just with the snippet of code that should be inserted."
	       ]]
						local model_obj = prt.get_model("command")
						prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
					end,
				},
			})
		end,

		keys = {
			{ "<leader>co", "<cmd>PrtChatNew<cr>", mode = { "n" }, desc = "New Chat" },
			{ "<leader>co", ":<C-u>'<,'>PrtChatNew<cr>", mode = { "v" }, desc = "Visual Chat New" },
			{ "<leader>cc", "<cmd>PrtChatToggle<cr>", mode = { "n", "v" }, desc = "Toggle Popup Chat" },
			{ "<leader>cf", "<cmd>PrtChatFinder<cr>", mode = { "n", "v" }, desc = "Chat Finder" },
			{ "<leader>cm", "<cmd>PrtModel<cr>", mode = { "n" }, desc = "Select model" },
		},
	},
	-- {
	-- 	{
	-- 		"olimorris/codecompanion.nvim",
	-- 		dependencies = {
	-- 			"nvim-lua/plenary.nvim",
	-- 			"nvim-treesitter/nvim-treesitter",
	-- 		},
	-- 		config = function()
	-- 			require("codecompanion").setup({
	-- 				display = {
	-- 					diff = {
	-- 						provider = "mini_diff",
	-- 					},
	-- 				},
	-- 				opts = {
	-- 					log_level = "DEBUG",
	-- 				},
	-- 				strategies = {
	-- 					chat = {
	-- 						adapter = "anthropic",
	-- 					},
	-- 					inline = {
	-- 						adapter = "anthropic",
	-- 					},
	-- 				},
	-- 				adapters = {
	-- 					anthropic = function()
	-- 						return require("codecompanion.adapters").extend("anthropic", {
	-- 							env = {
	-- 								api_key = "cmd:age -d -i ~/.ssh/id_rsa ~/.config/nvim/antrophic.age",
	-- 							},
	-- 						})
	-- 					end,
	-- 				},
	-- 			})
	-- 		end,
	-- 		keys = {
	-- 			{ "<leader>ca", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanionActions" },
	-- 			{ "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "CodeCompanionActions" },
	-- 			{ "<leader>cp", "<cmd>CodeCompanionChat Add<cr>", mode = { "n", "v" }, desc = "CodeCompanionActions" },
	-- 		},
	-- 	},
	-- },
	-- {
	-- 	"yetone/avante.nvim",
	-- 	event = "VeryLazy",
	-- 	lazy = false,
	-- 	version = false, -- set this if you want to always pull the latest change
	--
	-- 	opts = {
	-- 		provider = "claude",
	-- 		claude = {
	-- 			api_key_name = "cmd:age -d -i /home/kozko/.ssh/id_rsa /home/kozko/.config/nvim/antrophic.age",
	-- 		},
	-- 		-- recommended settings
	-- 		default = {
	-- 			embed_image_as_base64 = false,
	-- 			prompt_for_file_name = false,
	-- 			drag_and_drop = {
	-- 				insert_mode = true,
	-- 			},
	-- 			-- required for Windows users
	-- 			use_absolute_path = true,
	-- 		},
	-- 	},
	-- 	cmd = {
	-- 		"AvanteAsk",
	-- 		"AvanteChat",
	-- 		"AvanteEdit",
	-- 		"AvanteToggle",
	-- 		"AvanteClear",
	-- 		"AvanteFocus",
	-- 		"AvanteRefresh",
	-- 		"AvanteSwitchProvider",
	-- 	},
	-- 	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	-- 	build = "make",
	-- 	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	-- 	dependencies = {
	-- 		"stevearc/dressing.nvim",
	-- 		"nvim-lua/plenary.nvim",
	-- 		"MunifTanjim/nui.nvim",
	-- 		--- The below dependencies are optional,
	-- 		"echasnovski/mini.icons",
	-- 		{
	-- 			-- support for image pasting
	-- 			"HakonHarnes/img-clip.nvim",
	-- 			event = "VeryLazy",
	-- 		},
	-- 	},
	-- },
}

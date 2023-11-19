return {
	"robitx/gp.nvim",
	event = "VeryLazy",
	config = function()
		require("gp").setup({
			openai_api_key = vim.fn.system("age -d -i ~/.ssh/id_rsa ~/.config/nvim/openai.age"),
			chat_model = { model = "gpt-4-1106-preview", temperature = 1.1, top_p = 1 },
			command_model = { model = "gpt-4-1106-preview", temperature = 1.1, top_p = 1 },
			hooks = {
				-- example of adding a custom chat command with non-default parameters
				-- (configured default might be gpt-3 and sometimes you might want to use gpt-4)
				BetterChatNew = function(gp, params)
					local chat_model = { model = "gpt-4-1106-preview", temperature = 0.7, top_p = 1 }
					local chat_system_prompt = "You are a general AI assistant."
					gp.cmd.ChatNew(params, chat_model, chat_system_prompt)
				end,

				-- example of adding command which writes unit tests for the selected code
				UnitTests = function(gp, params)
					local template = "I have the following code from {{filename}}:\n\n"
						.. "```{{filetype}}\n{{selection}}\n```\n\n"
						.. "Please respond by writing table driven unit tests for the code above."
					gp.Prompt(
						params,
						gp.Target.enew,
						nil,
						gp.config.command_model,
						template,
						gp.config.command_system_prompt
					)
				end,

				-- example of adding command which explains the selected code
				Explain = function(gp, params)
					local template = "I have the following code from {{filename}}:\n\n"
						.. "```{{filetype}}\n{{selection}}\n```\n\n"
						.. "Please respond by explaining the code above."
					gp.Prompt(
						params,
						gp.Target.popup,
						nil,
						gp.config.command_model,
						template,
						gp.config.chat_system_prompt
					)
				end,
			},
		})

		-- `GpExplain` explain the selection
		-- `<leader> cc` toggle chat
		-- `<leader> co` open other chat
		-- `<leader> cn` create a new chat
		-- `GpImplement` implements the code, based on the visual selection and the comment in it
		-- Create a mapping by adding the following line after your setup
		vim.api.nvim_set_keymap("n", "<leader>cc", ":GpChatToggle<CR>", { noremap = true, silent = true })

		vim.api.nvim_set_keymap("n", "<leader>co", ":GpChatFinder<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<leader>cn", ":GpBetterChatNew popup<CR>", { noremap = true, silent = true })
	end,
}

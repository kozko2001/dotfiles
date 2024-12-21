return {
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
		{ "<leader>co", "<cmd>PrtChatNew<cr>", mode = { "n", "i" }, desc = "New Chat" },
		{ "<leader>co", ":<C-u>'<,'>PrtChatNew<cr>", mode = { "v" }, desc = "Visual Chat New" },
		{ "<leader>cc", "<cmd>PrtChatToggle<cr>", mode = { "n", "i", "v" }, desc = "Toggle Popup Chat" },
		{ "<leader>cf", "<cmd>PrtChatFinder<cr>", mode = { "n", "i", "v" }, desc = "Chat Finder" },
		{ "<leader>cm", "<cmd>PrtModel<cr>", mode = { "n" }, desc = "Select model" },
	},
}

-- Fuzzy finder (find files / live grep / buffers). Requires the external
-- `fzf` and `ripgrep` binaries — see README.md.
require("fzf-lua").setup({
  winopts = { preview = { border = "rounded" } },
})

local map = vim.keymap.set
map("n", "<leader>ff", function() require("fzf-lua").files() end, { desc = "Find files" })
map("n", "<leader>fg", function() require("fzf-lua").live_grep() end, { desc = "Find in files (grep)" })
map("n", "<leader>fb", function() require("fzf-lua").buffers() end, { desc = "Find buffer" })
map("n", "<leader>fh", function() require("fzf-lua").help_tags() end, { desc = "Find help" })

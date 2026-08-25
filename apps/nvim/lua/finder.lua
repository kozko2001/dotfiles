-- Fuzzy finder (find files / live grep / buffers). Requires the external
-- `fzf` and `ripgrep` binaries — see README.md.
require("fzf-lua").setup({
  winopts = { preview = { border = "rounded" } },
})
-- Route vim.ui.select through fzf-lua: code actions (<F4>), z= spell
-- suggestions, etc. get the fuzzy UI instead of a numbered list.
require("fzf-lua").register_ui_select()

local map = vim.keymap.set
map("n", "<leader>ff", function() require("fzf-lua").files() end, { desc = "Find files" })
map("n", "<leader>fg", function() require("fzf-lua").live_grep() end, { desc = "Find in files (grep)" })
map("n", "<leader>fb", function() require("fzf-lua").buffers() end, { desc = "Find buffer" })
map("n", "<leader>fh", function() require("fzf-lua").help_tags() end, { desc = "Find help" })
map("n", "<leader>fr", function() require("fzf-lua").resume() end, { desc = "Resume last picker" })
map("n", "<leader>fo", function() require("fzf-lua").oldfiles() end, { desc = "Find recent file" })
map("n", "<leader>fw", function() require("fzf-lua").grep_cword() end, { desc = "Grep word under cursor" })
map("n", "<leader>fd", function() require("fzf-lua").diagnostics_document() end, { desc = "Find buffer diagnostic" })
map("n", "<leader>fD", function() require("fzf-lua").diagnostics_workspace() end, { desc = "Find workspace diagnostic" })
map("n", "<leader>fs", function() require("fzf-lua").lsp_document_symbols() end, { desc = "Find document symbol" })
map("n", "<leader>fS", function() require("fzf-lua").lsp_workspace_symbols() end, { desc = "Find workspace symbol" })
map("n", "<leader>fk", function() require("fzf-lua").keymaps() end, { desc = "Find keymap" })
map("n", "<leader>fm", function() require("fzf-lua").marks() end, { desc = "Find mark" })
map("n", '<leader>f"', function() require("fzf-lua").registers() end, { desc = "Find register" })
map("n", "<leader>ft", function() require("fzf-lua").grep({ search = "TODO|FIXME|HACK" }) end, { desc = "Find TODO/FIXME/HACK" })

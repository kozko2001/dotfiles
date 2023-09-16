vim.g.mapleader = " "
vim.g.localleader = ","
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.api.nvim_set_keymap('n', '[b', ':bp<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', ']b', ':bn<CR>', {noremap = true})

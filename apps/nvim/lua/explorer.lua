-- Directory-as-buffer file manager (vim-vinegar style: "-" opens the
-- parent directory of the current file; edit it as text and :wq to apply).
require("oil").setup({
  view_options = { show_hidden = true },
})

vim.keymap.set("n", "-", function() require("oil").open() end, { desc = "Open parent directory" })

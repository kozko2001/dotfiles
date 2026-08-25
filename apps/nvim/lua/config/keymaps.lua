local map = vim.keymap.set

-- window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
-- ...also straight out of terminal mode
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Go to left window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Go to lower window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Go to upper window" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Go to right window" })

-- window resize
map("n", "<M-h>", "2<C-w><", { desc = "Resize window narrower" })
map("n", "<M-l>", "2<C-w>>", { desc = "Resize window wider" })
map("n", "<M-j>", "2<C-w>-", { desc = "Resize window shorter" })
map("n", "<M-k>", "2<C-w>+", { desc = "Resize window taller" })

-- tab navigation (mini.bracketed has no tabpage target)
map("n", "]t", "gt", { desc = "Next tab" })
map("n", "[t", "gT", { desc = "Prev tab" })
map("n", "]T", "<cmd>tablast<cr>", { desc = "Last tab" })
map("n", "[T", "<cmd>tabfirst<cr>", { desc = "First tab" })

-- quickfix
map("n", "<leader>qq", function()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 and win.loclist == 0 then
      vim.api.nvim_win_close(win.winid, false)
      return
    end
  end
  vim.cmd("copen")
end, { desc = "Toggle quickfix window" })

-- move selected lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- keep cursor centered on half-page jumps and search
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- terminal: double-Esc leaves terminal mode (single Esc still passes through)
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- diagnostics: any diagnostic
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev diagnostic" })

-- diagnostics: errors only
map("n", "]e", function()
  vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next error" })
map("n", "[e", function()
  vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Prev error" })

map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- spell (auto-on in markdown; z= suggests fixes through fzf-lua)
map("n", "<leader>us", function() vim.wo.spell = not vim.wo.spell end, { desc = "Toggle spell" })

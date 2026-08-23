-- Highlight yanked text briefly.
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = vim.api.nvim_create_augroup("config-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Format on save via the attached LSP client (if it supports formatting).
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Format buffer with LSP on save",

  group = vim.api.nvim_create_augroup("config-format-on-save", { clear = true }),
  callback = function(args)
    vim.lsp.buf.format({ bufnr = args.buf, async = false, timeout_ms = 2000 })
  end,
})

-- Restore cursor to last known position when reopening a file.
vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Restore last cursor position",
  group = vim.api.nvim_create_augroup("config-restore-cursor", { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

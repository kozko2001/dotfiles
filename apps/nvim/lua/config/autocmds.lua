-- Highlight yanked text briefly.
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = vim.api.nvim_create_augroup("config-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Format on save via the attached LSP client (if it supports formatting).
-- Disable globally with :let g:disable_autoformat = 1 or per buffer with
-- :let b:disable_autoformat = 1 (e.g. from a project .nvim.lua).
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Format buffer with LSP on save",

  group = vim.api.nvim_create_augroup("config-format-on-save", { clear = true }),
  callback = function(args)
    if vim.g.disable_autoformat or vim.b[args.buf].disable_autoformat then
      return
    end
    local clients = vim.lsp.get_clients({ bufnr = args.buf, method = "textDocument/formatting" })
    if #clients == 0 then
      return
    end
    vim.lsp.buf.format({ bufnr = args.buf, async = false, timeout_ms = 2000 })
  end,
})

-- Markdown: soft-wrap, spell check, conceal markup markers (`` ` ``, `**`,
-- etc. — where the treesitter conceal query supports it; markers stay
-- visible in insert mode via the default concealcursor).
vim.api.nvim_create_autocmd("FileType", {
  desc = "Markdown buffer options",
  group = vim.api.nvim_create_augroup("config-markdown", { clear = true }),
  pattern = "markdown",
  callback = function(args)
    vim.bo[args.buf].textwidth = 0
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.wo.spell = true
    vim.wo.conceallevel = 2
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

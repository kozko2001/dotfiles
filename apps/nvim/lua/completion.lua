-- Native completion (Neovim 0.11+): LSP-driven autotriggered popup plus
-- built-in buffer-word completion as a fallback/complement. No blink.cmp.
--
-- <C-n> / <C-p>  built-in buffer-word completion (always available)
-- <C-x><C-o>     omnifunc (LSP) completion on demand
-- typing         LSP completion pops up automatically once attached
-- <C-y>          accept selected item
-- <C-e>          abort completion

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Enable native LSP completion",
  group = vim.api.nvim_create_augroup("config-lsp-completion", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})

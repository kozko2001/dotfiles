-- Native LSP setup (Neovim 0.11+ vim.lsp.config / vim.lsp.enable).
-- No nvim-lspconfig, no mason: install the language server binaries
-- yourself (see README.md) and make sure they are on $PATH.

vim.diagnostic.config({
  virtual_text = { severity_sort = true, source = "if_many" },
  severity_sort = true,
  underline = true,
  float = { border = "rounded", source = "if_many" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
})

-- This Neovim build ships the vim.lsp.config/vim.lsp.enable *mechanism*
-- but no pre-filled server definitions (no $VIMRUNTIME/lsp/*.lua) — unlike
-- some newer builds/distros. So every server needs a full cmd/filetypes/
-- root_markers definition here, not just a settings override.

vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = { vim.env.VIMRUNTIME },
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
})

vim.lsp.config("ruff", {
  -- ruff implements its own LSP: gives Python lint diagnostics + formatting
  -- without a separate lint/format plugin. Runs alongside pyright.
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  init_options = {
    settings = { organizeImports = true },
  },
})

vim.lsp.config("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" },
  root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
})

vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
})

vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", ".git" },
  settings = {
    ["rust-analyzer"] = {
      check = { command = "clippy" },
    },
  },
})

vim.lsp.config("zls", {
  cmd = { "zls" },
  filetypes = { "zig", "zir" },
  root_markers = { "build.zig", "zls.json", ".git" },
})

vim.lsp.enable({
  "lua_ls",
  "pyright",
  "ruff",
  "ts_ls",
  "gopls",
  "rust_analyzer",
  "zls",
})

local function on_attach(client, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
  map("n", "go", vim.lsp.buf.type_definition, "Go to type definition")
  map("n", "gr", vim.lsp.buf.references, "References")
  map("n", "gs", vim.lsp.buf.signature_help, "Signature help")
  map("n", "K", vim.lsp.buf.hover, "Hover")

  map("n", "<F2>", vim.lsp.buf.rename, "Rename")
  map("n", "<F3>", function() vim.lsp.buf.format({ async = false }) end, "Format")
  map({ "n", "v" }, "<F4>", vim.lsp.buf.code_action, "Code action")

  if client:supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Configure buffer on LSP attach",
  group = vim.api.nvim_create_augroup("config-lsp-attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      on_attach(client, args.buf)
    end
  end,
})

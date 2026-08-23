-- Visual indicator for available LSP code actions at the cursor: shows a
-- 💡 sign in the sign column, native (no nvim-lightbulb plugin).

local ns = vim.api.nvim_create_namespace("config-lightbulb")

local function clear(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

local function update(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/codeAction" })
  if #clients == 0 then
    clear(bufnr)
    return
  end

  local win = vim.api.nvim_get_current_win()
  local line = vim.api.nvim_win_get_cursor(win)[1] - 1
  local params = vim.lsp.util.make_range_params(win, "utf-8")

  -- vim.diagnostic.get() returns Neovim's internal diagnostic shape
  -- (lnum/col/end_lnum/end_col); the actual LSP diagnostic object (with a
  -- proper `range`) is stashed in .user_data.lsp — servers expect that shape.
  local lsp_diagnostics = {}
  for _, d in ipairs(vim.diagnostic.get(bufnr, { lnum = line })) do
    if d.user_data and d.user_data.lsp then
      lsp_diagnostics[#lsp_diagnostics + 1] = d.user_data.lsp
    end
  end
  -- Exclude "source.*" kinds (organize imports, fix-all, etc): those are
  -- whole-file actions servers offer unconditionally at every cursor
  -- position, not something specific to this line — including them makes
  -- the lightbulb light up everywhere and stop meaning anything.
  params.context = { diagnostics = lsp_diagnostics, only = { "quickfix", "refactor" } }

  -- buf_request invokes the handler once per attached client (e.g. both
  -- pyright and ruff for Python) — wait for all of them before deciding,
  -- otherwise a later empty response from one client wipes an earlier
  -- non-empty one from another.
  local pending = #clients
  local found = false
  vim.lsp.buf_request(bufnr, "textDocument/codeAction", params, function(_, result)
    pending = pending - 1
    for _, action in ipairs(result or {}) do
      -- defensive: not every server honors context.only
      local kind = action.kind or ""
      if kind:sub(1, 6) ~= "source" then
        found = true
        break
      end
    end
    if pending <= 0 then
      clear(bufnr)
      if found then
        vim.api.nvim_buf_set_extmark(bufnr, ns, line, 0, {
          sign_text = "💡",
          sign_hl_group = "DiagnosticSignWarn",
          priority = 20,
        })
      end
    end
  end)
end

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  desc = "Show a sign when an LSP code action is available at the cursor",
  group = vim.api.nvim_create_augroup("config-lightbulb", { clear = true }),
  callback = function(args)
    update(args.buf)
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  group = "config-lightbulb",
  callback = function(args)
    clear(args.buf)
  end,
})

-- mini.nvim used as a library (echasnovski/mini.nvim): one plugin, several
-- small modules. Deliberately not used: mini.surround, mini.sessions.

require("mini.pairs").setup()
require("mini.bufremove").setup()

-- Statusline: mode, git branch, diagnostics count, filename, attached LSP
-- client, fileinfo, location (patterned after mini.statusline's default).
local statusline = require("mini.statusline")
statusline.setup({
  content = {
    active = function()
      local mode = statusline.section_mode
      local git, diagnostics = statusline.section_git, statusline.section_diagnostics
      local filename = statusline.section_filename
      local fileinfo, location = statusline.section_fileinfo, statusline.section_location

      local clients = vim.lsp.get_clients({ bufnr = 0 })
      local lsp = clients[1] and clients[1].name or ""

      return statusline.combine_groups({
        { hl = "MiniStatuslineMode", strings = { mode } },
        { hl = "MiniStatuslineModeExtra", strings = { git, diagnostics } },
        "%<",
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=",
        { hl = "MiniStatuslineFileinfo", strings = { lsp } },
        { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
        { hl = "MiniStatuslineNormal", strings = { location } },
      })
    end,
  },
})

-- Unimpaired-style ]x / [x navigation. Only targets that don't clash with
-- the textobject maps (]f function, ]c class, ]a argument) or the
-- diagnostic maps (]d / ]e) are enabled; an empty suffix disables a target.
require("mini.bracketed").setup({
  buffer = { suffix = "b" },
  indent = { suffix = "i" },
  location = { suffix = "l" }, -- location list
  oldfile = { suffix = "o" },
  quickfix = { suffix = "q" },
  window = { suffix = "w" },
  comment = { suffix = "" },
  conflict = { suffix = "" },
  diagnostic = { suffix = "" },
  file = { suffix = "" },
  jump = { suffix = "" },
  treesitter = { suffix = "" }, -- frees ]t / [t for tab navigation
  undo = { suffix = "" },
  yank = { suffix = "" },
})

-- Delete the current buffer without destroying the window layout.
local map = vim.keymap.set
map("n", "<leader>bd", function()
  if not require("mini.bufremove").delete(nil, false) then
    vim.notify("Buffer is modified; use <leader>bD to force", vim.log.levels.WARN)
  end
end, { desc = "Delete buffer (keep window)" })
map("n", "<leader>bD", function()
  require("mini.bufremove").delete(nil, true)
end, { desc = "Wipe buffer (force)" })

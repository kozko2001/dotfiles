local ensure_installed = {
  "bash", "json", "markdown", "markdown_inline", "query", "vim", "vimdoc",
  "python", "typescript", "tsx", "javascript",
  "lua", "go", "gomod", "gowork", "gosum", "zig", "rust",
}

require("nvim-treesitter").install(ensure_installed)

vim.api.nvim_create_autocmd("FileType", {
  desc = "Start treesitter highlighting/indent",
  group = vim.api.nvim_create_augroup("config-treesitter-start", { clear = true }),
  callback = function()
    local ok = pcall(vim.treesitter.start)
    if ok then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

require("nvim-treesitter-textobjects").setup({
  select = {
    lookahead = true,
    include_surrounding_whitespace = false,
  },
  move = {
    set_jumps = true,
  },
})

local select = require("nvim-treesitter-textobjects.select")
local move = require("nvim-treesitter-textobjects.move")
local map = vim.keymap.set

-- select: function / class / argument
map({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end, { desc = "inner function" })
map({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end, { desc = "around function" })
map({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end, { desc = "inner class" })
map({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end, { desc = "around class" })
map({ "x", "o" }, "ia", function() select.select_textobject("@parameter.inner", "textobjects") end, { desc = "inner argument" })
map({ "x", "o" }, "aa", function() select.select_textobject("@parameter.outer", "textobjects") end, { desc = "around argument" })

-- move: next/prev function, class, argument
map({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "Next function" })
map({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Prev function" })
map({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end, { desc = "Next class" })
map({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end, { desc = "Prev class" })
map({ "n", "x", "o" }, "]a", function() move.goto_next_start("@parameter.inner", "textobjects") end, { desc = "Next argument" })
map({ "n", "x", "o" }, "[a", function() move.goto_previous_start("@parameter.inner", "textobjects") end, { desc = "Prev argument" })

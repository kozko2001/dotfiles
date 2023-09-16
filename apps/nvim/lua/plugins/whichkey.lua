return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  enabled = false,
  opts = {
    plugins = { spelling = true },
    defaults = {
      mode = { "n", "v" },
      ["]"] = { name = "+next" },
      ["["] = { name = "+prev" },
      ["<leader>f"] = { name = "+file/find" },
      ["<leader>g"] = { name = "+git" },
      ["<leader>s"] = { name = "+search" },
      ["<leader>x"] = { name = "+diagnostics/quickfix" },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.register(opts.defaults)
  end,
}

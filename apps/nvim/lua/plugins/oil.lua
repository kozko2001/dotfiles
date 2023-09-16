return {
  'stevearc/oil.nvim',
  opts = {},
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "-", function ()
      require("oil").open()
    end, desc = "open parent dir" },
  },
  config = function ()
    require("oil").setup()
  end
}

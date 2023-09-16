return {
  { 'freddiehaddad/feline.nvim',
  event = "VeryLazy",
  dependencies = { { "nvim-tree/nvim-web-devicons"}},
  config = function ()
    require("feline").setup()
  end
  }
}

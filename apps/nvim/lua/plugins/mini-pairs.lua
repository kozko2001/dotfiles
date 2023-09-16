return {
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    enabled = false,
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },
  {
    'altermo/ultimate-autopair.nvim',
    event={'InsertEnter','CmdlineEnter'},
    enabled =false,
    commit="667d230",
    opts={
        --Config goes here
    },
  }
}

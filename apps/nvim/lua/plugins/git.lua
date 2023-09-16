return {
  'TimUntersberger/neogit',
  keys = {
    { "<leader>gc", function() require("neogit").open({"commit"}) end,  desc = "Commit in neogit" },
    { "<leader>gg", function() require("neogit").open() end,      desc = "Open neogit",  mode = { "n"} },
  },
  config = function ()
    require("neogit").setup()
  end
}

return {
  "ziontee113/icon-picker.nvim",
  dependencies = {
    { "stevearc/dressing.nvim"}
  },
  keys = {
    { "<C-e>",  "<Cmd>IconPickerInsert<CR>",desc = "Decrement selection",  mode = "i" },
  },
  config = function ()
    require("icon-picker").setup({
      disable_legacy_commands = true
    })
  end
}

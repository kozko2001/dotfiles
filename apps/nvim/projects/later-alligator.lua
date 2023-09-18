print("loading read-alligator configuration")


local term = require("user.terminal")
vim.keymap.set("n", "<LocalLeader>t", function () term.toggle("cd backend; direnv exec . npm run test") end, {noremap = true, silent = true})

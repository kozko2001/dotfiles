-- Obsidian vault support via obsidian.nvim (community fork).
-- Vault root is PersonalNotes/ (the .obsidian/ config dir lives there).
-- Plugin defaults in note buffers: <CR> smart-follows links / toggles
-- checkboxes, [o / ]o jump between links.
require("obsidian").setup({
  legacy_commands = false, -- use `:Obsidian <sub>` form
  workspaces = {
    { name = "notes", path = "~/personal-notes/PersonalNotes" },
  },
  picker = { name = "fzf-lua" },

  -- Name new notes by their title ("Machine - Seal.md"), not zettel IDs.
  note_id_func = function(title)
    if title and title ~= "" then
      return title
    end
    return os.date("%Y%m%d%H%M")
  end,

  -- The vault doesn't use YAML frontmatter; don't inject it into new notes.
  frontmatter = { enabled = false },

  -- Daily notes: vault root, YYYY-MM-DD.md, matching Obsidian's defaults.
  daily_notes = {
    folder = nil,
    date_format = "YYYY-MM-DD",
    default_tags = {},
  },

  -- Off: the footer's scheduled extmark rewrite on each note open triggers
  -- "E315: Invalid lnum" in mini.statusline. Verified headless: with the
  -- footer off there are no errors. Its status counts go with it.
  footer = { enabled = false },
})

local map = vim.keymap.set
map("n", "<leader>nn", "<cmd>Obsidian quick_switch<cr>", { desc = "Notes: quick switch" })
map("n", "<leader>ns", "<cmd>Obsidian search<cr>", { desc = "Notes: search vault" })
map("n", "<leader>nt", "<cmd>Obsidian today<cr>", { desc = "Notes: today's daily note" })
map("n", "<leader>nb", "<cmd>Obsidian backlinks<cr>", { desc = "Notes: backlinks" })
map("n", "<leader>nl", "<cmd>Obsidian links<cr>", { desc = "Notes: links in this note" })
map("n", "<leader>nr", "<cmd>Obsidian rename<cr>", { desc = "Notes: rename (updates links)" })
map("n", "<leader>no", "<cmd>Obsidian open<cr>", { desc = "Notes: open in Obsidian app" })

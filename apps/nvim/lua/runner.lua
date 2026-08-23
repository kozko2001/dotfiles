-- Run tests/lint for the current file's project, tmux-aware.
--
-- Per-project overrides (via a `.nvim.lua` at the project root, loaded
-- through 'exrc'):
--   vim.b.test_cmd = "pytest -k foo"
--   vim.b.lint_cmd = "ruff check ."
-- or set them globally for every buffer of a filetype:
--   vim.g.test_cmd_python = "pytest -k foo"

local M = {}

local commands = {
  python = { test = "pytest", lint = "ruff check ." },
  go = { test = "go test ./...", lint = "golangci-lint run" },
  rust = { test = "cargo test", lint = "cargo clippy" },
  typescript = { test = "npm test", lint = "eslint ." },
  typescriptreact = { test = "npm test", lint = "eslint ." },
  javascript = { test = "npm test", lint = "eslint ." },
  javascriptreact = { test = "npm test", lint = "eslint ." },
  zig = { test = "zig build test", lint = "zig build" },
  lua = { test = "busted", lint = "luacheck ." },
}

local function resolve(kind)
  local buf_var = kind .. "_cmd"
  local ok, val = pcall(vim.api.nvim_buf_get_var, 0, buf_var)
  if ok and val then
    return val
  end

  local ft = vim.bo.filetype
  local global_var = kind .. "_cmd_" .. ft
  if vim.g[global_var] then
    return vim.g[global_var]
  end

  local entry = commands[ft]
  return entry and entry[kind] or nil
end

local function run(cmd)
  if os.getenv("TMUX") then
    vim.system({ "tmux", "split-window", "-v", "-c", vim.fn.getcwd(), cmd })
    return
  end

  vim.cmd("botright split | terminal " .. vim.fn.shellescape(cmd))
  vim.cmd("startinsert")
end

function M.test()
  local cmd = resolve("test")
  if not cmd then
    vim.notify("No test command for filetype '" .. vim.bo.filetype .. "'", vim.log.levels.WARN)
    return
  end
  run(cmd)
end

function M.lint()
  local cmd = resolve("lint")
  if not cmd then
    vim.notify("No lint command for filetype '" .. vim.bo.filetype .. "'", vim.log.levels.WARN)
    return
  end
  run(cmd)
end

vim.keymap.set("n", "<leader>tt", M.test, { desc = "Run tests" })
vim.keymap.set("n", "<leader>tl", M.lint, { desc = "Run lint" })

return M

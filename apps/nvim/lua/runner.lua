-- Run tests/lint for the current file's project, tmux-aware.
--
-- Per-project overrides (via a `.nvim.lua` at the project root, loaded
-- through 'exrc'):
--   vim.b.test_cmd = "pytest -k foo"
--   vim.b.test_file_cmd = "pytest {file} -k foo"
--   vim.b.lint_cmd = "ruff check ."
-- or set them globally for every buffer of a filetype:
--   vim.g.test_cmd_python = "pytest -k foo"
--
-- Inside tmux a single runner pane is reused: the first run opens a split
-- below the current pane, later runs send C-c + the new command to it (the
-- pane is recreated if it was closed).

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

-- `{file}` templates for "run only the tests of the current file". Other
-- filetypes fall back to the project-wide test command.
local file_commands = {
  python = "pytest {file}",
}

local runner_pane = nil

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

-- Expand a `{file}` template for the current buffer (nil if unavailable).
local function resolve_file()
  local ok, tmpl = pcall(vim.api.nvim_buf_get_var, 0, "test_file_cmd")
  if not ok or not tmpl then
    local ft = vim.bo.filetype
    if vim.g["test_file_cmd_" .. ft] then
      tmpl = vim.g["test_file_cmd_" .. ft]
    else
      tmpl = file_commands[ft]
    end
  end
  if not tmpl then
    return nil
  end

  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return nil -- unnamed buffer
  end
  return (tmpl:gsub("{file}", vim.fn.shellescape(vim.fn.fnamemodify(file, ":."))))
end

local function tmux_pane_alive(pane)
  return vim.system({ "tmux", "has-session", "-t", pane }):wait().code == 0
end

local function run(cmd)
  if os.getenv("TMUX") then
    if runner_pane and tmux_pane_alive(runner_pane) then
      vim.system({ "tmux", "send-keys", "-t", runner_pane, "C-c", cmd, "Enter" })
      return
    end
    local out = vim.system({
      "tmux", "split-window", "-v", "-c", vim.fn.getcwd(), "-P", "-F", "#{pane_id}",
    }):wait()
    local pane = out.code == 0 and out.stdout and out.stdout:gsub("%s+", "")
    if not pane or pane == "" then
      vim.notify("tmux split-window failed: " .. (out.stderr or ""), vim.log.levels.ERROR)
      return
    end
    runner_pane = pane
    vim.system({ "tmux", "send-keys", "-t", runner_pane, cmd, "Enter" })
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

function M.test_file()
  local cmd = resolve_file() or resolve("test")
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
vim.keymap.set("n", "<leader>tf", M.test_file, { desc = "Run tests for current file" })
vim.keymap.set("n", "<leader>tl", M.lint, { desc = "Run lint" })

return M

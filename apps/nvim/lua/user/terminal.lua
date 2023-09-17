local M = {}

M.debug = function (message, data)
  if M.config.debug then
    print(message)
    if data ~= nil then
      print(vim.inspect(data))
    end
  end
end

M.buffers = {}

M.default_opts = {
  frameSize = function ()
    local win_width = vim.fn.winwidth(0)
    local win_height = vim.fn.winheight(0)

    -- Calculate the width and height for the floating window
    local width = math.ceil(win_width * 0.33) - 4
    local height = math.ceil(win_height * 0.9)

    -- Calculate the position to center the floating window
    local row = math.ceil((win_height - height) / 2 - 1)
    local col = win_width - width

    return {
      width = width,
      height = height,
      row = row,
      col = col,
    }
  end,
  debug = false
}

M.create_terminal = function(program, name)
  local buf = vim.api.nvim_create_buf(true, true)
  local bufname = name or program

  M.buffers[bufname] = buf

  -- Set the buffer's options
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'hide')
  local frame = M.config.frameSize()

  -- Create the floating window with the specified dimensions and position
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = frame.row,
    col = frame.col,
    width = frame.width,
    height = frame.height,
    style = "minimal"
  })

  -- Start the terminal in the buffer with the specified command
  vim.fn.termopen(program)
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true, nowait = true })
end

M.toggle = function(program, name)
  local bufname = name or program
  local buf_id = M.buffers[bufname]

  local cur_win = vim.api.nvim_get_current_win()
  local cur_buf = vim.api.nvim_win_get_buf(cur_win)

  -- 1. If the buffer id passed is in focus, close the buffer
  if cur_buf == buf_id then
    vim.api.nvim_command('bdelete! ' .. buf_id)
    return
  end

  -- 2. If the buffer id is visible right now, focus on the window
  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    if vim.api.nvim_win_get_buf(win) == buf_id then
      vim.api.nvim_set_current_win(win)
      return
    end
  end

  M.create_terminal(program, name)
end

M.setup = function (opts)
  M.config = vim.tbl_deep_extend("force", M.default_opts, opts)
end

return M

local M = {}

M.debug = function(message, data)
	if M.config.debug then
		print(message)
		if data ~= nil then
			print(vim.inspect(data))
		end
	end
end

local function find_ancestor_directory(start_path, target)
	local path = start_path
	while path ~= "" and path ~= "/" do
		if vim.fn.isdirectory(path .. "/" .. target) == 1 then
			return path
		end
		path = vim.fn.fnamemodify(path, ":h")
	end
	return nil
end

M.config = {
	debug = false,
	folder = vim.fn.stdpath("config") .. "/projects",
}

M.on_dir_changed = function(info)
	-- M.debug("on_dir_changed", info)
	--
	-- local cwd = vim.fn.getcwd()
	-- M.debug("cwd", cwd)
	--
	-- local root_path = find_ancestor_directory(cwd, ".git")
	-- M.debug("root_path", root_path)
	-- if not root_path then
	--   M.debug("no root_path found... not doing anything...")
	--   return
	-- end
	--
	-- local fnamemodify = vim.fn.fnamemodify
	-- local dir_name = fnamemodify(root_path, ':t')
	-- M.debug("project_name", dir_name)
	--
	-- local configPath = M.config.folder .. "/" .. dir_name .. ".lua"
	-- M.debug("configPath ", configPath)
	--
	-- if vim.fn.filereadable(configPath) == 1 then
	--   M.debug("file found... we should load it!!", dir_name)
	--   vim.cmd("luafile " .. configPath)
	-- else
	--   M.debug("configuration for project not found...", dir_name)
	-- end
end

M.setup = function(options)
	M.config = vim.tbl_deep_extend("force", M.config, options)

	local augroup = vim.api.nvim_create_augroup("ProjectConfigLoader", {
		clear = false,
	})

	vim.api.nvim_create_autocmd({ "DirChanged", "VimEnter" }, {
		group = augroup,
		desc = "load custom configuration for projects",
		callback = M.on_dir_changed,
		nested = true,
		pattern = "*",
	})
end

return M

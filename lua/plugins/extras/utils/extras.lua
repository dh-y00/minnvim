local M = {}
function M.find_project_root(start_dir, patterns)
	local current_dir = start_dir or vim.fn.expand("%:p:h")
	local home_dir = vim.fn.expand("$HOME")
	while true do
		-- 检查当前目录是否包含任何模式文件
		for _, pattern in ipairs(patterns) do
			local file = current_dir .. "/" .. pattern
			if vim.fn.filereadable(file) == 1 or vim.fn.isdirectory(file) == 1 then
				return current_dir
			end
		end
		-- 如果到达 home 目录或根目录，停止搜索
		if current_dir == home_dir or current_dir == "/" then
			break
		end
		-- 向上移动一级目录
		current_dir = vim.fn.fnamemodify(current_dir, ":h")
	end
	return nil
end

function M.wants(opts)
	opts = opts or {}
	local buf = opts.buf or vim.api.nvim_get_current_buf()
	-- 检查文件类型
	if opts.ft then
		local filetypes = type(opts.ft) == "string" and { opts.ft } or opts.ft
		local current_ft = vim.api.nvim_buf_get_option(buf, "filetype")

		for _, ft in ipairs(filetypes) do
			if current_ft == ft then
				return true
			end
		end
	end
	-- 检查项目根目录
	if opts.root then
		local patterns = type(opts.root) == "string" and { opts.root } or opts.root
		local start_dir = vim.api.nvim_buf_get_name(buf)
		start_dir = start_dir ~= "" and vim.fn.fnamemodify(start_dir, ":h") or vim.fn.getcwd()
		local root_dir = M.find_project_root(start_dir, patterns)
		return root_dir ~= nil
	end
	return false
end

return M

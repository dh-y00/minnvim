local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
	return vim.api.nvim_create_augroup("yy_" .. name, { clear = true })
end

-- 保存时自动格式化
autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

-- 进入文件时光标回到上次的位置
autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
			vim.cmd("normal! g'\"")
		end
	end,
})
-- 修复json文件的conceallevel
autocmd({ "FileType" }, {
	group = augroup("json_conceal"),
	pattern = { "json", "jsonc", "json5" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

-- 检查文本文件类型中的拼写
autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- 调整分割线，如果窗口大小改变
autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- 检查文件是否更改后需要重新加载
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

return {
	{
		-- 窗口编号
		"s1n7ax/nvim-window-picker",
		opt = {
			filter_rules = {
				include_current_win = true,
				bo = {
					filetype = { "fidget", "neo-tree" },
				},
			},
		},
		config = function(_, opt)
			require("window-picker").setup(opt)
			vim.keymap.set("n", "<c-w>p", function()
				local window_number = require("window-picker").pick_window()
				if window_number then
					vim.api.nvim_set_current_win(window_number)
				end
			end)
		end,
		keys = {
			{ "<c-w>p", desc = "show current window number" },
		},
	},
	{
		-- =双引号 大括号等自动补全
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		-- 选中文本增加双引号和大括号
		-- 用符号包裹
		-- ysiw{包裹使用的符号}
		-- ys{motion}{包裹使用的符号} eg: ys2w{
		-- 删除包裹的符号
		-- ds{包裹使用的符号}
		-- 修改包裹的符号
		-- cs{包裹使用的符号}
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts = {},
	},
	{
		-- 打开一个边栏，类似于 vscode 左边的侧边栏
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			actions = {
				open_file = {
					-- 打开选中文件后关闭
					quit_on_open = true,
				},
			},
		},
		keys = {
			{ "<leader>uf", ":NvimTreeToggle<CR>", desc = "打开左侧侧边栏" },
		},
	},
}

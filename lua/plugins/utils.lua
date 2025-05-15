return {
	{
		-- 不通过 esc 从 i 模式到 n 模式
		"max397574/better-escape.nvim",
		opts = {
			default_mappings = false,
			mappings = {
				-- i for insert
				i = {
					j = {
						-- These can all also be functions
						k = "<Esc>",
						j = false,
					},
				},
				c = {
					j = {
						-- 在 command 模式下快速结束
						k = "<C-c>",
						j = false,
					},
				},
				t = {
					j = {
						-- T 模式（Terminal Mode） 是一种特殊模式，用于在 Neovim 内部运行终端会话（如 bash、zsh 等）。通过 T 模式，你可以在编辑器内执行命令、运行程序，而无需切换到外部终端。
						k = "<C-\\><C-n>",
					},
				},
				v = {
					j = {
						k = false,
					},
				},
				s = {
					j = {
						k = "<Esc>",
					},
				},
			},
		},
		config = function(_, opts)
			require("better_escape").setup(opts)
		end,
	},
	{
		-- 上下 光标移动加速的插件
		"rhysd/accelerated-jk",
		config = function()
			vim.keymap.set("n", "j", "<Plug>(accelerated_jk_gj)")
			vim.keymap.set("n", "k", "<Plug>(accelerated_jk_gk)")
		end,
		keys = {
			{ "j", desc = "【光标】向下越来越快" },
			{ "k", desc = "【光标】向上越来越快" },
		},
	},
	{
		-- 自动保存 session
		"folke/persistence.nvim",
		-- 这只有在实际文件被打开时才会开始会话保存
		event = "BufReadPre",
		config = function()
			require("persistence").setup()
			-- 加载当前目录的会话
			vim.keymap.set(
				"n",
				"<leader>sel",
				[[<cmd>lua require("persistence").load()<cr>]],
				{ desc = "加载当前目录的会话" }
			)
			-- 加载最后一次会话
			vim.keymap.set(
				"n",
				"<leader>seL",
				[[<cmd>lua require("persistence").load({ last = true})<cr>]],
				{ desc = "加载最后一次会话" }
			)
			-- 暂停会话保存在退出的时候
			vim.keymap.set(
				"n",
				"<leader>ses",
				[[<cmd>lua require("persistence").stop()<cr>]],
				{ desc = "暂停会话保存在退出的时候" }
			)
			-- 选择一个会话
			vim.keymap.set("n", "<leader>seS", function()
				require("persistence").select()
			end, { desc = "选择一个会话" })
		end,
		keys = {
			{ "<leader>sel" },
			{ "<leader>seL" },
			{ "<leader>ses" },
			{ "<leader>seS" },
		},
	},
	{
		-- 检查拼写错误
		"kamykn/spelunker.vim",
		event = "VeryLazy",
		config = function()
			vim.g.spelunker_check_type = 2
		end,
	},
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
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			-- "ahmedkhalf/project.nvim",
		},
		opts = {
			actions = {
				open_file = {
					-- 打开选中文件后关闭
					quit_on_open = true,
				},
			},
			sync_root_with_cwd = true,
			respect_buf_cwd = true,
			update_focused_file = {
				enable = true,
				update_root = true,
			},
		},
		config = function(_, opts)
			-- require("project_nvim").setup()
			require("nvim-tree").setup(opts)
		end,
		keys = {
			{ "<leader>uf", ":NvimTreeToggle<CR>", desc = "打开左侧侧边栏" },
		},
	},
}

return {
	{
		--
		"HiPhish/rainbow-delimiters.nvim",
		submodules = false,
		main = "rainbow-delimiters.setup",
		opts = {},
	},
	{
		-- good message notify and alert menu
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		opts = {},
	},
	{
		-- 这边可以先了解一下 vim 中的 bufferline 是什么
		-- 而这个插件就是深化，加强 vim 原有中的 bufferline
		"akinsho/bufferline.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			options = {
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(_, _, diagnostics_dict, _)
					local indicator = " "
					for level, number in pairs(diagnostics_dict) do
						local symbol
						if level == "error" then
							symbol = " "
						elseif level == "warning" then
							symbol = " "
						else
							symbol = " "
						end
						indicator = indicator .. number .. symbol
					end
					return indicator
				end,
			},
		},
		keys = {
			{ "<leader>bb", ":BufferLineCyclePrev<CR>", silent = true },
			{ "<leader>bn", ":BufferLineCycleNext<CR>", silent = true },
			{ "<leader>bch", ":BufferLinePick<CR>", silent = true },
			{ "<leader>bd", ":bdelete<CR>", silent = true },
			{ "<leader>bco", ":BufferLineCloseOthers<CR>", silent = true },
			{ "<leader>bcl", ":BufferLineClose<CR>", silent = true },
		},
		lazy = false,
	},
	{
		-- 显示列对其竖线的, 比如上下大括号的竖线便是这个插件的效果
		"lukas-reineke/indent-blankline.nvim",
		event = "VeryLazy",
		main = "ibl",
		opts = {},
	},
	{
		-- git 最左侧数字左侧的会通过不同线的颜色区分当前行是新增修改还是不变
		"lewis6991/gitsigns.nvim",
		config = true,
	},
	{
		-- 构造一个类似于 ide 一样的开始界面, 通过直接在终端敲【nvim】进入
		"goolord/alpha-nvim",
		config = function()
			require("alpha").setup(require("alpha.themes.dashboard").config)
		end,
	},
}

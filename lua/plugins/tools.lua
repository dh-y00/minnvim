-- 小工具 不是必要的，但是可以做一些其他事情
return {
	--  {
	--  	-- 类似于 postman 之类的，快速发起 http 请求
	--  	"rest-nvim/rest.nvim",
	--  	dependencies = {
	--  		"nvim-treesitter/nvim-treesitter",
	--  		opts = function(_, opts)
	--  			opts.ensure_installed = opts.ensure_installed or {}
	--  			table.insert(opts.ensure_installed, "http")
	--  		end,
	--  	},
	--  },
	{
		-- 在 nvim 里面打开终端
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.3
				end
				return 20
			end,
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)
			local mapOpts = { buffer = 0 }
			vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], mapOpts)
			vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], mapOpts)
			vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], mapOpts)
			vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], mapOpts)
			vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], mapOpts)
			vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], mapOpts)
		end,
		keys = {
			{ "<leader>tot", ":ToggleTerm direction=tab<CR>", desc = "新起一个tab打开 term", silent = true },
			{
				"<leader>tof",
				":ToggleTerm direction=float<CR>",
				desc = "新起一个悬浮窗打开 term",
				silent = true,
			},
			{
				"<leader>tov",
				":ToggleTerm direction=vertical<CR>",
				desc = "左侧打开 term",
				silent = true,
			},
			{ "<leader>toh", ":ToggleTerm direction=horizontal<CR>", desc = "下面打开 term", silent = true },
		},
	},
}

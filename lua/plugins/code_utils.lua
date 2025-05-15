return {
	{
		-- 快速注释
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		config = function(_, opts)
			require("Comment").setup(opts)
		end,
	},
	{
		-- 快速跳转到 todo 标签
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"]td",
				function()
					require("todo_comments").jump_next()
				end,
				desc = "Next todo comment",
			},
			{
				"[td",
				function()
					require("todo_comments").jump_prev()
				end,
				desc = "Previous todo comment",
			},
			-- to error warning 跳转到对应的msg处
			{
				"]tew",
				function()
					require("todo_comments").jump_next({ keywords = { "ERROR", "WARNING" } })
				end,
				desc = "Next error/warning todo comment",
			},
		},
	},
	{
		-- 把代码内容解析为抽象语法树 方便很多工具解析代码
		"nvim-treesitter/nvim-treesitter",
		main = "nvim-treesitter.configs",
		event = "VeryLazy",
		opts = {
			ensure_installed = { "lua", "python", "json", "typescript", "java", "css", "html" },
			highlight = { enable = true },
		},
	},
	{

		-- 代码提示工具
		"saghen/blink.cmp",
		version = "*",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		event = "VeryLazy",
		opts = {
			completion = {
				documentation = {
					auto_show = true,
				},
			},
			keymap = {
				preset = "super-tab",
			},
			sources = {
				default = { "path", "snippets", "buffer", "lsp" },
			},
			cmdline = {
				sources = function()
					local cmd_type = vim.fn.getcmdtype()
					if cmd_type == "/" or cmd_type == "?" then
						return { "buffer" }
					end
					if cmd_type == ":" then
						return { "cmdline" }
					end
					return {}
				end,
				keymap = {
					preset = "super-tab",
				},
				completion = {
					menu = {
						auto_show = true,
					},
				},
			},
		},
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		event = "VeryLazy",
		config = function()
			local registry = require("mason-registry")
			local function install(name)
				local success, package = pcall(registry.get_package, name)
				if success and not package:is_installed() then
					package:install()
				end
			end
			install("stylua")
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
				},
			})
		end,
		keys = {
			{
				"<leader>cf",
				function()
					vim.lsp.buf.format()
				end,
				desc = "代码格式化",
			},
		},
	},
}

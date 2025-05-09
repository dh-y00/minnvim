return {
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
				"<leader>lf",
				function()
					vim.lsp.buf.format()
				end,
			},
		},
	},
}

return {
	{
		-- 右下角 相关 lsp 加载过程显示
		"j-hui/fidget.nvim",
		tag = "v1.6.1",
		opts = {
			-- Options related to LSP progress subsystem
		},
	},
	{
		"mason-org/mason.nvim",
		event = "VeryLazy",
		version = "^1.0.0",
		dependencies = {
			"neovim/nvim-lspconfig",
			{

				"mason-org/mason-lspconfig.nvim",
				version = "^1.0.0",
			},
			"j-hui/fidget.nvim",
		},
		opts = {},
		config = function(_, opts)
			local servers = {
				["lua-language-server"] = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				},
				pyright = {},
				-- basedpyright = {},
				-- ["ruff-lsp"] = {},
				["html-lsp"] = {},
				["css-lsp"] = {},
				["typescript-language-server"] = {},
				["emmet-ls"] = {},
			}
			require("fidget").setup()
			require("mason").setup(opts)
			local registry = require("mason-registry")
			local function setup(name, config)
				local success, package = pcall(registry.get_package, name)
				if success and not package:is_installed() then
					package:install()
				end
				local lsp = require("mason-lspconfig.mappings.server").package_to_lspconfig[name]
				-- local lsp = require("mason-lspconfig").get_mappings().lspconfig_to_package[name]
				config.capabilities = require("blink.cmp").get_lsp_capabilities()
				config.on_attach = function(client)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end
				require("lspconfig")[lsp].setup(config)
			end
			for server, config in pairs(servers) do
				setup(server, config)
			end
			vim.cmd("LspStart")
			vim.diagnostic.config({
				underline = true,
				virtual_text = true,
				-- virtual_lines = true,
				virtual_lines = { current_line = true },
				current_line = true,
				update_in_insert = true,
			})
		end,
	},
	{
		-- 在代码过程中增加 变量重命名，跳转，调用查看等等相关功能
		"nvimdev/lspsaga.nvim",
		cmd = "Lspsaga",
		opts = {
			finder = {
				keys = {
					toggle_or_open = "<CR>",
				},
			},
			layout = "float",
			ui = {
				title = true,
				border = "single",
				code_action = "💡",
				expand = "⊞",
				collapse = "⊟",
				actionfix = " ",
				lines = { "┗", "┣", "┃", "━", "┏" },
				imp_sign = "󰳛 ",
				incoming = " ",
				outgoing = " ",
				hover = " ",
			},
			symbol_in_winbar = {
				enable = true,
				separator = " › ",
				-- when true some symbols like if and for
				hide_keyword = false,
				color_mode = true,
				delay = 300,
				show_file = true,
				folder_level = 2,
				respect_root = false,
			},
		},
		keys = {
			{ "<leader>lr", ":Lspsaga rename<CR>", desc = "变量重新命名" },
			{
				"<leader>lc",
				":Lspsaga code_action<CR>",
				desc = "代码一些优化操作",
				{ num_shortcut = true, show_server_name = false, extend_gitsigns = false },
			},
			{ "<leader>lD", ":Lspsaga definition<CR>", desc = "浮窗显示代码定义信息" },
			-- TIPS 代码相关信息
			{ "<leader>lh", ":Lspsaga hover_doc<CR>", desc = "代码 TIPS 悬浮显示" },
			{ "<leader>ld", ":Lspsaga finder def<CR>", desc = "查到定义情况" },
			{ "<leader>lr", ":Lspsaga finder ref<CR>", desc = "查找调用情况" },
			{ "<leader>li", ":Lspsaga finder imp<CR>", desc = "查找实现情况" },
			{ "<leader>ln", ":Lspsaga diagnostic_jump_next<CR>", desc = "跳转到下一个警告/错误" },
			{ "<leader>lp", ":Lspsaga diagnostic_jump_prev<CR>", desc = "跳转到上一个警告/错误" },
		},
	},
}

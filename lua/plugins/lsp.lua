return {
	{
		"williamboman/mason.nvim",
		event = "VeryLazy",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason-lspconfig.nvim",
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
				["html-lsp"] = {},
				["css-lsp"] = {},
				["typescript-language-server"] = {},
				["emmet-ls"] = {},
			}
			-- require("fidget").setup()
			require("mason").setup(opts)
			local registry = require("mason-registry")
			local function setup(name, config)
				local success, package = pcall(registry.get_package, name)
				if success and not package:is_installed() then
					package:install()
				end
				local lsp = require("mason-lspconfig.mappings.server").package_to_lspconfig[name]
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
		},
		keys = {
			{ "<leader>lr", ":Lspsaga rename<CR>", desc = "Rename Variable" },
			{ "<leader>lc", ":Lspsaga code_action<CR>" },
			{ "<leader>ld", ":Lspsaga definition<CR>" },
			{ "<leader>lh", ":Lspsaga hover_doc<CR>" },
			{ "<leader>lR", ":Lspsaga finder<CR>" },
			{ "<leader>ln", ":Lspsaga diagnostic_jump_next<CR>" },
			{ "<leader>lp", ":Lspsaga diagnostic_jump_prev<CR>" },
		},
	},
	{
		-- 右下角 相关 lsp 加载过程显示
		"j-hui/fidget.nvim",
		tag = "v1.6.1",
		opts = {},
	},
}

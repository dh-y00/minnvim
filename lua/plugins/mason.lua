return {
	"williamboman/mason.nvim",
	event = "VeryLazy",
	dependencies = {
		"neovim/nvim-lspconfig",
		"williamboman/mason-lspconfig.nvim",
	},
	opts = {},
	config = function(_, opts)
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
}

local extras_utils = require("plugins.extras.utils.extras")
return {
	recommended = function()
		return extras_utils.wants({
			ft = "python",
			root = {
				"pyproject.toml",
				"setup.py",
				"setup.cfg",
				"requirements.txt",
				"Pipfile",
				"pyrightconfig.json",
			},
		})
	end,
	{
		-- python 环境选择
		"linux-cultist/venv-selector.nvim",
		dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
		cmd = "VenvSelect",
		enable = true,
		opts = {
			-- Your options go here
			-- name = "venv",
			-- auto_refresh = false
			anaconda_base_path = "/Volumes/hz/SoftData/miniAnaconda/miniconda3",
			anaconda_envs_path = "/Volumes/hz/SoftData/miniAnaconda/miniconda3/envs",
			search_workspace = true,
			search_venv_managers = true,
			settings = {
				options = {
					notify_user_on_venv_activation = true,
				},
			},
			stay_on_this_version = true,
		},
		ft = "python",
		-- event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
		keys = {
			-- 快捷键打开VenvSelector以选择一个虚拟环境。
			{ "<leader>vs", "<cmd>VenvSelect<cr>" },
			-- 快捷键用于从缓存中检索venv（之前用于相同项目目录的那个）。
			{ "<leader>vc", "<cmd>VenvSelectCached<cr>" },
		},
		config = function(_, opts)
			require("venv-selector").setup(opts)
			vim.api.nvim_create_autocmd("VimEnter", {
				desc = "Auto select virtualenv Nvim open",
				pattern = "*",
				callback = function()
					local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
					local req_venv = vim.fn.findfile("requirements.txt", vim.fn.getcwd() .. ";")
					if venv ~= "" or req_venv ~= "" then
						require("venv-selector").retrieve_from_cache()
					end
				end,
				once = true,
			})
		end,
	},
	{
		"kmontocam/nvim-conda",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	-- {
	-- 	-- simple python dap
	-- 	"mfussenegger/nvim-dap-python",
	-- 	opts = {},
	-- 	config = true,
	-- },
}

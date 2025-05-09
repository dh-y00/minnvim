return {
	{

		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && "
					.. "cmake --build build --config Release && "
					.. "cmake --install build --prefix build",
			},
		},
		cmd = "Telescope",
		opts = {
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		},
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)
			telescope.load_extension("fzf")
			vim.keymap.set("n", "<leader>/", function()
				require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })
		end,
		keys = {
			{ "<leader>ff", ":Telescope find_files<CR>", silent = true, desc = "Find file in current project" },
			{ "<leader>fg", ":Telescope live_grep<CR>", silent = true, desc = "Find str in current project" },
			{ "<leader>fb", ":Telescope buffers<CR>", silent = true },
			{ "<leader>fh", ":Telescope help_tags<CR>", silent = true },
			{ "<leader>fo", ":Telescope oldfiles<CR>", silent = true, desc = "[o] Find recently opened files" },
			{ "<leader>/", desc = "[/] Fuzzily search in current buffer" },
		},
	},
	{
		"smoka7/hop.nvim",
		opts = {},
		keys = {
			{ "<leader>hp", ":HopWord<CR>", silent = true, desc = "全文快速跳转" },
		},
	},
	{
		-- 全局的替换
		"MagicDuck/grug-far.nvim",
		cmd = "GrugFar",
		opts = {},
		keys = {
			-- 译为 seek global
			{ "<leader>sg", ":GrugFar<CR>", silent = true, desc = "全局查找替换" },
		},
	},
}

return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		opts = {
			menu = {
				width = vim.api.nvim_win_get_width(0) - 4,
			},
			settings = {
				save_on_toggle = true,
			},
		},
		keys = function()
			local keys = {
				{
					"<leader>H",
					function()
						require("harpoon"):list():add()
					end,
					desc = "Harpoon File",
				},
				{
					"<leader>h",
					function()
						local harpoon = require("harpoon")
						harpoon.ui:toggle_quick_menu(harpoon:list())
					end,
					desc = "Harpoon Quick Menu",
				},
			}

			for i = 1, 5 do
				table.insert(keys, {
					"<leader>" .. i,
					function()
						require("harpoon"):list():select(i)
					end,
					desc = "Harpoon to File " .. i,
				})
			end
			return keys
		end,
	},
	{
		"ahmedkhalf/project.nvim",
		opts = {
			-- 项目保存位置
			datapath = vim.fn.stdpath("data"),
			-- 检测项目的方法
			detection_methods = { "pattern", "lsp" },
			-- 用于识别项目根目录的文件/文件夹
			patterns = {
				".git",
				"package.json",
				"Makefile",
				"_darcs",
				".hg",
				".bzr",
				".svn",
				"pom.xml",
				"requirements.txt",
			},
			-- 忽略特定路径
			ignore_lsp = false,
			exclude_dirs = {},
			-- 手动添加项目
			manual_mode = false,
			-- 打开项目时的行为
			silent_chdir = true,
			scope_chdir = "global",
			-- 展示最近项目的数量
			show_hidden = false,
			-- 排序方式
			order_by = "recent",
			search_by = "title",
		},
		config = function(_, opts)
			require("project_nvim").setup(opts)
		end,
	},
	-- {
	-- 	"nvim-telescope/telescope-project.nvim",
	-- 	dependencies = {
	-- 		"nvim-telescope/telescope.nvim",
	-- 	},
	-- 	opts = {
	-- 		datapath = vim.fn.stdpath("data") .. "/nvim_project",
	-- 		detection_methods = { "pattern", "lsp" },
	-- 		patterns = { ".git", "package.json", "Makefile", "pom.xml", "requirements.txt", "package.json", "Makefile" },
	-- 		-- 忽略特定路径
	-- 		ignore_lsp = false,
	-- 		exclude_dirs = {},
	--
	-- 		-- 手动添加项目
	-- 		manual_mode = false,
	--
	-- 		-- 打开项目时的行为
	-- 		silent_chdir = true,
	-- 		scope_chdir = "global",
	--
	-- 		-- 展示最近项目的数量
	-- 		show_hidden = false,
	--
	-- 		-- 排序方式
	-- 		order_by = "recent",
	-- 		search_by = "title",
	-- 	},
	-- 	config = function(_, opts)
	-- 		require("project_nvim").setup(opts)
	-- 	end,
	-- },
	{

		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"ThePrimeagen/harpoon",
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
				project = {
					base_dirs = {
						"~/src",
					},
					ignore_missing_dirs = true, -- default: false
					hidden_files = true, -- default: false
					theme = "dropdown",
					order_by = "asc",
					search_by = "title",
					sync_with_nvim_tree = true, -- default false
					-- default for on_project_selected = find project files
					on_project_selected = function(prompt_bufnr)
						-- Do anything you want in here. For example:
						require("telescope._extensions.projects.actions").change_working_directory(prompt_bufnr, false)
						-- require("harpoon.ui").nav_file(1)
					end,
				},
			},
		},
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)
			telescope.load_extension("fzf", "projects", "fidget")
			vim.keymap.set("n", "<leader>/", function()
				require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })
			vim.keymap.set(
				"n",
				"<leader>fpc",
				[[<Cmd>lua require('telescope').extensions.projects.projects({action = "add"})<CR>]],
				{ desc = "创建一个项目" }
			)
		end,
		keys = {
			{ "<leader>ff", ":Telescope find_files<CR>", silent = true, desc = "Find file in current project" },
			{ "<leader>fg", ":Telescope live_grep<CR>", silent = true, desc = "Find str in current project" },
			{ "<leader>fb", ":Telescope buffers<CR>", silent = true },
			-- { "<leader>fh", ":Telescope help_tags<CR>", silent = true },
			{ "<leader>fo", ":Telescope oldfiles<CR>", silent = true, desc = "[o] Find recently opened files" },
			{
				"<leader>fps",
				":lua require'telescope'.extensions.projects.projects{display_type = 'full'}<CR>",
				silent = true,
				desc = "[P] 选择一个项目",
			},
			{
				"<leader>fpc",
			},
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

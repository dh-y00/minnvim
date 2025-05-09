return {
	-- kuaijiejian
	{
		"meznaric/key-analyzer.nvim",
		opts = {},
	},
	{
		"folke/which-key.nvim",
		dependencies = {
			"echasnovski/mini.icons",
		},
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	--  {
	--  	"keaising/im-select.nvim",
	--  	opt = {},
	--  	config = function(_, opts)
	--  		require("im_select").setup(opts)
	--  	end,
	--  },
}

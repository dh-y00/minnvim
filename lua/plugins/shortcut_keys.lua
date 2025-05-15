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
	{
		-- 自动切换输入法，但是要 在电脑上装 im-select
		"keaising/im-select.nvim",
		opts = {
			default_im_select = "com.apple.keylayout.ABC",
			default_command = "im-select",
			set_default_events = { "VimEnter", "FocusGained", "InsertLeave", "CmdlineLeave" },
			set_previous_events = { "InsertEnter" },
			async_switch_im = true,
		},
		config = function(_, opts)
			require("im_select").setup(opts)
		end,
	},
}

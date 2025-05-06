return {
	"akinsho/bufferline.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		options = {
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(_, _, diagnostics_dict, _)
				local indicator = " "
				for level, number in pairs(diagnostics_dict) do
					local symbol
					if level == "error" then
						symbol = " "
					elseif level == "warning" then
						symbol = " "
					else
						symbol = " "
					end
					indicator = indicator .. number .. symbol
				end
				return indicator
			end,
		},
	},
	keys = {
		{ "<leader>bb", ":BufferLineCyclePrev<CR>", silent = true },
		{ "<leader>bn", ":BufferLineCycleNext<CR>", silent = true },
		{ "<leader>bch", ":BufferLinePick<CR>", silent = true },
		{ "<leader>bd", ":bdelete<CR>", silent = true },
		{ "<leader>bco", ":BufferLineCloseOthers<CR>", silent = true },
		{ "<leader>bcl", ":BufferLineClose<CR>", silent = true },
	},
	lazy = false,
}

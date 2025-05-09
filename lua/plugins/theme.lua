local colors = {
	bg = "#202328",
	fg = "#bbc2cf",
	yellow = "#ECBE7B",
	cyan = "#008080",
	darkblue = "#081633",
	green = "#98be65",
	orange = "#FF8800",
	violet = "#a9a1e1",
	magenta = "#c678dd",
	blue = "#51afef",
	red = "#ec5f67",
}
local function get_mode_color()
	-- Define a table mapping modes to their associated colors
	local mode_color = {
		n = colors.DARKBLUE,
		i = colors.VIOLET,
		v = colors.RED,
		["␖"] = colors.BLUE,
		V = colors.RED,
		c = colors.MAGENTA,
		no = colors.RED,
		s = colors.ORANGE,
		S = colors.ORANGE,
		["␓"] = colors.ORANGE,
		ic = colors.YELLOW,
		R = colors.ORANGE,
		Rv = colors.ORANGE,
		cv = colors.RED,
		ce = colors.RED,
		r = colors.CYAN,
		rm = colors.CYAN,
		["r?"] = colors.CYAN,
		["!"] = colors.RED,
		t = colors.RED,
	}
	-- Return the opposite color, or fallback to foreground color
	return mode_color[vim.fn.mode()]
end
local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}
local code_info = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	symbols = { error = " ", warn = " ", info = " " },
	diagnostics_color = {
		error = { fg = colors.red },
		warn = { fg = colors.yellow },
		info = { fg = colors.cyan },
	},
}
local down_lsp_info_show = {
	-- Lsp server name .
	function()
		local msg = "No Active Lsp"
		local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
		local clients = vim.lsp.get_clients()
		if next(clients) == nil then
			return msg
		end
		for _, client in ipairs(clients) do
			local filetypes = client.config.filetypes
			if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
				return client.name
			end
		end
		return msg
	end,
	icon = " LSP:",
	-- color = { fg = "#ffffff", gui =  },
}
local down_git_diff_info = {
	"diff",
	-- Is it me or the symbol for modified us really weird
	symbols = { added = " ", modified = "󰝤 ", removed = " " },
	diff_color = {
		added = { fg = colors.green },
		modified = { fg = colors.orange },
		removed = { fg = colors.red },
	},
	cond = conditions.hide_in_width,
}
local down_cwd_info = {
	function()
		return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	end,
	icon = " ",
	color = function()
		local virtual_env = vim.env.VIRTUAL_ENV
		if virtual_env then
			return {
				fg = get_mode_color(),
				gui = "bold,strikethrough",
			}
		else
			return {
				fg = get_mode_color(),
				gui = "bold",
			}
		end
	end,
}

local down_encoding_env_info = {
	function()
		if vim.bo.filetype == "python" then
			-- 获取 Python 环境信息
			if vim.env.VIRTUAL_ENV then
				local venv_name = vim.fn.fnamemodify(vim.env.VIRTUAL_ENV, ":t")
				return " " .. venv_name
			end

			-- 尝试从 pyenv 等工具获取环境
			local pyenv = vim.fn.system("pyenv version-name 2>/dev/null"):gsub("\n", "")
			if pyenv ~= "" then
				return " " .. pyenv
			end

			-- 默认 Python
			return " python"
		elseif vim.bo.filetype == "javascript" or vim.bo.filetype == "typescript" then
			-- 获取 Node 版本
			local node_version = vim.fn.system("node -v 2>/dev/null"):gsub("\n", "")
			return " " .. (node_version ~= "" and node_version or "node")
		end
		return ""
	end,
}

return {
	{
		"folke/tokyonight.nvim",
		opts = {
			style = "moon",
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd("colorscheme tokyonight")
		end,
	},
	{
		-- 底部导航栏
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = "VeryLazy",
		opts = {
			options = {
				theme = "tokyonight",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			extensions = { "nvim-tree" },
			sections = {
				lualine_b = {
					down_cwd_info,
					{ "branch" },
					down_git_diff_info,
				},
				lualine_c = {
					code_info,
				},
				lualine_x = {
					down_lsp_info_show,
					down_encoding_env_info,
					"filesize",
					"encoding",
					"filetype",
				},
			},
		},
	},
	{
		-- 顶部导航栏
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
		},
		opts = {
			theme = "tokyonight",
			-- configurations go here
		},
	},
}

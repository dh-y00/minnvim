---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
	local args = type(config.args) == "function" and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
	local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

	config = vim.deepcopy(config)
	---@cast args string[]
	config.args = function()
		local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str)) --[[@as string]]
		if config.type and config.type == "java" then
			---@diagnostic disable-next-line: return-type-mismatch
			return new_args
		end
		return require("dap.utils").splitstr(new_args)
	end
	return config
end
local get_dir_by_file = function(file_path)
	local cwd = vim.fn.getcwd()
	local nvim_dir = cwd .. "/.nvim/"
	local nvim_dir_stat = vim.loop.fs_stat(nvim_dir)
	if not nvim_dir_stat then
		local ok, err = vim.loop.fs_mkdir(nvim_dir, 493) -- 0755
		if not ok and err ~= "EEXIST" then
			vim.notify("创建 .nvim 目录失败: " .. err, vim.log.levels.ERROR)
			return
		end
	end
	local target_file = nvim_dir .. file_path
	return target_file
end
local dap_breakpoint_color = {
	breakpoint = {
		ctermbg = 0,
		fg = "#993939",
		bg = "#31353f",
	},
	logpoing = {
		ctermbg = 0,
		fg = "#61afef",
		bg = "#31353f",
	},
	stopped = {
		ctermbg = 0,
		fg = "#98c379",
		bg = "#31353f",
	},
}
local dap_breakpoint = {
	error = {
		text = "",
		texthl = "DapBreakpoint",
		linehl = "DapBreakpoint",
		numhl = "DapBreakpoint",
	},
	condition = {
		text = "ﳁ",
		texthl = "DapBreakpoint",
		linehl = "DapBreakpoint",
		numhl = "DapBreakpoint",
	},
	rejected = {
		text = "",
		texthl = "DapBreakpint",
		linehl = "DapBreakpoint",
		numhl = "DapBreakpoint",
	},
	logpoint = {
		text = "",
		texthl = "DapLogPoint",
		linehl = "DapLogPoint",
		numhl = "DapLogPoint",
	},
	stopped = {
		text = "",
		texthl = "DapStopped",
		linehl = "DapStopped",
		numhl = "DapStopped",
	},
}
return {
	{
		-- mason.nvim integration
		{
			"jay-babu/mason-nvim-dap.nvim",
			dependencies = {
				"mason.nvim",
				"mfussenegger/nvim-dap-python",
			},
			cmd = { "DapInstall", "DapUninstall" },
			opts = {
				-- Makes a best effort to setup the various debuggers with
				-- reasonable debug configurations
				automatic_installation = true,

				-- You can provide additional configuration to the handlers,
				-- see mason-nvim-dap README for more information
				handlers = {},

				-- You'll need to check that you have the required things installed
				-- online, please don't ask me how to install them :)
				ensure_installed = {
					-- Update this to ensure that you have the debuggers for the langs you want
					"python",
					"debugpy",
				},
			},
			-- mason-nvim-dap is loaded when nvim-dap loads
			config = function() end,
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "nvim-neotest/nvim-nio" },
        -- stylua: ignore
        keys = {
          { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
          { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
        },
		opts = {},
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup(opts)
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		opts = {},
		config = function()
			require("nvim-dap-virtual-text").setup()
		end,
	},
	{
		"mfussenegger/nvim-dap",
		recommended = true,
		desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-telescope/telescope-dap.nvim",
			-- virtual text for the debugger
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
			},
		},
         -- stylua: ignore
        keys = {
          { "<F5>", function() require 'telescope'.extensions.dap.configurations {} end, desc = "Run" },
          { "<F8>", function() require("dap").step_over() end, desc = "Step Over" },
          { "<F7>", function() require("dap").step_into() end, desc = "Step Into" },
          { "<shift><F8>", function() require("dap").step_out() end, desc = "Step Out" },
          { "<F9>", function() require("dap").continue() end, desc = "Step next" },
          -- { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Breakpoint" },
          -- { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
          -- 以上两个打断点的方式移交到Weissle/persistent-breakpoints.nvim
          { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
          { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
          -- { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
          { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
          { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
          { "<leader>ds", function() require("dap").session() end, desc = "Session" },
          { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
          { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
        },
		config = function()
			vim.api.nvim_set_hl(0, "DapBreakpoint", dap_breakpoint_color.breakpoint)
			vim.api.nvim_set_hl(0, "DapLogPoint", dap_breakpoint_color.logpoing)
			vim.api.nvim_set_hl(0, "DapStopped", dap_breakpoint_color.stopped)
			vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
			vim.fn.sign_define("DapBreakpointCondition", dap_breakpoint.condition)
			vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)
			vim.fn.sign_define("DapLogPoint", dap_breakpoint.logpoint)
			vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
		end,
	},
	{
		-- 持久化断点
		"Weissle/persistent-breakpoints.nvim",
		event = "BufReadPost",
		opts = {
			load_breakpoints_event = { "BufReadPost" },
			perf_record = false,
			-- save_dir = get_dir_by_file("nvim_checkpoints"),
			save_dir = vim.fn.stdpath("data") .. "/nvim_checkpoints",
		},
		keys = {
			{
				"<Leader>db",
				function()
					require("persistent-breakpoints.api").toggle_breakpoint()
				end,
				{ silent = true },
				desc = "Toggle Breakpoint",
			},
			{
				"<Leader>dc",
				function()
					require("persistent-breakpoints.api").clear_all_breakpoints()
				end,
				{ silent = true },
				desc = "Clear Breakpoints",
			},
			{
				"<Leader>dB",
				function()
					require("persistent-breakpoints.api").set_conditional_breakpoint()
				end,
				{ silent = true },
				desc = "Conditional Breakpoint",
			},
			-- {
			--     "<Leader>dL",
			--     function() require("persistent-breakpoints.api").set_log_point() end,
			--     { silent = true },
			--     desc = "set log point",
			-- },
		},
	},
}

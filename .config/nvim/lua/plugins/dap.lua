local dapui_open = false

return {
	"rcarriga/nvim-dap-ui",
	-- Need this for the highlights in config()
	lazy = false,
	dependencies = {
		{
			"mfussenegger/nvim-dap",
			lazy = false,
			keys = {
				{ '<leader>b', function() require('dap').toggle_breakpoint() end, desc = 'Dap: Toggle [b]reakpoint' },
				{ '<F2>',      function() require('dap').step_into() end,         desc = 'Dap: Step into' },
				{ '<F3>',      function() require('dap').step_over() end,         desc = 'Dap: Step over' },
				{ '<F4>',      function() require('dap').step_out() end,          desc = 'Dap: Step out' },
				{ '<F5>',      function() require('dap').step_back() end,         desc = 'Dap: Step back' },
				{ '<F12>',     function() require('dap').terminate() end,         desc = 'Dap: Close debugger' },
			},
			config = function()
				local dap = require('dap')
				local debuggers_dir = vim.fn.stdpath('config') .. '/lua/config/debuggers'

				for _, filename in ipairs(vim.fn.readdir(debuggers_dir)) do
					local file_name_without_extension = vim.split(filename, '.', { plain = true, trimempty = true })[1]
					local require_path = 'config.debuggers.' .. file_name_without_extension
					require(require_path).add_debugger(dap)
				end
			end
		},
		"nvim-neotest/nvim-nio",
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					'nvim-dap-ui'
				},
			},
		},
	},
	keys = {
		{
			'<F1>',
			function()
				local Dap, Dapui = require("dap"), require("dapui")
				if not dapui_open then
					if vim.bo.filetype == 'cpp' then
						vim.fn.system('cd ' .. vim.fn.getcwd() .. '/build && make')
					end
					Dapui.open()
					dapui_open = true
				end
				Dap.continue()
			end,
			desc = 'Dap: Start debugging/continue to next breakpoint'
		},
	},
	config = function()
		local Dap, Dapui = require("dap"), require("dapui")
		Dapui.setup()

		-- Close dapui automatically when debugging session terminates
		Dap.listeners.before.event_terminated.dapui_config = function()
			Dapui.close()
			dapui_open = false
		end
		--
		vim.api.nvim_set_hl(0, "red", { fg = "#FF0000" })
		vim.api.nvim_set_hl(0, "green", { fg = "#9ece6a" })
		vim.api.nvim_set_hl(0, "yellow", { fg = "#FFFF00" })
		vim.api.nvim_set_hl(0, "orange", { fg = "#f09000" })
		vim.fn.sign_define('DapBreakpoint',
			{ text = '⏺', texthl = 'red' })
		vim.fn.sign_define('DapStopped', { text = '→', texthl = 'green', linehl = 'text', numhl = 'green' })
	end
}

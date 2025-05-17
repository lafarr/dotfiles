Dapui_open = false

return {
	"rcarriga/nvim-dap-ui",
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
				local dap, dapui = require("dap"), require("dapui")
				if not Dapui_open then
					if vim.bo.filetype == 'cpp' then
						vim.fn.system('cd ' .. vim.fn.getcwd() .. '/build && make')
					end
					dapui.open()
					Dapui_open = true
				end
				dap.continue()
			end,
			desc = 'Dap: Start debugging/continue to next breakpoint'
		}
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")

		-- Call dapui.setup(), so we can just open without calling setup every time we run the debugger
		vim.api.nvim_create_autocmd('VimEnter', {
			desc = 'Setup dap-ui when entering opening vim',
			group = vim.api.nvim_create_augroup('dap-ui-setup', { clear = true }),
			callback = function()
				dapui.setup()
			end,
		})

		-- Close dapui automatically when debugging session terminates
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
			Dapui_open = false
		end
	end
}

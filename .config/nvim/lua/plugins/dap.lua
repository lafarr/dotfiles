return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		{
			"mfussenegger/nvim-dap",
			lazy = false,
			config = function()
				local dap = require('dap')

				local debuggers_dir = vim.fn.stdpath('config') .. '/lua/plugins/debuggers'

				for _, filename in ipairs(vim.fn.readdir(debuggers_dir)) do
					local file_name_without_extension = vim.split(filename, '.', { plain = true, trimempty = true })[1]
					local require_path = 'plugins.debuggers.' .. file_name_without_extension
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
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		local dapui_open = false

		-- Call dapui.setup(), so we can just open without calling setup every time we run the debugger
		vim.api.nvim_create_autocmd('VimEnter', {
			desc = 'Setup dap-ui when entering opening vim',
			group = vim.api.nvim_create_augroup('dap-ui-setup', { clear = true }),
			callback = function()
				require('dapui').setup()
			end,
		})

		-- Close dapui automatically when debugging session terminates
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
			dapui_open = false
		end

		vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Toggle [b]reakpoint' })
		vim.keymap.set('n', '<F1>', function()
			if not dapui_open then
				if vim.bo.filetype == 'cpp' then
					vim.fn.system('cd ' .. vim.fn.getcwd() .. '/build && make')
				end
				dapui.open()
				dapui_open = true
			end
			dap.continue()
		end, { desc = 'Dap: Start debugging/continue to next breakpoint' })
		vim.keymap.set('n', '<F2>', dap.step_into, { desc = 'Dap: Step into in debugger' })
		vim.keymap.set('n', '<F3>', dap.step_over, { desc = 'Dap: Step over in debugger' })
		vim.keymap.set('n', '<F4>', dap.step_out, { desc = 'Dap: Step out in debugger' })
		vim.keymap.set('n', '<F5>', dap.step_back, { desc = 'Dap: Step back in debugger' })
		vim.keymap.set('n', '<F12>', function()
			dap.terminate()
		end, { desc = 'Dap: Stop debugging & close ui' })
	end
}

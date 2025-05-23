local M = {}
M.add_debugger = function(dap)
	-- Don't need to add this for C++, can just define it here
	dap.adapters.codelldb = {
		type = 'server',
		port = 13000,
		executable = {
			command = os.getenv('HOME') .. '/repos/lldb/extension/adapter/codelldb',
			args = { "--port", 13000 }
		}
	}

	dap.configurations.c = {
		{
			name = "Launch file",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
			end,
			cwd = '${workspaceFolder}',
			stopOnEntry = false,
		},
	}
end
return M

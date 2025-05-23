local M = {}

M.add_debugger = function(dap)
	dap.adapters.python = function(cb, config)
		if config.request == 'attach' then
			local port = (config.connect or config).port
			local host = (config.connect or config).host or '127.0.0.1'
			cb({
				type = 'server',
				port = assert(port, '`connect.port` is required for a python `attach` configuration'),
				host = host,
				options = {
					source_filetype = 'python',
				},
			})
		else
			cb({
				type = 'executable',
				command = os.getenv('HOME') .. '/.virtualenvs/debug/bin/python3',
				args = { '-m', 'debugpy.adapter' },
				options = {
					source_filetype = 'python',
				},
			})
		end
	end

	dap.configurations.python = {
		{
			type = 'python',
			request = 'launch',
			name = "Launch file",
			program = "${file}",
			pythonPath = function()
				local cwd = vim.fn.getcwd()
				if vim.fn.executable(cwd .. '/venv/bin/python3') == 1 then
					return cwd .. '/venv/bin/python3'
				elseif vim.fn.executable(cwd .. '/.venv/bin/python3') == 1 then
					return cwd .. '/.venv/bin/python3'
				else
					return '/usr/bin/python3'
				end
			end,
		},
	}
	return dap
end

return M

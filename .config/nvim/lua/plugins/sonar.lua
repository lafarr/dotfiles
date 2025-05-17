return {
	url = 'https://gitlab.com/schrieveslaach/sonarlint.nvim',
	config = function()
		local path_to_analyzers = vim.fn.expand '$MASON/share/sonarlint-analyzers'
		if vim.fn.isdirectory(path_to_analyzers) == 1 then
			local success = vim.fn.mkdir(path_to_analyzers, "p")
			if not success then
				vim.notify('Could not create Mason directory', vim.log.levels.ERROR)
			end
		end
		require('sonarlint').setup {
			server = {
				cmd = {
					'sonarlint-language-server',
					'-stdio',
					'-analyzers',
					vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarpython.jar',
					vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarcfamily.jar.asc',
					vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarjs.jar',
					vim.fn.expand '$MASON/share/sonarlint-analyzers/sonargo.jar',
					vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarxml.jar',
					vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarhtml.jar',
				},
			},
			filetypes = {
				'javascript',
				'typescript',
				'javascriptreact',
				'typescriptreact',
				'c',
				'cpp',
				'java',
				'h',
				'hh',
				'hpp',
				'python',
				'html',
				'xml',
				'go',
			},
		}
	end,
}

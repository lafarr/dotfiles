return {
	'mfussenegger/nvim-lint',
	event = {
		'BufReadPre',
		'BufNewFile',
	},
	config = function()
		vim.env.ESLINT_D_PPID = vim.fn.getpid()

		local lint = require('lint')
		local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

		-- So we don't get the "undefined global vim" warnings
		local luacheck = require('lint').linters.luacheck
		luacheck.args = {
			'--globals',
			'vim'
		}

		local golang = require('lint').linters.golangcilint
		golang.args = {
			"run",
			"--output.json.path=stdout",
			"--show-stats=false",
			"--issues-exit-code",
			"0",
		}

		lint.linters_by_ft = {
			javascript = { 'eslint_d' },
			typescript = { 'eslint_d' },
			typescriptreact = { 'eslint_d' },
			javascriptreact = { 'eslint_d' },
			go = { 'golangcilint' },
			lua = { 'luac', 'luacheck' },
		}

		vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}

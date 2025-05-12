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

		local selene = require('lint').linters.selene
		selene.args = {
			"--config",
			"/home/james/.config/nvim/vim.yaml"
		}

		lint.linters_by_ft = {
			javascript = { 'eslint_d', 'jshint' },
			typescript = { 'eslint_d', 'jshint' },
			typescriptreact = { 'eslint_d', 'jshint' },
			javascriptreact = { 'eslint_d', 'jshint' },
			go = { 'golangcilint', 'revive' },
			lua = { 'luac', 'luacheck', 'selene' },
			zsh = { 'zsh', 'shellcheck' },
			sh = { 'bash', 'shellcheck' },
			html = { 'htmlhint' }
		}

		vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}

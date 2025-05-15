-- Reset cursor to skinny boy when we exit
vim.cmd(':au VimLeave * set guicursor=a:ver5')
vim.cmd('set nowrap')

vim.opt.number = true
vim.opt.relativenumber = true
vim.o.signcolumn = "yes"

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.pumheight = 10

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Enable break indent
vim.opt.breakindent = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true

-- Decrease update time
vim.opt.updatetime = 250

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.cmd('set nohlsearch')

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = false

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- TODO: Move this to config of dap
-- Debugging stuff
vim.api.nvim_set_hl(0, "red", { fg = "#FF0000" })
vim.api.nvim_set_hl(0, "green", { fg = "#9ece6a" })
vim.api.nvim_set_hl(0, "yellow", { fg = "#FFFF00" })
vim.api.nvim_set_hl(0, "orange", { fg = "#f09000" })
vim.fn.sign_define('DapBreakpoint', { text = '⏺', texthl = 'red', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition', {
	text = '•',
	texthl = 'blue',
	linehl = 'DapBreakpoint',
	numhl =
	'DapBreakpoint'
})
vim.fn.sign_define('DapBreakpointRejected', {
	text = '•',
	texthl = 'orange',
	linehl = 'DapBreakpoint',
	numhl =
	'DapBreakpoint'
})
vim.fn.sign_define('DapStopped', { text = '→', texthl = 'green', linehl = 'text', numhl = 'green' })
vim.fn.sign_define('DapLogPoint', { text = '•', texthl = 'yellow', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })

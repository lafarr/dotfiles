-- vim.keymap.set('n', '<leader>fr', function() terminal.run_command('dlkjfa') end,
-- 	{ desc = 'Run command in scratch terminal' })
-- vim.keymap.set('n', '<leader>fd', function() terminal.run_command_in_dir('ls', '/') end,
-- 	{ desc = 'Run command in directory' })
return {
	{
		dir = '/home/lafarr/code/floaties.nvim',
		keys = {
			{ '<Esc><Esc>', '<C-\\><C-n>',                                     mode = { 't' },                                     desc = "Terminal: Go into normal mode" },
			{ '<leader>ft', function() require('floaties').toggle() end,       desc = 'Terminal: Toggle [f]loating terminal' },
			{ '<leader>fn', function() require('floaties').new() end,          desc = 'Terminal: Create new [f]loating [t]erminal' },
			{ '<C-j>',      function() require('floaties').next() end,         mode = { 't' },                                     desc = 'Terminal: Go to next floating terminal' },
			{ '<C-k>',      function() require('floaties').prev() end,         mode = { 't' },                                     desc = 'Terminal: Go to previous floating terminal' },
			{ '<C-q>',      function() require('floaties').kill_current() end, mode = { 't' },                                     desc = 'Terminal: Kill current floating terminal' },
		},
		opts = {
			width = 0.8,
			height = 0.8,
			border = "rounded",
			winblend = 0,
		}
	},
}

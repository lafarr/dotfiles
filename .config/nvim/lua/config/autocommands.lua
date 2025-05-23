vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Always open help files full screen
vim.api.nvim_create_autocmd('BufEnter', {
	callback = function()
		if vim.bo.filetype == 'help' then
			local keys = vim.api.nvim_replace_termcodes('<C-w>o', true, false, true)
			vim.api.nvim_feedkeys(keys, 'm', false)
		end
	end
})

-- Restore skinny boy when we exit Vim
vim.api.nvim_create_autocmd('VimLeave', {
	callback = function()
		vim.opt.guicursor = 'a:ver5'
	end
})

vim.keymap.set({ 'i', 'n', 'v' }, '<C-c>', '<Esc>', { desc = 'General: Map <C-c> to <Esc>' })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'General: Move selection down 1 line' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'General: Move selection up 1 line' })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = 'General: Jump down half a page' })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = 'General: Jump up half a page' })
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = 'General: Paste without yanking' })
vim.keymap.set('n', '<C-o>', '<C-o>zz', { desc = 'General: Go to previous item in jump list' })
vim.keymap.set('n', '<C-i>', '<C-i>zz', { desc = 'General: Go to next item in jump list' })
vim.keymap.set("i", "<C-BS>", "<C-W>", { desc = 'General: Delete word backwards' })
vim.keymap.set("i", "<C-h>", "<C-W>", { desc = 'General: Delete word backwards' })

vim.keymap.set('i', ')', function()
	if vim.fn.strpart(vim.fn.getline('.'), vim.fn.col('.') - 1, 1) == ")" then
		return "<Right>"
	else
		return ")"
	end
end, { expr = true })

vim.keymap.set('i', '}', function()
	if vim.fn.strpart(vim.fn.getline('.'), vim.fn.col('.') - 1, 1) == "}" then
		return "<Right>"
	else
		return "}"
	end
end, { expr = true })

vim.keymap.set('i', ']', function()
	if vim.fn.strpart(vim.fn.getline('.'), vim.fn.col('.') - 1, 1) == "]" then
		return "<Right>"
	else
		return "]"
	end
end, { expr = true })

vim.keymap.set('i', '(', function()
	if vim.fn.strpart(vim.fn.getline('.'), vim.fn.col('.') - 1, 1) == "(" then
		return "<Right>"
	else
		return "("
	end
end, { expr = true })

vim.keymap.set('i', '{', function()
	if vim.fn.strpart(vim.fn.getline('.'), vim.fn.col('.') - 1, 1) == "{" then
		return "<Right>"
	else
		return "{"
	end
end, { expr = true })

vim.keymap.set('i', '[', function()
	if vim.fn.strpart(vim.fn.getline('.'), vim.fn.col('.') - 1, 1) == "[" then
		return "<Right>"
	else
		return "["
	end
end, { expr = true })

vim.keymap.set('i', '"', function()
	if vim.fn.strpart(vim.fn.getline('.'), vim.fn.col('.') - 1, 1) == '"' then
		return "<Right>"
	else
		return '"'
	end
end, { expr = true })

vim.keymap.set('i', "'", function()
	if vim.fn.strpart(vim.fn.getline('.'), vim.fn.col('.') - 1, 1) == "'" then
		return "<Right>"
	else
		return "'"
	end
end, { expr = true })

vim.keymap.set('i', '>', function()
	if vim.fn.strpart(vim.fn.getline('.'), vim.fn.col('.') - 1, 1) == '>' then
		return "<Right>"
	else
		return '>'
	end
end, { expr = true })

vim.keymap.set('i', '<', function()
	if vim.fn.strpart(vim.fn.getline('.'), vim.fn.col('.') - 1, 1) == '<' then
		return "<Right>"
	else
		return '<'
	end
end, { expr = true })

vim.keymap.set('n', 'i', function()
	if vim.fn.len(vim.fn.getline('.')) == 0 then
		return '"_cc'
	else
		return 'i'
	end
end, { expr = true })

vim.keymap.set('n', 'a', function()
	if vim.fn.len(vim.fn.getline('.')) == 0 then
		return '"_cc'
	else
		return 'a'
	end
end, { expr = true })

vim.keymap.set('n', 'o', function()
	local count = vim.v.count1
	local lines = {}
	for i = 1, count do
		lines[i] = ''
	end
	vim.api.nvim_buf_set_lines(0, vim.fn.line('.'), vim.fn.line('.'), false, lines)
	vim.api.nvim_win_set_cursor(0, { vim.fn.line('.') + count, 0 })
	local keys = vim.api.nvim_replace_termcodes('i', true, false, true)
	vim.api.nvim_feedkeys(keys, 'm', false)
end, { noremap = true, silent = true, desc = 'Insert <count> lines below and stay in Normal mode' })


vim.keymap.set('n', 'O', function()
	local count = vim.v.count1
	local lines = {}
	for i = 1, count do
		lines[i] = ''
	end
	vim.api.nvim_buf_set_lines(0, vim.fn.line('.') - 1, vim.fn.line('.') - 1, false, lines)
	vim.api.nvim_win_set_cursor(0, { vim.fn.line('.') - count, 0 }) -- Move cursor to first new line
	local keys = vim.api.nvim_replace_termcodes('i', true, false, true)
	vim.api.nvim_feedkeys(keys, 'm', false)
end, { noremap = true, silent = true, desc = 'Insert <count> lines above and stay in Normal mode' })

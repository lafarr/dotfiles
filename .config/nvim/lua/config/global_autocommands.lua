--  See `:help lua-guide-autocommands`
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Get rid of the annoying auto-insertion of comment indicators
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	command = "set formatoptions-=cro",
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	command = "setlocal formatoptions-=cro",
})

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		local bufnr = args.buf
		vim.keymap.set('n', 'K', function() vim.lsp.buf.hover({ border = 'rounded' }) end, { buffer = bufnr })
		vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr })
		vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { buffer = bufnr })
		vim.keymap.set({ 'n', 'x' }, '<leader>fd', function() vim.lsp.buf.format({ async = true }) end,
			{ buffer = bufnr })
		vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr })
		vim.keymap.set("n", "<leader>e", function() vim.diagnostic.open_float({ border = 'rounded', source = true }) end,
			{ buffer = bufnr, desc = 'Show [E]rror' })
		vim.keymap.set("n", "<leader>ne",
			function() vim.diagnostic.goto_next({ float = { border = 'rounded', source = true } }) end,
			{ desc = '[N]ext [E]rror', buffer = bufnr })
		vim.keymap.set("n", "<leader>pe",
			function() vim.diagnostic.goto_prev({ float = { border = 'rounded', source = true } }) end,
			{ buffer = bufnr, desc = '[P]revious [E]rror' })
		vim.keymap.set('i', '<C-k>', function() vim.lsp.buf.signature_help({ border = 'rounded', focusable = false }) end)

		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then return end

		vim.api.nvim_create_autocmd('BufWritePre', {
			buffer = args.buf,
			callback = function()
				local filetype = vim.bo.filetype
				local is_cpp_related = filetype == "cpp" or filetype == "c" or
					filetype == "h" or filetype == "hpp" or
					filetype == "cc" or filetype == "cxx"

				if is_cpp_related then
					local clang_format_exists = vim.fn.executable('clang-format') == 1
					if clang_format_exists then
						local cursor_pos = vim.api.nvim_win_get_cursor(0)
						-- Format the entire buffer with clang-format
						vim.cmd('silent! %!clang-format')
						vim.api.nvim_win_set_cursor(0, cursor_pos)
					elseif client.supports_method('textDocument/formatting') then
						-- Fall back to LSP formatting if clang-format is not available
						pcall(function() vim.lsp.buf.format({ bufnr = args.buf, id = client.id }) end)
					end
				elseif client.supports_method('textDocument/formatting') then
					pcall(function() vim.lsp.buf.format({ bufnr = args.buf, id = client.id }) end)
				end
			end
		})
	end
})

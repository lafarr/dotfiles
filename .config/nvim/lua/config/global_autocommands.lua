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
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "",
				},
				numhl = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.HINT] = "",
					[vim.diagnostic.severity.INFO] = "",
				},
			},
		})

		vim.api.nvim_create_user_command('LspInfo', function()
			vim.cmd('checkhealth vim.lsp')
		end, {})

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
			function() vim.diagnostic.goto_next() end,
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

-- Always open help files full screen
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		if vim.bo.filetype == 'help' then
			local keys = vim.api.nvim_replace_termcodes('<C-w>o', true, false, true)
			vim.api.nvim_feedkeys(keys, 'm', false)
		end
	end
})

-- Keep track of trouble cursor position
vim.api.nvim_create_autocmd("CursorMoved", {
	callback = function()
		if vim.bo.filetype == 'trouble' then
			vim.g.prev_pos = vim.api.nvim_win_get_cursor(0)
		end
	end
})

-- If you toggle the most recent trouble window, jump down to your last position
vim.api.nvim_create_autocmd("WinEnter", {
	callback = function()
		if vim.bo.filetype == 'trouble' and vim.g.resume then
			vim.api.nvim_win_set_cursor(0, vim.g.prev_pos)
		end
	end
})

Signature_visible = false
Signature_win_id = nil

function Is_signature_window(win_id)
	local buf_id = vim.api.nvim_win_get_buf(win_id)

	local filetype = vim.api.nvim_buf_get_option(buf_id, 'filetype')
	if filetype == 'lsp-signature-help' then
		return true
	end

	local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
	local content = table.concat(lines, '\n')

	if content:match("Parameters:") or content:match("%(.*%)") then
		return true
	end

	return false
end

vim.api.nvim_create_autocmd({ "WinNew" }, {
	callback = function()
		vim.schedule(function()
			local wins = vim.api.nvim_list_wins()
			for _, win_id in ipairs(wins) do
				if vim.api.nvim_win_is_valid(win_id) and
					vim.api.nvim_win_get_config(win_id).relative ~= "" then
					if Is_signature_window(win_id) then
						Signature_win_id = win_id
						Signature_visible = true
						break
					end
				end
			end
		end)
	end
})

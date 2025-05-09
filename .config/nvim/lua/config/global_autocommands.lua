vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
		-- Clear markdown-specific highlights
		local md_groups = { "markdownCode", "@text.literal", "@markup.raw.block" }
		for _, group in ipairs(md_groups) do
			vim.api.nvim_set_hl(0, group, { bg = "NONE" })
		end
	end
})

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.cmd('autocmd BufEnter * set formatoptions-=cro')
vim.cmd('autocmd BufEnter * setlocal formatoptions-=cro')

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		-- local hierarchy = require('hierarchy')
		-- hierarchy.setup({ depth = 10000 })

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
					-- Try to use clang-format first
					local clang_format_exists = vim.fn.executable('clang-format') == 1
					if clang_format_exists then
						-- Get the current cursor position
						local cursor_pos = vim.api.nvim_win_get_cursor(0)
						-- Format the entire buffer with clang-format
						vim.cmd('silent! %!clang-format')
						-- Restore cursor position
						vim.api.nvim_win_set_cursor(0, cursor_pos)
					elseif client.supports_method('textDocument/formatting') then
						-- Fall back to LSP formatting if clang-format is not available
						pcall(function() vim.lsp.buf.format({ bufnr = args.buf, id = client.id }) end)
					end
				elseif client.supports_method('textDocument/formatting') then
					-- For non-C++ files, use LSP formatting
					pcall(function() vim.lsp.buf.format({ bufnr = args.buf, id = client.id }) end)
				end
			end
		})
	end
})

vim.lsp.set_log_level("debug")

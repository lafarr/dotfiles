-- Configure and enable LSPs
local lsp_dir = vim.fn.stdpath('config') .. '/lua/config/lsp'

for _, filename in ipairs(vim.fn.readdir(lsp_dir)) do
	local file_name_without_extension = vim.split(filename, '.', { plain = true, trimempty = true })[1]
	local require_path = 'config.lsp.' .. file_name_without_extension
	local lsp_cfg = require(require_path)
	vim.lsp.config(file_name_without_extension, lsp_cfg)
	vim.lsp.enable(file_name_without_extension)
end

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

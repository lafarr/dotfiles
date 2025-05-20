return {
	'numToStr/Comment.nvim',
	config = function()
		require('Comment').setup()

		-- Get rid of the annoying auto-insertion of comment indicators
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "*",
			command = "set formatoptions-=cro",
		})

		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "*",
			command = "setlocal formatoptions-=cro",
		})
	end
}

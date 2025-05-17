return {
	'echasnovski/mini.ai',
	config = function()
		local gen_spec = require('mini.ai').gen_spec
		require('mini.ai').setup({
			custom_textobjects = {
				F = gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
			}
		})
	end
}

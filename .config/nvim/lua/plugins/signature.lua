return {
	{
		dir = '~/code/signature.nvim',
		lazy = false,
		opts = {
			show_on_insert_enter = false
		},
		keys = {
			{ '<C-k>', function() require('signature').toggle_signature() end, mode = { 'i' } }
		},
		config = function(_, opts)
			require('signature').setup(opts)
		end
	}
}

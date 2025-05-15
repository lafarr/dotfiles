return {
	"stevearc/oil.nvim",
	lazy = false,
	keys = {
		{ '<leader>fe', '<cmd>Oil<cr>', mode = { 'n' }, desc = 'Oil: Open Oil' }
	},
	opts = {
		delete_to_trash = true,
		view_options = {
			show_hidden = true
		}
	},
}

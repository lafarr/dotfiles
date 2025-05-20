return {
	"f-person/git-blame.nvim",
	lazy = false,
	opts = {
		enabled = false
	},
	keys = {
		{ '<leader>tgb', function() vim.cmd('GitBlameToggle') end, desc = 'Git: [T]oggle [G]it [b]lame' }
	}
}

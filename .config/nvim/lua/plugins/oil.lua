return {
	"stevearc/oil.nvim",
	lazy = false,
	keys = {
		{ '<leader>fe', function() require('oil').open() end, desc = 'Oil: Open Oil' }
	},
	opts = {
		delete_to_trash = true,
		view_options = {
			show_hidden = true
		}
	},
	config = function(_, opts)
		require('oil').setup(opts)

		vim.api.nvim_create_autocmd("User", {
			pattern = "OilActionsPost",
			callback = function(event)
				if event.data.actions.type == "move" then
					Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
				end
			end,
		})
	end
}

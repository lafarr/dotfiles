return {
	"mbbill/undotree",
	keys = {
		{ '<leader>u', vim.cmd.UndotreeToggle, mode = { 'n' }, desc = 'Undotree: Toggle [u]ndotree' }
	},
	lazy = false,
	config = function()
		local undodir = vim.fn.stdpath("data") .. "/undo"
		if not vim.loop.fs_stat(undodir) then
			vim.fn.mkdir(undodir, "p")
		end

		vim.opt.backup = false
		vim.opt.swapfile = false
		vim.opt.undofile = true
		vim.opt.undodir = undodir
	end
}

return {
	{
		'nvim-treesitter/nvim-treesitter-textobjects'
	},
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		opts = {
			-- A list of parser names, or "all" (the listed parsers MUST always be installed)
			ensure_installed = 'all',
			sync_install = false,
			auto_install = true,
			indent = { enable = true },
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			-- These are just to get the linter to shut up
			ignore_install = {},
			modules = {}
		},
		config = function(_, opts)
			require 'nvim-treesitter.configs'.setup(opts)
		end
	},
}

return {
	'hrsh7th/nvim-cmp',
	dependencies = {
		'hrsh7th/cmp-nvim-lsp',
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-buffer",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		{
			"luckasRanarison/tailwind-tools.nvim",
			name = "tailwind-tools",
			build = ":UpdateRemotePlugins",
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
				"neovim/nvim-lspconfig",
			},
		},
	},
	config = function()
		local Cmp = require 'cmp'
		local Luasnip = require('luasnip')
		Cmp.setup({
			snippet = {
				expand = function(args)
					Luasnip.lsp_expand(args.body)
				end,
			},
			completion = {
				documentation = false,
			},
			window = {
				completion = Cmp.config.window.bordered(),
				documentation = false,
			},
			mapping = Cmp.mapping.preset.insert({
				['<C-b>'] = Cmp.mapping.scroll_docs(-4),
				['<C-f>'] = Cmp.mapping.scroll_docs(4),
				['<C-Space>'] = Cmp.mapping.complete(),
				['<C-e>'] = Cmp.mapping.abort(),
				['<C-p>'] = Cmp.mapping.select_prev_item({ behavior = 'select' }),
				['<C-n>'] = Cmp.mapping.select_next_item({ behavior = 'select' }),
				['<Tab>'] = Cmp.mapping.confirm({ select = true }),
			}),
			sources = {
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
				{ name = 'buffer' }
			}
		})

		Cmp.setup.cmdline({ '/', '?' }, {
			mapping = Cmp.mapping.preset.cmdline(),
			sources = {
				{ name = 'buffer' }
			}
		})

		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		Cmp.setup.cmdline(':', {
			mapping = Cmp.mapping.preset.cmdline(),
			sources = Cmp.config.sources({
				{ name = 'path' }
			}, {
				{ name = 'cmdline' }
			}),
			matching = { disallow_symbol_nonprefix_matching = false }
		})
	end
}

local name = 'luals'

vim.lsp.config(name, {
	cmd = { os.getenv("MASON") .. '/bin/lua-language-server' },
	filetypes = { 'lua' },
	root_markers = {
		'.luarc.json',
		'.luarc.jsonc',
		'.luacheckrc',
		'.stylua.toml',
		'stylua.toml',
		'selene.toml',
		'selene.yml',
		'.git',
	},
	settings = {
		Lua = {
			runtime = { version = 'JuaJIT' },
			workspace = {
				checkThirdParty = false,
				library = vim.api.nvim_get_runtime_file('lua', true)
			},
			diagnostics = {
				globals = {
					"vim"
				}
			}
		}
	}
})

vim.lsp.enable(name)

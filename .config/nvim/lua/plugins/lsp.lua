return {
	url = 'https://gitlab.com/schrieveslaach/sonarlint.nvim',
	dependencies = {
		'VonHeikemen/lsp-zero.nvim',
		'neovim/nvim-lspconfig',
		{
			"williamboman/mason.nvim",
			config = function()
				require('mason').setup()
			end
		},
		'hrsh7th/cmp-nvim-lsp',
		{
			"williamboman/mason-lspconfig.nvim",
			config = function()
				local lsp_zero = require('lsp-zero')
				local mason_lspconfig = require('mason-lspconfig');
				local lspconfig = require('lspconfig')

				local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
				function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
					opts = opts or {}
					opts.border = opts.border or "rounded"
					return orig_util_open_floating_preview(contents, syntax, opts, ...)
				end

				-- Force tailwindcss to use the project root directory instead of home
				lspconfig.util._root_pattern_override = {}
				lspconfig.util._root_pattern_override["tailwindcss"] = function()
					local startpath = vim.fn.getcwd()
					local root = vim.fs.dirname(vim.fs.find('.git', { path = startpath, upward = true })[1]) or
						vim.fs.dirname(vim.fs.find('node_modules', { path = startpath, upward = true })[1]) or
						vim.fs.dirname(vim.fs.find('package.json', { path = startpath, upward = true })[1]) or
						startpath

					-- Force project root instead of home directory
					if root == vim.fn.expand("~") then
						return vim.fn.getcwd()
					end
					return root
				end

				-- lsp_attach is where you enable features that only work
				-- if there is a language server active in the file
				local lsp_attach = function(_, bufnr)
					local opts = { buffer = bufnr }
					vim.keymap.set('n', 'K', function() vim.lsp.buf.hover({ border = 'rounded' }) end, opts)
					vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
					vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
					vim.keymap.set({ 'n', 'x' }, '<leader>fd', function() vim.lsp.buf.format({ async = true }) end, opts)
					vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>ne", vim.diagnostic.get_next)
					vim.keymap.set("n", "<leader>pe", vim.diagnostic.get_prev)
					vim.keymap.set('i', '<C-k>', function() vim.lsp.buf.signature_help({ focusable = false }) end)
				end

				lsp_zero.extend_lspconfig({
					sign_text = true,
					lsp_attach = lsp_attach,
					capabilities = require('cmp_nvim_lsp').default_capabilities(),
				})

				-- Force tailwindcss server setup before mason runs
				lspconfig.tailwindcss.setup({
					-- Use our custom root directory finder
					root_dir = lspconfig.util._root_pattern_override["tailwindcss"],
					settings = {
						tailwindCSS = {
							experimental = {
								classRegex = {
									"tw`([^`]*)",
									"tw\\.[^`]+`([^`]*)",
									"tw\\(.*?\\).*?`([^`]*)",
									"tw\\$\\(.*?\\).*?`([^`]*)",
									"twCascade`([^`]*)",
									"twMerge`([^`]*)",
									"twJoin`([^`]*)",
									{ "classnames\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
									{ "clsx\\(([^)]*)\\)",       "(?:'|\"|`)([^']*)(?:'|\"|`)" },
									{ "cn\\(([^)]*)\\)",         "(?:'|\"|`)([^']*)(?:'|\"|`)" }
								}
							}
						}
					},
				})

				mason_lspconfig.setup({
					ensure_installed = {
						'lua_ls',
						'clangd',
						'omnisharp',
						'ts_ls',
						'pyright',
						'bashls',
						'cssls',
						'tailwindcss',
						'cssmodules_ls',
						'gopls',
						'html',
						'jsonls',
						'rust_analyzer',
						'svelte'
					},
					automatic_installation = true,
					handlers = {
						-- Skip tailwindcss as we set it up manually
						function(server_name)
							if server_name == 'tailwindcss' then
								-- Skip - we've already manually configured tailwindcss
								return
							end

							local settings = nil
							if server_name == 'lua_ls' then
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
							end

							if server_name == 'ts_ls' then
								settings = {
									typescript = {
										validate = {
											enable = true
										},
										suggestionActions = {
											enabled = true,
											codeRefactoring = true,
											fixMissingImports = true
										}
									},
									javascript = {
										validate = {
											enable = true
										},
										suggestionActions = {
											enabled = true
										}
									},
									init_options = {
										preferences = {
											quoteStyle = "single",
											importModuleSpecifierPreference = "relative",
										},
										useWorkspaceLibrary = true,
										provideRefactorNotApplicableReason = true,
									}
								}
							end

							lspconfig[server_name].setup({
								settings = settings
							})
						end,
					},
				})

				-- Force-restart tailwindcss LSP after mason setup
				vim.defer_fn(function()
					pcall(function() vim.cmd("LspStart tailwindcss") end)
				end, 1000)
			end
		}
	},
	opts = {
		server = {
			cmd = {
				'sonarlint-language-server',
				'-stdio',
				'-analyzers',
				vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarpython.jar',
				vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarcfamily.jar.asc',
				vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarjs.jar',
				vim.fn.expand '$MASON/share/sonarlint-analyzers/sonargo.jar',
				vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarxml.jar',
				vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarhtml.jar',
			},
		},
		filetypes = {
			'javascript',
			'typescript',
			'javascriptreact',
			'typescriptreact',
			'c',
			'cpp',
			'java',
			'h',
			'hh',
			'hpp',
			'python',
			'html',
			'xml',
			'go',
		},
	},
	config = function(_, opts)
		local path_to_analyzers = '$MASON/share/sonarlint-analyzers'
		if not vim.fn.isdirectory(path_to_analyzers) then
			vim.cmd('LSPInstall sonarlint-language-server')
		end
		require('sonarlint').setup(opts)
	end,
}

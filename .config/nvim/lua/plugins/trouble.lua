vim.g.last_opts = {}
vim.g.prev_pos = {}
vim.g.resume = false

local workspace_diagnostics = function()
	local opts = {
		is_todos = false,
		mode = 'diagnostics', -- inherit from diagnostics mode
		focus = true,
		win = {
			position = 'bottom'
		}
	}

	vim.g.resume = false
	vim.g.last_opts = opts
	require('trouble').open(opts)
end

local document_diagnostics = function()
	local opts = {
		is_todos = false,
		mode = 'diagnostics', -- inherit from diagnostics mode
		filter = { buf = 0 }, -- filter diagnostics to the current buffer
		focus = true,
		win = {
			position = 'bottom'
		}
	}

	vim.g.resume = false
	vim.g.last_opts = opts
	require('trouble').open(opts)
end

local document_symbols = function()
	local opts = {
		is_todos = false,
		mode = 'symbols', -- inherit from diagnostics mode
		filter = { buf = 0 }, -- filter diagnostics to the current buffer
		focus = true,
		win = {
			position = 'bottom'
		}
	}

	vim.g.resume = false
	vim.g.last_opts = opts
	require('trouble').open(opts)
end

local todos = function()
	vim.g.resume = false
	vim.g.last_opts = { is_todos = true }
	vim.cmd('TodoTrouble focus=true')
end

local toggle = function()
	vim.g.resume = true
	if not vim.g.last_opts.is_todos then
		require('trouble').open(vim.g.last_opts)
	else
		vim.cmd('TodoTrouble focus=true')
	end
end

local outgoing_calls = function()
	local opts = {
		is_todos = false,
		mode = 'lsp_outgoing_calls',
		focus = true
	}

	vim.g.resume = false
	vim.g.last_opts = opts

	require('trouble').open(opts)
end

local incoming_calls = function()
	local opts = {
		is_todos = false,
		mode = 'lsp_incoming_calls',
		focus = true
	}

	vim.g.resume = false
	vim.g.last_opts = opts

	require('trouble').open(opts)
end

return {
	"folke/trouble.nvim",
	specs = {
		"folke/snacks.nvim",
		opts = function(_, opts)
			return vim.tbl_deep_extend("force", opts or {}, {
				picker = {
					actions = require("trouble.sources.snacks").actions,
					win = {
						input = {
							keys = {
								["<c-t>"] = {
									"trouble_open",
									mode = { "n", "i" },
								},
							},
						},
					},
				},
			})
		end,
	},
	opts = {
		auto_preview = false
	}, -- for default options, refer to the configuration section for custom setup.
	cmd = "Trouble",
	keys = {
		{
			"<leader>wd",
			workspace_diagnostics,
			desc = "Trouble: [W]orkspace [d]iagnostics",
		},
		{
			"<leader>dd",
			document_diagnostics,
			desc = "Trouble: [D]ocument [d]iagnostics",
		},
		{
			"<leader>tol",
			document_symbols,
			desc = "Trouble: [T]rouble [o]ut[l]ine",
		},
		{
			"<leader>tt",
			toggle,
			desc = "Trouble: [T]oggle [t]rouble",
		},
		{ '<leader>td', todos,          desc = 'Todo Comments: Show [t]o[d]os' },
		{ '<leader>oc', outgoing_calls, desc = 'Trouble: [O]utgoing [c]alls' },
		{ '<leader>ic', incoming_calls, desc = 'Trouble: [I]ncoming [c]alls' }
	},
}

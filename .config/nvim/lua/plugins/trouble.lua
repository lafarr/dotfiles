local prev_pos = {}
local resume = false

local last_opts = {}

local workspace_diagnostics = function()
	local opts = {
		is_todos = false,
		mode = 'diagnostics',
		win = {
			position = 'bottom'
		}
	}

	resume = false
	last_opts = opts
	require('trouble').open(opts)
end

local find_usages = function()
	local opts = {
		is_todos = false,
		mode = 'lsp_references',
		auto_refresh = false,
		win = {
			position = 'bottom'
		}
	}
	resume = false
	last_opts = opts
	require('trouble').open(opts)
end

local document_diagnostics = function()
	local opts = {
		is_todos = false,
		mode = 'diagnostics',
		filter = { buf = 0 },
		win = {
			position = 'bottom'
		}
	}

	resume = false
	last_opts = opts
	require('trouble').open(opts)
end

local document_symbols = function()
	local opts = {
		is_todos = false,
		mode = 'symbols',
		filter = { buf = 0 },
		win = {
			position = 'bottom'
		}
	}

	resume = false
	last_opts = opts
	require('trouble').open(opts)
end

local todos = function()
	resume = false
	last_opts = { is_todos = true }
	vim.cmd('TodoTrouble focus=true')
end

local toggle = function()
	local trouble = require('trouble')
	if trouble.is_open() then
		trouble.close()
	elseif not last_opts.mode and not last_opts.is_todos then
		print('not last_opts.mode')
		return
	else
		resume = true
		if not last_opts.is_todos then
			trouble.open(last_opts)
		else
			vim.cmd('TodoTrouble focus=true')
		end
	end
end

local outgoing_calls = function()
	local opts = {
		is_todos = false,
		mode = 'lsp_outgoing_calls',
	}

	resume = false
	last_opts = opts

	require('trouble').open(opts)
end

local incoming_calls = function()
	local opts = {
		is_todos = false,
		mode = 'lsp_incoming_calls',
	}

	resume = false
	last_opts = opts

	require('trouble').open(opts)
end

local next = function()
	local Trouble = require('trouble')
	if Trouble.is_open() then
		Trouble.next()
		Trouble.jump()
	end
end

local prev = function()
	local Trouble = require('trouble')
	if Trouble.is_open() then
		Trouble.prev()
		Trouble.jump()
	end
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
	},
	cmd = "Trouble",
	keys = {
		{ "<leader>wd",  workspace_diagnostics, desc = "Trouble: [W]orkspace [d]iagnostics", },
		{ "<leader>dd",  document_diagnostics,  desc = "Trouble: [D]ocument [d]iagnostics", },
		{ "<leader>tol", document_symbols,      desc = "Trouble: [T]rouble [o]ut[l]ine", },
		{ "<leader>tt",  toggle,                desc = "Trouble: [T]oggle [t]rouble", },
		{ '<leader>td',  todos,                 desc = 'Todo Comments: Show [t]o[d]os' },
		{ '<leader>gr',  find_usages,           desc = 'Trouble: [F]ind [u]sages' },
		{ '<leader>oc',  outgoing_calls,        desc = 'Trouble: [O]utgoing [c]alls' },
		{ '<leader>ic',  incoming_calls,        desc = 'Trouble: [I]ncoming [c]alls' },
		{ '<C-j>',       next,                  desc = 'Trouble: [N]ext item' },
		{ '<C-k>',       prev,                  desc = 'Trouble: [P]rev item' }
	},
	config = function(_, opts)
		local Trouble = require('trouble')
		Trouble.setup(opts)

		-- Keep track of trouble cursor position
		vim.api.nvim_create_autocmd("CursorMoved", {
			callback = function()
				if vim.bo.filetype == 'trouble' then
					prev_pos = vim.api.nvim_win_get_cursor(0)
				end
			end
		})

		-- If you toggle the most recent trouble window, jump down to your last position
		vim.api.nvim_create_autocmd("WinEnter", {
			callback = function()
				if vim.bo.filetype == 'trouble' and resume then
					vim.api.nvim_win_set_cursor(0, prev_pos)
				end
			end
		})
	end
}

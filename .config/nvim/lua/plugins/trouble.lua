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
			"<cmd>Trouble diagnostics toggle focus=true win.position=bottom<cr>",
			desc = "Trouble: [W]orkspace [d]iagnostics",
		},
		{
			"<leader>dd",
			"<cmd>Trouble diagnostics toggle focus=true filter.buf=0 win.position=bottom<cr>",
			desc = "Trouble: [D]ocument [d]iagnostics",
		},
		{
			"<leader>tol",
			"<cmd>Trouble symbols toggle focus=true win.position=bottom<cr>",
			desc = "Trouble: [T]rouble [o]ut[l]ine",
		},
		{
			"<leader>li",
			"<cmd>Trouble lsp toggle focus=true win.position=bottom<cr>",
			desc = "Trouble: [L]SP [i]nfo",
		},
		{
			"<leader>tt",
			"<cmd>Trouble toggle<cr>",
			desc = "Trouble: [T]oggle [t]rouble",
		},
		{
			"<leader>td",
			"<cmd>TodoTrouble focus=true<cr>",
			desc = "Trouble: [T]o[d]os",
		},
	},
}

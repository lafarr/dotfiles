return {
	"folke/snacks.nvim",
	lazy = false,
	opts = {
		indent = {
			enabled = true
		},
		notifier = {
			enabled = true
		},
		picker = {
			enabled = true,
			sources = {
				explorer = {
					jump = {
						close = true
					},
					layout = {
						preset = 'default'
					},
					hidden = true,
					ignored = true
				}
			}
		},
		input = {
			enabled = true
		},
		statuscolumn = {
			enabled = true
		},
		explorer = {
			replace_netrw = false,
			jump = {
				close = true
			},
			auto_close = true,
		}
	},
	keys = {
		{ '<leader>wl', function() require("snacks").lazygit.log() end,      { 'n' }, desc = 'Snacks: Open Git [w]orkspace [l]og' },
		{ '<leader>dl', function() require("snacks").lazygit.log_file() end, { 'n' }, desc = 'Snacks: Open Git [d]ocument [l]og' },
		{
			'<leader>pf',
			function()
				require("snacks").picker.files({
					hidden = true,
					ignored = true,
					layout = {
						preset = 'select',
						preview = false
					}
				})
			end,
			{ 'n' },
			desc = 'Snacks: Search [p]roject [f]iles'
		},
		{
			'<leader>gf',
			function()
				require("snacks").picker.files({
					hidden = true,
					ignored = false,
					layout = {
						preset = 'select',
						preview = false
					}
				})
			end,
			{ 'n' },
			desc = 'Snacks: Search [G]it [f]iles'
		},
		{
			'<leader>cs',
			function()
				require("snacks").picker.files({
					hidden = true,
					ignored = true,
					dirs = {
						os.getenv('HOME') .. '/.config/nvim'
					},
					layout = {
						preset = 'select',
						preview = false
					}
				})
			end,
			{ 'n' },
			desc = 'Snacks: Search vim [c]onfig file[s]'
		},
		{
			'<leader>gcs',
			function()
				require("snacks").picker.files({
					hidden = true,
					ignored = true,
					dirs = {
						os.getenv('HOME') .. '/.config'
					},
					layout = {
						preset = 'select',
						preview = false
					}
				})
			end,
			{ 'n' },
			desc = 'Snacks: Search [g]lobal [c]onfig file[s]'
		},
		{
			'<leader>km',
			function()
				require('snacks').picker.keymaps({
					layout = {
						preview = false,
						preset = 'select'
					}
				})
			end,
			{ 'n' },
			desc = 'Snacks: Search [k]eymap[s]'
		},
		{
			'<leader>ws',
			function()
				require("snacks").picker.grep({
					hidden = true,
					ignored = true,
					layout = {
						preset = 'default',
					}
				})
			end,
			{ 'n' },
			desc = 'Snacks: [W]orkspace [s]earch'
		},
		{
			'<leader>fws',
			function()
				local pattern = vim.ui.input({ prompt = 'Patterns' }, function(patterns_str)
					local patterns = {}
					local i = 1
					for token in string.gmatch(patterns_str, "[^%s]+") do
						patterns[i] = token
						i = i + 1
					end
					require("snacks").picker.grep({
						hidden = true,
						ignored = true,
						layout = {
							preset = 'default',
						},
						glob = patterns
					})
				end)
			end,
			{ 'n' },
			desc = 'Snacks: [F]iltered [w]orkspace [s]earch'
		},
		{
			'<leader>hp',
			function()
				require("snacks").picker.help({
					layout = {
						preset = "select"
					},
				})
			end,
			{ 'n' },
			desc = 'Snacks: Search [h]el[p]'
		},
		{
			'<leader>ds',
			function()
				require("snacks").picker.lines({
					layout = {
						preset = 'default'
					}
				})
			end,
			{ 'n' },
			desc = 'Snacks: [D]ocument [s]earch'
		},
		{
			'<leader>ol',
			function()
				require("snacks").picker.lsp_symbols({
					layout = {
						preset = 'select'
					}
				})
			end,
			{ 'n' },
			desc = 'Snacks: Document [o]ut[l]ine'
		},
		{
			'<leader>wol',
			function()
				require("snacks").picker.lsp_workspace_symbols({
					tree = true,
					layout = {
						preset = 'select'
					}
				})
			end,
			{ 'n' },
			desc = 'Snacks: [W]orkspace [o]ut[l]ine'
		},
		{
			'<leader>fu',
			function()
				require("snacks").picker.lsp_references({
					layout = {
						preset = 'default'
					}
				})
			end,
			{ 'n' },
			desc = 'Snacks: [F]ind [u]sages'
		},
		{
			'gd',
			function()
				require("snacks").picker.lsp_definitions({
					layout = {
						preset = 'select'
					}
				})
			end,
			{ 'n' },
			desc = 'Snacks: [G]o to [d]efinition'
		},
		{
			'gi',
			function()
				require("snacks").picker.lsp_implementations({
					layout = {
						preset = 'select'
					}
				})
			end,
			{ 'n' },
			desc = 'Snacks: [G]o to [i]mplementations'
		},
		{
			'gt',
			function()
				require("snacks").picker.lsp_type_definitions({
					layout = {
						preset = 'select'
					}
				})
			end,
			{ 'n' },
			desc = 'Snacks: [G]o to [t]ype definition'
		},
		{
			'gD',
			function()
				require("snacks").picker.lsp_declarations({
					layout = {
						preset = 'select'
					}
				})
			end,
			{ 'n' },
			desc = 'Snacks: [G]o to [d]efinition'
		},
		{
			'<leader>gb',
			function()
				require("snacks").picker.git_branches({
					layout = {
						preset = 'select',
						preview = false
					}
				})
			end,
			{ 'n' },
			desc = 'Snacks: Search [G]it [b]ranches'
		},
	},
}

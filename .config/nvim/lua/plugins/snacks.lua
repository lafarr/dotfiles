return {
	"folke/snacks.nvim",
	lazy = false,
	opts = {
		scope = {
			enabled = true
		},
		rename = {
			enabled = true
		},
		image = {
			enabled = true
		},
		bigfile = {
			enabled = true
		},
		indent = {
			enabled = true
		},
		notifier = {
			enabled = true
		},
		picker = {
			enabled = true,
		},
		input = {
			enabled = true,
			height = 50
		},
		explorer = {
			enabled = true,
			replace_netrw = false,
			jump = {
				close = true
			},
			auto_close = true,
		},
		lazygit = {
			enabled = true
		},
		command_history = {
			enabled = true
		},
		search_history = {
			enabled = true
		},
		git_status = {
			enabled = true
		}
	},
	keys = {
		{ '<leader>wl', function() Snacks.lazygit.log() end,                                                          { 'n' }, desc = 'Snacks: Open Git [w]orkspace [l]og' },
		{ '<leader>dl', function() Snacks.lazygit.log_file() end,                                                     { 'n' }, desc = 'Snacks: Open Git [d]ocument [l]og' },
		{ '<leader>gs', function() Snacks.picker.git_status({ layout = { preset = 'select', preview = false } }) end, { 'n' }, desc = 'Snacks: [G]it [s]tatus' },
		{
			'<leader>pf',
			function()
				Snacks.picker.files({
					hidden = true,
					ignored = true,
					layout = {
						preset = 'select',
						preview = false
					}
				})
			end,
			desc = 'Snacks: Search [p]roject [f]iles'
		},
		{
			'<leader>gf',
			function()
				Snacks.picker.git_files({
					hidden = true,
					ignored = true,
					layout = {
						preset = 'select',
						preview = false
					}
				})
			end,
			desc = 'Snacks: Search [G]it [f]iles'
		},
		{
			'<leader>cs',
			function()
				Snacks.picker.files({
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
			desc = 'Snacks: Search vim [c]onfig file[s]'
		},
		{
			'<leader>gcs',
			function()
				Snacks.picker.files({
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
			desc = 'Snacks: Search [g]lobal [c]onfig file[s]'
		},
		{
			'<leader>km',
			function()
				Snacks.picker.keymaps({
					layout = {
						preview = false,
						preset = 'select'
					},
				})
			end,
			desc = 'Snacks: Search [k]ey[m]aps'
		},
		{
			'<leader>ws',
			function()
				Snacks.picker.grep({
					hidden = true,
					ignored = true,
					layout = {
						preset = 'default',
					}
				})
			end,
			desc = 'Snacks: [W]orkspace [s]earch'
		},
		{
			'<leader>fws',
			function()
				vim.ui.input({ prompt = 'Patterns' }, function(patterns_str)
					if patterns_str and patterns_str:len() then
						local patterns = {}
						local i = 1
						for token in string.gmatch(patterns_str, "[^%s]+") do
							patterns[i] = token
							i = i + 1
						end
						Snacks.picker.grep({
							hidden = true,
							ignored = true,
							layout = {
								preset = 'default',
							},
							glob = patterns
						})
					end
				end)
			end,
			desc = 'Snacks: [F]iltered [w]orkspace [s]earch'
		},
		{
			'<leader>hp',
			function()
				Snacks.picker.help({
					layout = {
						preset = "select"
					},
				})
			end,
			desc = 'Snacks: Search [h]el[p]'
		},
		{
			'<leader>ds',
			function()
				Snacks.picker.lines({
					layout = {
						preset = 'default'
					}
				})
			end,
			desc = 'Snacks: [D]ocument [s]earch'
		},
		{
			'<leader>ol',
			function()
				Snacks.picker.lsp_symbols({
					layout = {
						preset = 'select'
					}
				})
			end,
			desc = 'Snacks: Document [o]ut[l]ine'
		},
		{
			'<leader>wol',
			function()
				Snacks.picker.lsp_workspace_symbols({
					tree = true,
					layout = {
						preset = 'select'
					}
				})
			end,
			desc = 'Snacks: [W]orkspace [o]ut[l]ine'
		},
		{
			'<leader>fu',
			function()
				Snacks.picker.lsp_references({
					layout = {
						preset = 'default'
					}
				})
			end,
			desc = 'Snacks: [F]ind [u]sages'
		},
		{
			'gd',
			function()
				Snacks.picker.lsp_definitions({
					layout = {
						preset = 'select'
					}
				})
			end,
			desc = 'Snacks: [G]o to [d]efinition'
		},
		{
			'gi',
			function()
				Snacks.picker.lsp_implementations({
					layout = {
						preset = 'select'
					}
				})
			end,
			desc = 'Snacks: [G]o to [i]mplementations'
		},
		{
			'gt',
			function()
				Snacks.picker.lsp_type_definitions({
					layout = {
						preset = 'select'
					}
				})
			end,
			desc = 'Snacks: [G]o to [t]ype definition'
		},
		{
			'gD',
			function()
				Snacks.picker.lsp_declarations({
					layout = {
						preset = 'select'
					}
				})
			end,
			desc = 'Snacks: [G]o to [d]efinition'
		},
		{
			'<leader>gb',
			function()
				Snacks.picker.git_branches({
					layout = {
						preset = 'select',
						preview = false
					}
				})
			end,
			desc = 'Snacks: Search [G]it [b]ranches'
		},
		{
			'<leader>lg',
			function() Snacks.lazygit() end,
			desc = 'Snacks: Open [l]azy[g]it'
		},
		-- {
		-- 	'<C-]>',
		-- 	function()
		-- 		Snacks.scope.jump({ bottom = true })
		-- 	end,
		-- 	desc = 'Snacks: Jump to bottom of scope',
		-- 	mode = { 'n', 'v' }
		-- },
		-- {
		-- 	'<C-[>',
		-- 	function()
		-- 		Snacks.scope.jump({ bottom = false })
		-- 	end,
		-- 	desc = 'Snacks: Jump to bottom of scope',
		-- 	mode = { 'n', 'v' }
		-- },
		{ '<leader>sh', function() Snacks.picker.search_history({ layout = { preset = 'select' } }) end,  desc = 'Snacks: [S]earch [h]istory' },
		{ '<leader>ch', function() Snacks.picker.command_history({ layout = { preset = 'select' } }) end, desc = 'Snacks: [C]ommand [h]istory' },
		{ '<leader>pb', require('custom.snacks').build_picker,                                            desc = 'Snacks: Search [p]rojects to [b]uild' },
		{ '<leader>pr', require('custom.snacks').run_picker,                                              desc = 'Snacks: Search [p]rojects to [b]uild' },
	},
	config = function(_, opts)
		require('snacks').setup(opts)

		vim.api.nvim_create_user_command('Commands', function()
			Snacks.picker.commands({
				layout = {
					preset = 'select'
				}
			})
		end, {})
	end
}

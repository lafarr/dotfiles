local Term = {}

Term.has_available_window = false

Term.new = function()
	vim.cmd('FloatermNew')
	if not Term.has_available_window then
		Term.has_available_window = true
	end
end

Term.toggle = function()
	vim.cmd('FloatermToggle')
end

Term.scratch = function(commands)
	vim.cmd('FloatermNew')

	for _, cmd in ipairs(commands) do
		vim.cmd('FloatermSend ' .. cmd)
	end

	vim.cmd('FloatermSend exit')
end

Term.kill = function()
	vim.cmd('FloatermKill')
end

Term.next = function()
	vim.cmd('FloatermNext')
end

Term.prev = function()
	vim.cmd('FloatermPrev')
end

local build_picker = function()
	local Snacks = require("snacks")
	-- local projects = { 'disney_planning_data_sourcing', 'map_reduce' }
	local projects = {
		{
			name = 'disney_planning_data_sourcing',
			formatted_name = 'Disney Planning - Data Sourcing'
		},
		{
			name = 'map_reduce',
			formatted_name = 'Map Reduce'
		}
	}

	return Snacks.picker({
		finder = function()
			local items = {}
			for i, item in ipairs(projects) do
				table.insert(items, {
					idx = i,
					project = item.name,
					name = item.formatted_name
				})
			end
			return items
		end,
		layout = {
			preset = 'select'
		},
		format = function(item, _)
			local name = item.name
			local align = Snacks.picker.util.align
			local ret = {}
			ret[#ret + 1] = { align(name, 20) }

			return ret
		end,
		confirm = function(picker, item)
			picker:close()
			vim.cmd('Build ' .. item.project)
		end,
	})
end

return {
	"folke/snacks.nvim",
	dependencies = {
		{
			'voldikss/vim-floaterm',
			lazy = false,
			keys = {
				{ '<leader>ft', Term.toggle,   desc = 'Floating Terminal: [F]loating terminal [t]oggle' },
				{ '<leader>fn', Term.new,      desc = 'Floating Terminal: [F]loating terminal [n]ew' },
				{ '<leader>fk', Term.kill,     desc = 'Floating Terminal: [K]ill [f]loating terminal' },
				{ '<C-j>',      Term.next,     desc = 'Floating Terminal: Next floating terminal',      mode = { 't' } },
				{ '<C-k>',      Term.prev,     desc = 'Floating Terminal: Previous floating terminal',  mode = { 't' } },
				{ '<Esc><Esc>', '<C-\\><C-n>', desc = 'Floating Terminal: Go into normal mode',         mode = { 't' } },
			},
			config = function()
				local HOME = os.getenv('HOME')
				local CODE_DIR = HOME .. '/code'

				local projects = {
					map_reduce = {
						path = CODE_DIR .. '/map-reduce',
						run_cmd = 'go run -race .',
						build_cmd = ' go build - race .'
					},
					disney_planning_data_sourcing = {
						path = CODE_DIR .. '/disney_planning/server/data_sourcing',
						run_cmd = 'go run -race .',
						build_cmd = 'go build -race .'
					}
				}

				vim.api.nvim_create_user_command('Build', function(opts)
					local project = projects[opts.fargs[1]]

					if not project then
						vim.notify(string.format('%s is not a valid project', opts.fargs[1]))
						return
					end

					Term.scratch({
						'cd ' .. project.path,
						project.build_cmd
					})
				end, {
					nargs = 1,
					complete = function()
						return {
							'map_reduce',
							'disney_planning data_sourcing'
						}
					end
				})
			end
		}
	},
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
		{
			'<C-]>',
			function()
				Snacks.scope.jump({ bottom = true })
			end,
			desc = 'Snacks: Jump to bottom of scope'
		},
		{
			'<C-[>',
			function()
				Snacks.scope.jump({ bottom = false })
			end,
			desc = 'Snacks: Jump to bottom of scope'
		},
		{ '<leader>sh', function() Snacks.picker.search_history({ layout = { preset = 'select' } }) end,  desc = 'Snacks: [S]earch [h]istory' },
		{ '<leader>ch', function() Snacks.picker.command_history({ layout = { preset = 'select' } }) end, desc = 'Snacks: [C]ommand [h]istory' },
		{ '<leader>pb', build_picker,                                                                     desc = 'Snacks: Search [p]rojects to [b]uild' },
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

local M = {}

local projects = require('config.projects')

M.build_picker = function()
	return Snacks.picker({
		finder = function()
			local items = {}
			for name, item in pairs(projects) do
				table.insert(items, {
					project = name,
					-- What is used for search
					text = item.formatted_name,
					-- What is displayed
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
			local project = projects[item.project]
			require('floaties').run_command_in_dir(project.build_cmd, project.path)
		end,
	})
end

M.run_picker = function()
	return Snacks.picker({
		finder = function()
			local items = {}
			for name, item in pairs(projects) do
				table.insert(items, {
					project = name,
					-- What is used for search
					text = item.formatted_name,
					-- What is displayed
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
			local project = projects[item.project]
			require('floaties').run_command_in_dir(project.run_cmd, project.path)
		end,
	})
end

return M

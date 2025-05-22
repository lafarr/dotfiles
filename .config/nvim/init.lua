require("config.lazy")
require("config.remaps")
require("config.autocommands")
require("config.settings")
require("config.lsp")

-- Pretty print for debugging
_G.dd = function(...)
	require('snacks').debug.inspect(...)
end

vim.print = _G.dd

local sig_help_ns = vim.api.nvim_create_namespace('nvim.lsp.signature_help')

local function client_positional_params(params)
	local win = vim.api.nvim_get_current_win()
	return function(client)
		local ret = require('vim.lsp.util').make_position_params(win, client.offset_encoding)
		if params then
			ret = vim.tbl_extend('force', ret, params)
		end
		return ret
	end
end

local function process_signature_help_results(results)
	local signatures = {} --- @type [vim.lsp.Client,lsp.SignatureInformation][]
	local active_signature = 1

	-- Pre-process results
	for client_id, r in pairs(results) do
		local err = r.err
		local client = assert(vim.lsp.get_client_by_id(client_id))
		if err then
			vim.notify(
				client.name .. ': ' .. tostring(err.code) .. ': ' .. err.message,
				vim.log.levels.ERROR
			)
			vim.api.nvim_command('redraw')
		else
			local result = r.result --- @type lsp.SignatureHelp
			if result and result.signatures and result.signatures[1] then
				for i, sig in ipairs(result.signatures) do
					sig.activeParameter = sig.activeParameter or result.activeParameter
					local idx = #signatures + 1
					if (result.activeSignature or 0) + 1 == i then
						active_signature = idx
					end
					signatures[idx] = { client, sig }
				end
			end
		end
	end

	return signatures, active_signature
end

local function sig(config)
	local ms = require('vim.lsp.protocol').Methods
	local method = ms.textDocument_signatureHelp
	local util = require('vim.lsp.util')

	config = config and vim.deepcopy(config) or {}
	config.focus_id = method

	vim.lsp.buf_request_all(0, method, client_positional_params(), function(results, ctx)
		if vim.api.nvim_get_current_buf() ~= ctx.bufnr then
			-- Ignore result since buffer changed. This happens for slow language servers.
			return
		end

		local signatures, active_signature = process_signature_help_results(results)

		if not next(signatures) then
			if config.silent ~= true then
				print('No signature help available')
			end
			return
		end

		local ft = vim.bo[ctx.bufnr].filetype
		local total = #signatures
		local can_cycle = total > 1 and config.focusable ~= false
		local idx = active_signature - 1

		--- @param update_win? integer
		local function show_signature(update_win)
			idx = (idx % total) + 1
			local client, result = signatures[idx][1], signatures[idx][2]
			result.documentation = nil
			--- @type string[]?
			local triggers =
				vim.tbl_get(client.server_capabilities, 'signatureHelpProvider', 'triggerCharacters')
			local lines, hl =
				util.convert_signature_help_to_markdown_lines({ signatures = { result } }, ft, triggers)
			if not lines then
				return
			end

			local sfx = total > 1
				and string.format(' (%d/%d)%s', idx, total, can_cycle and ' (<C-s> to cycle)' or '')
				or ''

			local title = sfx

			if config.border then
				config.title = title
			else
				table.insert(lines, 1, '# ' .. title)
				if hl then
					hl[1] = hl[1] + 1
					hl[3] = hl[3] + 1
				end
			end

			config._update_win = update_win

			local buf, win = util.open_floating_preview(lines, 'markdown', config)

			if hl then
				vim.api.nvim_buf_clear_namespace(buf, sig_help_ns, 0, -1)
				vim.hl.range(
					buf,
					sig_help_ns,
					'LspSignatureActiveParameter',
					{ hl[1], hl[2] },
					{ hl[3], hl[4] }
				)
			end
			return buf, win
		end

		local fbuf, fwin = show_signature()

		if can_cycle then
			vim.keymap.set({ 'n', 'i' }, '<C-s>', function()
				show_signature(fwin)
			end, {
				desc = 'Cycle next signature',
			})
		end
	end)
end

vim.api.nvim_create_user_command('Sig', function()
	sig({ title = 'hey there', border = 'rounded' })
end, {})

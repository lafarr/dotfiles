return {
	'ray-x/lsp_signature.nvim',
	lazy = false,
	event = {},
	opts = {
		bind = true,      -- mandatory, binds to LSP's signatureHelp events.
		doc_lines = 0,    -- disable inline docs if you don't want them.
		floating_window = true, -- use a floating window
		fix_pos = true,
		hint_enable = false, -- disable inline hints
		toggle_key = "<C-s>", -- toggle signature help on/off with Ctrl-s
		toggle_key_flip_floatwin_setting = false,
		handler_opts = {
			border = 'rounded' -- set a border style if desired
		},
		always_trigger = false,
		hi_parameter = "",
		timer_interval = 20,
	}
}

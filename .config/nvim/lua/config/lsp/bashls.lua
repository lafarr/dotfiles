---@brief
---
--- https://github.com/bash-lsp/bash-language-server
---
--- `bash-language-server` can be installed via `npm`:
--- ```sh
--- npm i -g bash-language-server
--- ```
---
--- Language server for bash, written using tree sitter in typescript.

return {
	cmd = { os.getenv('MASON') .. '/bin/bash-language-server', 'start' },
	settings = {
		bashIde = {
			globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)',
		},
	},
	filetypes = { 'bash', 'sh', 'zsh' },
	root_markers = { '.git' },
}

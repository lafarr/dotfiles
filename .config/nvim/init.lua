vim.g.resume = false

require("config.lazy")
require("config.remaps")
require("config.global_autocommands")
require("config.global_settings")

-- Configure and enable LSPs
local lsp_dir = vim.fn.stdpath('config') .. '/lua/config/lsp'

for _, filename in ipairs(vim.fn.readdir(lsp_dir)) do
	local file_name_without_extension = vim.split(filename, '.', { plain = true, trimempty = true })[1]
	local require_path = 'config.lsp.' .. file_name_without_extension
	local lsp_cfg = require(require_path)
	vim.lsp.config(file_name_without_extension, lsp_cfg)
	vim.lsp.enable(file_name_without_extension)
end

-- Pretty print for debugging
_G.dd = function(...)
	require('snacks').debug.inspect(...)
end

vim.print = _G.dd

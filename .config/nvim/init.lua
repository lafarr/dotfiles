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

-- Put this in ftplugin/java.lua so it only loads for Java files
local jdtls_ok, jdtls = pcall(require, 'jdtls')
if not jdtls_ok then
	vim.notify('JDTLS not found, install with your package manager', vim.log.levels.ERROR)
	return
end

-- Check if we already have a client running for this buffer
local clients = vim.lsp.get_active_clients({ bufnr = vim.fn.bufnr(), name = "jdtls" })
if #clients > 0 then
	-- If a client is already running, don't start another one
	return
end

local home = os.getenv('HOME')
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = home .. '/workspace/' .. project_name

-- Find root directory
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require('jdtls.setup').find_root(root_markers)
if root_dir == "" then
	return
end

-- Get the proper Java executable based on project requirements
-- or use the most recent one as default
local java_cmd = '/usr/lib/jvm/java-21-openjdk-amd64/bin/java'

local config = {
	cmd = {
		java_cmd,
		'-Declipse.application=org.eclipse.jdt.ls.core.id1',
		'-Dosgi.bundles.defaultStartLevel=4',
		'-Declipse.product=org.eclipse.jdt.ls.core.product',
		'-Dlog.protocol=true',
		'-Dlog.level=ALL',
		'-Xmx1g',
		'--add-modules=ALL-SYSTEM',
		'--add-opens', 'java.base/java.util=ALL-UNNAMED',
		'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
		'-jar', '/home/james/dev/repos/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
		'-configuration', '/home/james/dev/repos/jdtls/config_linux',
		'-data', workspace_dir
	},
	root_dir = root_dir,
	settings = {
		java = {
			-- Remove explicit home directory and runtime configurations
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			format = {
				enabled = true,
			}
		}
	},
	init_options = {
		bundles = {}
	},
	flags = {
		allow_incremental_sync = true,
	},
	capabilities = vim.lsp.protocol.make_client_capabilities(),
}

-- Start the server
jdtls.start_or_attach(config)

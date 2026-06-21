-- ~/.config/nvim/ftplugin/java.lua
-- This runs every time a Java buffer is opened and is the single place jdtls is started.
local jdtls = require("jdtls")

local mason = vim.fn.stdpath("data") .. "/mason/packages"
local jdtls_path = mason .. "/jdtls"

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.expand("~/.cache/jdtls-workspace/") .. project_name

local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

-- Optional: junit jar for PLAIN projects (no Maven/Gradle). For Maven/Gradle projects
-- JUnit comes from pom.xml / build.gradle and this is ignored.
local junit_jar = vim.fn.expand("~/java-lib/junit-platform-console-standalone-1.12.1.jar")
local referenced_libraries = {}
if vim.fn.filereadable(junit_jar) == 1 then
	table.insert(referenced_libraries, junit_jar)
end

-- Bundles give jdtls JUnit (@Test) test discovery, running, and debugging.
local bundles = {}
vim.list_extend(
	bundles,
	vim.split(vim.fn.glob(mason .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true), "\n")
)
vim.list_extend(bundles, vim.split(vim.fn.glob(mason .. "/java-test/extension/server/*.jar", true), "\n"))
-- drop empty entries when a bundle isn't installed yet
bundles = vim.tbl_filter(function(j)
	return j ~= ""
end, bundles)

-- advertise the same completion capabilities as the rest of the LSP setup
local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = ok and cmp_nvim_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()

local config = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1G",
		"--add-modules=ALL-SYSTEM",
		"-jar",
		launcher_jar,
		"-configuration",
		jdtls_path .. "/config_mac_arm",
		"-data",
		workspace_dir,
	},

	root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
	capabilities = capabilities,
	settings = {
		java = {
			project = {
				-- only used for plain projects (see note above)
				referencedLibraries = referenced_libraries,
			},
		},
	},

	init_options = {
		bundles = bundles,
	},
}

-- DAP must be set up AFTER the language server has attached -- doing it
-- synchronously at startup is what caused "No configuration found for `java`".
config.on_attach = function()
	pcall(function()
		jdtls.setup_dap({ hotcodereplace = "auto" })
	end)
	-- project import can lag slightly behind attach; wait, then scan for main classes
	vim.defer_fn(function()
		pcall(function()
			require("jdtls.dap").setup_dap_main_class_configs()
		end)
	end, 1500)
end

jdtls.start_or_attach(config)

-- manual refresh in case main-class configs aren't ready yet (large projects)
vim.api.nvim_create_user_command("JdtlsRefreshDap", function()
	require("jdtls.dap").setup_dap_main_class_configs()
	vim.notify("Re-scanned Java main classes for DAP")
end, { desc = "Re-scan Java main classes for DAP" })

-- quick run: compile + run the current file in a terminal split (single-file source mode).
-- Best for self-contained files; use <F5> (DAP) for projects / packages / debugging.
vim.keymap.set("n", "<leader>jr", function()
	vim.cmd("write")
	local file = vim.fn.expand("%:p")
	vim.cmd("botright new")
	vim.cmd("resize 15")
	vim.cmd("terminal java " .. vim.fn.shellescape(file))
	vim.cmd("startinsert")
end, { buffer = true, desc = "Run current Java file" })

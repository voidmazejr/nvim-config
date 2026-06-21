return {
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			-- list of servers for mason to install
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
				"pyright",
				"eslint",
				"jdtls",
				"clangd",
				"sqls",
			},
			-- jdtls is started manually by nvim-jdtls (ftplugin/java.lua), so don't let
			-- mason-lspconfig auto-enable it -- that would spawn a second, unconfigured
			-- jdtls client that flags JUnit annotations (@Test etc.) as errors.
			automatic_enable = {
				exclude = { "jdtls" },
			},
		},
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			"neovim/nvim-lspconfig",
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				"prettier", -- prettier formatter (fallback)
				"prettierd", -- prettier daemon (faster, primary)
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"clang-format", -- java/c/c++ formatter
				"java-test", -- jdtls bundle: JUnit (@Test) support + running tests
				"java-debug-adapter", -- jdtls bundle: debugging / DAP test runner
				"pylint",
				"eslint_d",
			},
		},
		dependencies = {
			"williamboman/mason.nvim",
		},
	},
}

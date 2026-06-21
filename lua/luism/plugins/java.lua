return {
	-- jdtls is started manually in ftplugin/java.lua (NOT via lspconfig/vim.lsp.enable).
	-- mason-lspconfig is told to skip auto-enabling jdtls (see lsp/mason.lua) so we don't
	-- get a second, unconfigured client attaching and flagging JUnit (@Test etc.) as errors.
	"mfussenegger/nvim-jdtls",
	ft = "java",
}

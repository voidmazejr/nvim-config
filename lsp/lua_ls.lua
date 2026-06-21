-- Neovim 0.11 native LSP config for lua-language-server.
-- Auto-merged when lua_ls is enabled (mason-lspconfig -> vim.lsp.enable).
-- Fixes "undefined global `vim`/`require`/`table`" in the nvim config.
return {
	settings = {
		Lua = {
			-- Neovim runs LuaJIT; this loads the LuaJIT standard library
			-- (require, table, string, ...) so they stop being flagged.
			runtime = {
				version = "LuaJIT",
			},
			-- tell lua_ls that `vim` is a known global
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
}

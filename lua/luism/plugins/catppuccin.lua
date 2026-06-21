return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			transparent_background = true,
			default_integrations = true,
			auto_integrations = true,
			integrations = {
				lualine = {
					all = function(colors)
						return {
							normal = {
								a = { bg = colors.lavender, fg = colors.mantle, gui = "bold" },
								b = { bg = colors.surface0, fg = colors.lavender },
								c = { bg = colors.none, fg = colors.text },
							},
							insert = {
								a = { bg = colors.green, fg = colors.base, gui = "bold" },
								b = { bg = colors.surface0, fg = colors.green },
							},
							visual = {
								a = { bg = colors.mauve, fg = colors.base, gui = "bold" },
								b = { bg = colors.surface0, fg = colors.mauve },
							},
							command = {
								a = { bg = colors.peach, fg = colors.base, gui = "bold" },
								b = { bg = colors.surface0, fg = colors.peach },
							},
							replace = {
								a = { bg = colors.red, fg = colors.base, gui = "bold" },
								b = { bg = colors.surface0, fg = colors.red },
							},
							inactive = {
								a = { bg = colors.none, fg = colors.subtext0 },
								b = { bg = colors.none, fg = colors.subtext0 },
								c = { bg = colors.none, fg = colors.subtext0 },
							},
						}
					end,
				},
				telescope = true,
				nvimtree = true,
				cmp = true,
				gitsigns = true,
				treesitter = true,
			},
		})

		vim.cmd.colorscheme("catppuccin")
	end,
}

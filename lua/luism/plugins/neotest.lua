return {
	{
		"rcasia/neotest-java",
		ft = "java",
		dependencies = {
			"mfussenegger/nvim-jdtls",
			"mfussenegger/nvim-dap", -- for debugging (optional)
			"rcarriga/nvim-dap-ui", -- recommended
			"theHamsta/nvim-dap-virtual-text", -- recommended
		},
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			local neotest = require("neotest")

			neotest.setup({
				adapters = {
					require("neotest-java")({
						-- Optional configuration here
					}),
				},
			})

			local map = vim.keymap.set
			map("n", "<leader>tt", function()
				neotest.run.run()
			end, { desc = "Test: Run nearest" })
			map("n", "<leader>ta", function()
				neotest.run.run(vim.fn.expand("%"))
			end, { desc = "Test: Run file" })
			map("n", "<leader>td", function()
				neotest.run.run({ strategy = "dap" })
			end, { desc = "Test: Debug nearest (DAP)" })
			map("n", "<leader>ts", function()
				neotest.summary.toggle()
			end, { desc = "Test: Toggle summary" })
			map("n", "<leader>tO", function()
				neotest.output.open({ enter = true })
			end, { desc = "Test: Show output" })
		end,
	},
}

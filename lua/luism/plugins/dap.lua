return {
	"mfussenegger/nvim-dap",
	event = "VeryLazy",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio", -- required by dap-ui
		"theHamsta/nvim-dap-virtual-text", -- inline variable values while debugging
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup()
		require("nvim-dap-virtual-text").setup()

		-- auto open / close the debug UI around a session
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		-- breakpoint sign
		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })

		local map = vim.keymap.set
		-- stepping controls (function keys = no leader conflicts, VS Code style)
		map("n", "<F5>", function()
			dap.continue()
		end, { desc = "Debug: Start / Continue" })
		map("n", "<F6>", function()
			dapui.toggle()
		end, { desc = "Debug: Toggle UI" })
		map("n", "<F7>", function()
			dap.step_out()
		end, { desc = "Debug: Step Out" })
		map("n", "<F9>", function()
			dap.toggle_breakpoint()
		end, { desc = "Debug: Toggle Breakpoint" })
		map("n", "<F10>", function()
			dap.step_over()
		end, { desc = "Debug: Step Over" })
		map("n", "<F11>", function()
			dap.step_into()
		end, { desc = "Debug: Step Into" })

		-- leader aliases (b / B are free)
		map("n", "<leader>b", function()
			dap.toggle_breakpoint()
		end, { desc = "Debug: Toggle Breakpoint" })
		map("n", "<leader>B", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Debug: Conditional Breakpoint" })
	end,
}

local icons = require("icons")

local M = {
	"mfussenegger/nvim-dap",
	event = "VeryLazy",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"jay-babu/mason-nvim-dap.nvim",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		local mason_dap = require("mason-nvim-dap")
		local dap = require("dap")
		local ui = require("dapui")
		local dap_virtual_text = require("nvim-dap-virtual-text")

		-- Dap Virtual Text
		dap_virtual_text.setup()

		mason_dap.setup({
			ensure_installed = { "delve" },
			automatic_installation = true,
			handlers = {
				function(config)
					require("mason-nvim-dap").default_setup(config)
				end,
			},
		})

		-- Configurations
		dap.configurations.go = {
			{
				type = "delve",
				name = "Debug",
				request = "launch",
				program = "${file}",
			},
			{
				type = "delve",
				name = "Debug Package",
				request = "launch",
				program = "${fileDirname}",
			},
			{
				type = "delve",
				name = "Debug test (go.mod)",
				request = "launch",
				mode = "test",
				program = "./${relativeFileDirname}",
			},
			{
				type = "delve",
				name = "Debug test (single)",
				request = "launch",
				mode = "test",
				program = "${file}",
			},
			{
				type = "delve",
				name = "Attach to process",
				request = "attach",
				mode = "local",
				processId = require("dap.utils").pick_process,
			},
		}

		-- Dap UI

		ui.setup()

		-- Define highlight groups using Teide theme colors
		vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#F97791" })
		vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#FFE77A" })
		vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#5CCEFF" })
		vim.api.nvim_set_hl(0, "DapStopped", { fg = "#38FFA5" })
		vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#1D2828" })
		vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#414868" })

		vim.fn.sign_define("DapBreakpoint", { text = icons.dap.breakpoint, texthl = "DapBreakpoint" })
		vim.fn.sign_define("DapBreakpointCondition", { text = icons.dap.breakpoint_conditional, texthl = "DapBreakpointCondition" })
		vim.fn.sign_define("DapLogPoint", { text = icons.dap.breakpoint_log, texthl = "DapLogPoint" })
		vim.fn.sign_define("DapStopped", { text = icons.dap.stopped, texthl = "DapStopped", linehl = "DapStoppedLine" })
		vim.fn.sign_define("DapBreakpointRejected", { text = icons.dap.breakpoint_rejected, texthl = "DapBreakpointRejected" })

		dap.listeners.after.event_initialized["dapui_config"] = function()
			ui.open()
		end
		-- dap.listeners.before.attach.dapui_config = function()
		-- 	ui.open()
		-- end
		-- dap.listeners.before.launch.dapui_config = function()
		-- 	ui.open()
		-- end
		dap.listeners.before.event_terminated.dapui_config = function()
			ui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			ui.close()
		end
	end,
}

return M

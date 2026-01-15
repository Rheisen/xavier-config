local M = {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		lsp = {
			-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
			},
		},
		-- you can enable a preset for easier configuration
		presets = {
			bottom_search = true, -- use a classic bottom cmdline for search
			command_palette = true, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = false, -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = false, -- add a border to hover docs and signature help
		},
		-- add any options here
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	}
}

return M

-- local M = {
-- 	"folke/noice.nvim",
-- 	event = "VeryLazy",
-- 	opts = {
-- 		lsp = {
-- 			override = {
-- 				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
-- 				["vim.lsp.util.stylize_markdown"] = true,
-- 				["cmp.entry.get_documentation"] = true,
-- 			},
-- 		},
-- 		routes = {
-- 			{
-- 				filter = {
-- 					event = "msg_show",
-- 					any = {
-- 						{ find = "%d+L, %d+B" },
-- 						{ find = "; after #%d+" },
-- 						{ find = "; before #%d+" },
-- 					},
-- 				},
-- 				view = "mini",
-- 			},
-- 		},
-- 		presets = {
-- 			bottom_search = true,
-- 			command_palette = true,
-- 			long_message_to_split = true,
-- 			lsp_doc_border = true,
-- 		},
-- 	},
--   -- stylua: ignore
--   keys = {
--     { "<leader>sn", "", desc = "+noice"},
--     { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
--     { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
--     { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
--     { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
--     { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
--     { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice Picker (Telescope/FzfLua)" },
--     { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
--     { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
--   },
-- 	config = function(_, opts)
-- 		-- HACK: noice shows messages from before it was enabled,
-- 		-- but this is not ideal when Lazy is installing plugins,
-- 		-- so clear the messages in this case.
-- 		if vim.o.filetype == "lazy" then
-- 			vim.cmd([[messages clear]])
-- 		end
-- 		require("noice").setup(opts)
-- 	end,
-- }
--
-- return M

local M = {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		delay = 1000,
		-- Document key chains
		spec = {
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>t", group = "[T]oggle" },
			{ "<leader>x", group = "[X]avi Config" },
			-- { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}

return M

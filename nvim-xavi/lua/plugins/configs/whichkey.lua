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
			{ "gr", group = "lsp actions" },
			{ "<leader>g", group = "[g]oto" },
			{ "<leader>d", group = "[d]ap (debugging)" },
			{ "<leader>x", group = "diagnostics (debugging)" },
			{ "<leader>f", group = "[f]ind" },
			{ "<leader>v", group = "[v]ersion control (git)" },
			{ "<leader>vl", group = "[v]ersion [l]og (git)" },
			{ "<leader>s", group = "[s]taging (git)" },
			{ "<leader>u", group = "[u]nstaging (git)" },
			{ "<leader>r", group = "[r]esetting (git)" },
			{ "<leader>a", group = "[a]i (artificial intelligence)" },
			{ "gp", group = "[g]oto [p]review" },
		},
	},
	sort = "alphanum",
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "buffer local keymaps (which-key)",
		},
	},
}

return M

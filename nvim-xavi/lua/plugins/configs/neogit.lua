local M = {
	"NeogitOrg/neogit",
	lazy = true,
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		-- "sindrets/diffview.nvim", -- optional - Diff integration
		"folke/snacks.nvim", -- optional
	},
	cmd = "Neogit",
	keys = {
		{ "<leader>vg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
	},
}

return M

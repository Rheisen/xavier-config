local M = {
	"serhez/teide.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		-- Load the colorscheme here.
		vim.cmd.colorscheme("teide-dark")
	end,
	opts = {},
}

return M

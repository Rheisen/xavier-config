local M = {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = {
		options = {
			mode = "tabs",
			-- close_command = function(n)
			-- 	Snacks.bufdelete(n)
			-- end,
			-- right_mouse_command = function(n)
			-- 	Snacks.bufdelete(n)
			-- end,
			diagnostics = "nvim_lsp",
			always_show_bufferline = true,
			offsets = {
				{
					filetype = "neo-tree",
					text = "neotree",
					highlight = "Directory",
					text_align = "left",
				},
				{
					filetype = "snacks_layout_box",
				},
			},
		},
	},
	-- config = function(_, opts)
	-- 	require("bufferline").setup(opts)
	-- 	-- Fix bufferline when restoring a session
	-- 	vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
	-- 		callback = function()
	-- 			vim.schedule(function()
	-- 				pcall(nvim_bufferline)
	-- 			end)
	-- 		end,
	-- 	})
	-- end,
}

return M

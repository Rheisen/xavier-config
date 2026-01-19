local M = {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {
		modes = {
			-- search = {
			-- 	enabled = false, -- disable flash integration with / and ? search
			-- },
			char = {
				highlight = { backdrop = false },
				jump_labels = false,
				multi_line = false,
			},
		},
	},
	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash",
		},
		{
			"S",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash Treesitter",
		},
		{
			"r",
			mode = "o",
			function()
				require("flash").remote()
			end,
			desc = "Remote Flash",
		},
		{
			"R",
			mode = { "o", "x" },
			function()
				require("flash").treesitter_search()
			end,
			desc = "Treesitter Search",
		},
		{
			"<c-s>",
			mode = { "c" },
			function()
				require("flash").toggle()
			end,
			desc = "Toggle Flash Search",
		},
	},
	config = function(_, opts)
		require("flash").setup(opts)

		-- Custom highlights for better visibility
		vim.api.nvim_set_hl(0, "FlashCurrent", { bg = "#FFE77A", fg = "#1D2228", bold = true })
		vim.api.nvim_set_hl(0, "FlashMatch", { bg = "#5CCEFF", fg = "#1D2228" })
		vim.api.nvim_set_hl(0, "FlashLabel", { bg = "#F97791", fg = "#1D2228", bold = true })
	end,
}

return M

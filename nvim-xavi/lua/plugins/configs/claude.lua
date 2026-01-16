-- local M = {
-- 	"greggh/claude-code.nvim",
-- 	dependencies = {
-- 		"nvim-lua/plenary.nvim", -- Required for git operations
-- 	},
-- 	config = function()
-- 		require("claude-code").setup({
-- 			-- window = {
-- 			-- 	position = "float",
-- 			-- 	enter_insert = false,
-- 			-- 	hide_numbers = false,
-- 			-- 	float = {
-- 			-- 		width = "30%", -- Take up 90% of the editor width
-- 			-- 		height = "90%", -- Take up 90% of the editor height
-- 			-- 		row = "center", -- Center vertically
-- 			-- 		col = "65%", -- Center horizontally
-- 			-- 		relative = "editor",
-- 			-- 		border = "single", -- Use single border style
-- 			-- 	},
-- 			-- },
-- 		})
-- 	end
-- }
--
-- return M
local M = {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	config = true,
	opts = {
		terminal = {
			provider = "snacks",
		},
		snacks_win_opts = {
			start_insert = false,
			auto_insert = false,
		},
	},
	keys = {
		{ "<leader>a", nil, desc = "AI" },
		{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
		{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
		{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
		{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
		{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
		-- { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
		{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
		-- {
		-- 	"<leader>as",
		-- 	"<cmd>ClaudeCodeTreeAdd<cr>",
		-- 	desc = "Add file",
		-- 	ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
		-- },
		-- Diff management
		{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
	},
}

return M

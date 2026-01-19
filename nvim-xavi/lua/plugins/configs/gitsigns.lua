local M = {
	"lewis6991/gitsigns.nvim",
	event = "BufReadPost",
}

function M.config()
	local icons = require("icons")
	require("gitsigns").setup({
		signs = {
			add = {
				text = icons.bar.vertical_left_thick,
			},
			change = {
				text = icons.bar.vertical_left_thick,
			},
			delete = {
				text = icons.bar.lower_horizontal,
			},
			topdelete = {
				text = icons.bar.lower_horizontal,
			},
			changedelete = {
				text = icons.bar.vertical_left_thick,
			},
			untracked = {
				text = icons.bar.vertical_left_thick,
			},
		},
		signs_staged = {
			add = {
				text = icons.bar.vertical_left_thick,
			},
			change = {
				text = icons.bar.vertical_left_thick,
			},
			delete = {
				text = icons.bar.lower_horizontal,
			},
			topdelete = {
				text = icons.bar.lower_horizontal,
			},
			changedelete = {
				text = icons.bar.vertical_left_thick,
			},
			untracked = {
				text = icons.bar.vertical_left_thick,
			},
		},
		watch_gitdir = {
			interval = 1000,
			follow_files = true,
		},
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
			ignore_whitespace = true,
			delay = 500,
		},
		sign_priority = 100,
		status_formatter = nil, -- Use default
		max_file_length = 10000,
		preview_config = {
			-- Options passed to nvim_open_win
			border = "solid",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
		trouble = true,
		gh = true,
		word_diff = false,
		diff_opts = { internal = true },
	})
end

return M

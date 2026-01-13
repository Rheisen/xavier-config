local icons = require("icons")

local M = {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons", -- optional, but recommended
	},
	opts = {
		default_component_configs = {
			icon = {
				folder_closed = icons.folder.default,
				folder_open = icons.folder.open,
				folder_empty = icons.folder.empty,
			},
			modified = {
				symbol = icons.git.modified,
				highlight = "NeoTreeModified",
			},
			git_status = {
				symbols = {
					-- Change type
					added = icons.git.added,

					modified = icons.git.modified,
					deleted = icons.git.removed, -- this can only be used in the git_status source
					renamed = icons.git.renamed, -- this can only be used in the git_status source
					-- Status type
					untracked = icons.git.untracked,
					ignored = icons.git.ignored,
					unstaged = icons.git.unstaged,
					staged = icons.git.staged,
					conflict = icons.git.conflict,
				},
			},
		},
		renderers = {
			directory = {
				{ "indent" },
				{ "icon" },
				{ "current_filter" },
				{
					"container",
					content = {
						{ "name", zindex = 10 },
						{
							"symlink_target",
							zindex = 10,
							highlight = "NeoTreeSymbolicLinkTarget",
						},
						{ "clipboard", zindex = 10 },
						{
							"git_status",
							zindex = 20,
							align = "right",
							hide_when_expanded = true,
						},
						{
							"diagnostics",
							errors_only = true,
							zindex = 20,
							align = "right",
							hide_when_expanded = true,
						},
						{ "file_size", zindex = 10, align = "right" },
						{ "type", zindex = 10, align = "right" },
						{ "last_modified", zindex = 10, align = "right" },
						{ "created", zindex = 10, align = "right" },
					},
				},
			},
			file = {
				{ "indent" },
				{ "icon" },
				{
					"container",
					content = {
						{
							"name",
							zindex = 10,
						},
						{
							"symlink_target",
							zindex = 10,
							highlight = "NeoTreeSymbolicLinkTarget",
						},
						{ "clipboard", zindex = 10 },
						{ "bufnr", zindex = 10 },
						{ "modified", zindex = 20, align = "right" },
						{ "git_status", zindex = 20, align = "right" },
						{ "diagnostics", zindex = 20, align = "right" },
						{ "file_size", zindex = 10, align = "right" },
						{ "type", zindex = 10, align = "right" },
						{ "last_modified", zindex = 10, align = "right" },
						{ "created", zindex = 10, align = "right" },
					},
				},
			},
		},
		popup_border_style = "NC", -- or "" to use 'winborder' on Neovim v0.11+
		indent = {
			indent_size = 2,
			padding = 2, -- extra padding on left hand side
		},
		window = {
			position = "left",
			width = 50,
		},
	},
	lazy = false, -- neo-tree will lazily load itself
}

return M

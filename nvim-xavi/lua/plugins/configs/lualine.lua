local icons = require("icons")

-- stylua: ignore
local colors = {
  blue   = '#80a0ff',
  cyan   = '#79dac8',
  black  = '#171B20',
  white  = '#c6c6c6',
  red    = '#ff5189',
  violet = '#B1A2FF',
  grey   = '#1D2228',
}

local xavi_theme = {
	normal = {
		a = { fg = colors.black, bg = colors.violet },
		b = { fg = colors.white, bg = colors.grey },
		c = { fg = colors.white },
	},

	insert = { a = { fg = colors.black, bg = colors.blue } },
	visual = { a = { fg = colors.black, bg = colors.cyan } },
	replace = { a = { fg = colors.black, bg = colors.red } },

	inactive = {
		a = { fg = colors.white, bg = colors.black },
		b = { fg = colors.white, bg = colors.black },
		c = { fg = colors.white },
	},
}

local M = {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			theme = xavi_theme,
			component_separators = "",
			-- section_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
		},
		sections = {
			-- lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
			lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
			lualine_b = { { "filename", path = 3 }, "branch" },
			lualine_c = {
				"%=", --[[ add your center components here in place of this comment ]]
			},
			lualine_x = {},
			lualine_y = { "filetype", "progress" },
			lualine_z = {
				-- { "location", separator = { right = "" }, left_padding = 2 },
				{ "location", separator = { right = "" }, left_padding = 2 },
			},
		},
		inactive_sections = {
			lualine_a = { "filename" },
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = { "location" },
		},
		always_show_tabline = true,
		tabline = {
			lualine_a = {
				{
					"tabs",
					mode = 1,
					show_modified_status = true, -- Shows a symbol next to the tab name if the file has been modified.
					symbols = {
						modified = icons.small_circle, -- Text to show when the file is modified.
					},
				},
			},
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = {},
		},
		extensions = {},
	},
}

return M

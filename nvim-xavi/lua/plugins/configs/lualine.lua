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
		c = { fg = colors.white, bg = colors.black },
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

local git_slug_cache = ""
local git_slug_cwd = ""

-- Filetypes to set minimal lualine info
local minimal_layout_filetypes = { "neo-tree", "snacks_terminal" }

local function git_slug()
	if vim.tbl_contains(minimal_layout_filetypes, vim.bo.filetype) then
		return ""
	end

	local cwd = vim.fn.getcwd()

	if cwd ~= git_slug_cwd then
		git_slug_cwd = cwd
		-- local result = vim.fn.system("git rev-parse --short HEAD 2>/dev/null")
		local result = vim.system({ "git", "rev-parse", "--short", "HEAD" }, { text = true }):wait()
		if result.code == 0 then
			git_slug_cache = result.stdout:gsub("%s+", "") -- trim whitespace/newline
		else
			git_slug_cache = ""
		end
	end

	return git_slug_cache
end

local function conditional_filename()
	if vim.tbl_contains(minimal_layout_filetypes, vim.bo.filetype) then
		return ""
	end

	return vim.fn.expand("%:t")
end

local function conditional_mode()
	if vim.tbl_contains(minimal_layout_filetypes, vim.bo.filetype) then
		return ""
	end

	return require("lualine.utils.mode").get_mode()
end

local function conditional_filetype()
	if vim.tbl_contains(minimal_layout_filetypes, vim.bo.filetype) then
		return ""
	end

	return vim.bo.filetype
end

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
			lualine_a = { { conditional_mode, separator = { left = "" }, right_padding = 2 } },
			lualine_b = { { conditional_filename }, { "branch" }, { git_slug } }, -- path = 3
			lualine_c = {
				"%=", --[[ add your center components here in place of this comment ]]
			},
			lualine_x = { "diagnostics" },
			lualine_y = { conditional_filetype, "progress" },
			lualine_z = {
				-- { "location", separator = { right = "" }, left_padding = 2 },
				{ "location", separator = { right = "" }, left_padding = 2 },
			},
		},
		inactive_sections = {
			lualine_a = { conditional_filename },
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = { "location" },
		},
		extensions = {},
	},
}

return M

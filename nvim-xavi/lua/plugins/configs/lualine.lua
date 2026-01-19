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
local git_cache_timer = nil

-- Invalidate git caches to force refresh on next call
local function invalidate_git_cache()
	git_slug_cwd = ""
end

local dap_filetypes = {
	"dapui_scopes",
	"dapui_breakpoints",
	"dapui_stacks",
	"dapui_watches",
	"dapui_console",
	"dap-repl",
}

local tree_filetypes = {
	"neo-tree",
}

local terminal_filetypes = {
	"snacks_terminal",
	"terminal",
}

local function git_slug()
	if vim.tbl_contains(dap_filetypes, vim.bo.filetype) then
		return ""
	end

	if vim.tbl_contains(tree_filetypes, vim.bo.filetype) then
		return ""
	end

	if vim.tbl_contains(terminal_filetypes, vim.bo.filetype) or vim.bo.buftype == "terminal" then
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
	if vim.tbl_contains(tree_filetypes, vim.bo.filetype) then
		return ""
	end

	return vim.fn.expand("%:t")
end

local function conditional_mode()
	if vim.tbl_contains(tree_filetypes, vim.bo.filetype) then
		return ""
	end

	return require("lualine.utils.mode").get_mode()
end

local function conditional_filetype()
	if vim.tbl_contains(dap_filetypes, vim.bo.filetype) then
		return ""
	end

	if vim.tbl_contains(tree_filetypes, vim.bo.filetype) then
		return ""
	end

	if vim.tbl_contains(terminal_filetypes, vim.bo.filetype) or vim.bo.buftype == "terminal" then
		return ""
	end

	return vim.bo.filetype
end

local function setup_git_cache_refresh()
	local group = vim.api.nvim_create_augroup("LualineGitCache", { clear = true })

	-- Invalidate cache when returning to neovim (after using git in terminal)
	vim.api.nvim_create_autocmd("FocusGained", {
		group = group,
		callback = invalidate_git_cache,
	})

	-- Invalidate cache when leaving terminal mode
	vim.api.nvim_create_autocmd("TermLeave", {
		group = group,
		callback = invalidate_git_cache,
	})

	-- Invalidate cache when directory changes
	vim.api.nvim_create_autocmd("DirChanged", {
		group = group,
		callback = invalidate_git_cache,
	})

	-- Invalidate cache on gitsigns updates
	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "GitSignsChanged",
		callback = invalidate_git_cache,
	})

	-- Invalidate cache on neogit events (commit, push, pull, branch changes, etc.)
	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = {
			"NeogitCommitComplete",
			"NeogitPushComplete",
			"NeogitPullComplete",
			"NeogitBranchCheckout",
			"NeogitBranchCreate",
			"NeogitBranchDelete",
			"NeogitBranchReset",
			"NeogitRebase",
			"NeogitReset",
			"NeogitMerge",
			"NeogitCherryPick",
			"NeogitRevert",
			"NeogitStash",
		},
		callback = invalidate_git_cache,
	})

	-- Timer-based refresh every 30 seconds
	if git_cache_timer then
		git_cache_timer:stop()
		git_cache_timer:close()
	end
	git_cache_timer = vim.uv.new_timer()
	git_cache_timer:start(
		30000,
		30000,
		vim.schedule_wrap(function()
			invalidate_git_cache()
		end)
	)
end

local M = {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function(_, opts)
		require("lualine").setup(opts)
		setup_git_cache_refresh()
	end,
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
			lualine_b = {
				{ conditional_filename },
				{
					"branch",
					cond = function()
						return not vim.tbl_contains(dap_filetypes, vim.bo.filetype)
					end,
				},
				{ git_slug },
			}, -- path = 3
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

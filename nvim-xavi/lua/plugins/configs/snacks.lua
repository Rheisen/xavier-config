local dashboard = {
	enabled = true,
	width = 60,
	row = nil, -- dashboard position. nil for center
	col = nil, -- dashboard position. nil for center
	pane_gap = 4, -- empty columns between vertical panes
	autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
	-- These settings are used by some built-in sections
	preset = {
		-- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
		---@type fun(cmd:string, opts:table)|nil
		pick = nil,
		-- Used by the `keys` section to show keymaps.
		-- Set your custom keymaps here.
		-- When using a function, the `items` argument are the default keymaps.
		keys = {
			{
				icon = " ",
				key = "f",
				desc = "Find File",
				action = ":lua Snacks.dashboard.pick('files', {hidden = true, ignored = true})",
			},
			{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
			{
				icon = " ",
				key = "g",
				desc = "Find Text",
				action = ":lua Snacks.dashboard.pick('live_grep')",
			},
			{
				icon = " ",
				key = "r",
				desc = "Recent Files",
				action = ":lua Snacks.dashboard.pick('oldfiles')",
			},
			{
				icon = " ",
				key = "c",
				desc = "Config",
				action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
			},
			{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
			{
				icon = "󰒲 ",
				key = "L",
				desc = "Lazy",
				action = ":Lazy",
				enabled = package.loaded.lazy ~= nil,
			},
			{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
		},
		-- Used by the `header` section
		header = [[
██╗  ██╗  █████╗  ██╗   ██╗ ██╗
╚██╗██╔╝ ██╔══██╗ ██║   ██║ ██║
 ╚███╔╝  ███████║ ╚██╗ ██╔╝ ██║
 ██╔██╗  ██╔══██║  ╚████╔╝  ██║
██╔╝ ██╗ ██║  ██║   ╚██╔╝   ██║
╚═╝  ╚═╝ ╚═╝  ╚═╝    ╚═╝    ╚═╝
				]],
	},
	-- item field formatters
	formats = {
		icon = function(item)
			if item.file and item.icon == "file" or item.icon == "directory" then
				return Snacks.dashboard.icon(item.file, item.icon)
			end
			return { item.icon, width = 2, hl = "icon" }
		end,
		footer = { "%s", align = "center" },
		header = { "%s", align = "center" },
		file = function(item, ctx)
			local fname = vim.fn.fnamemodify(item.file, ":~")
			fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
			if #fname > ctx.width then
				local dir = vim.fn.fnamemodify(fname, ":h")
				local file = vim.fn.fnamemodify(fname, ":t")
				if dir and file then
					file = file:sub(-(ctx.width - #dir - 2))
					fname = dir .. "/…" .. file
				end
			end
			local dir, file = fname:match("^(.*)/(.+)$")
			return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
		end,
	},
	sections = {
		{ section = "header" },
		{ section = "keys", gap = 1, padding = 1 },
		{ section = "startup" },
	},
}

local picker = {
	enabled = true,
	jump = {
		reuse_win = function(win)
			local buf = vim.api.nvim_win_get_buf(win)
			local bt = vim.bo[buf].buftype
			local ft = vim.bo[buf].filetype
			-- Don't reuse terminal or claude buffers
			return bt ~= "terminal" and ft ~= "claude"
		end,
	},
	win = {
		input = {
			keys = {
				["<C-j>"] = { "preview_scroll_down", mode = { "i", "n" } },
				["<C-k>"] = { "preview_scroll_up", mode = { "i", "n" } },
			},
		},
		list = {
			keys = {
				["<C-j>"] = "preview_scroll_down",
				["<C-k>"] = "preview_scroll_up",
			},
		},
	},
	icons = {
		files = {
			enabled = true, -- show file icons
			dir = "󰉋 ",
			dir_open = "󰝰 ",
			file = "󰈔 ",
		},
		keymaps = {
			nowait = "󰓅 ",
		},
		tree = {
			vertical = "│ ",
			middle = "├╴",
			last = "└╴",
		},
		undo = {
			saved = " ",
		},
		ui = {
			live = "󰐰 ",
			hidden = "h",
			ignored = "i",
			follow = "f",
			selected = "● ",
			unselected = "○ ",
			-- selected = " ",
		},
		git = {
			enabled = true, -- show git icons
			commit = "󰜘 ", -- used by git log
			staged = "●", -- staged changes. always overrides the type icons
			added = "",
			deleted = "",
			ignored = " ",
			modified = "○",
			renamed = "",
			unmerged = " ",
			untracked = "?",
		},
		diagnostics = {
			Error = " ",
			Warn = " ",
			Hint = " ",
			Info = " ",
		},
		lsp = {
			unavailable = "",
			enabled = " ",
			disabled = " ",
			attached = "󰖩 ",
		},
		kinds = {
			Array = " ",
			Boolean = "󰨙 ",
			Class = " ",
			Color = " ",
			Control = " ",
			Collapsed = " ",
			Constant = "󰏿 ",
			Constructor = " ",
			Copilot = " ",
			Enum = " ",
			EnumMember = " ",
			Event = " ",
			Field = " ",
			File = " ",
			Folder = " ",
			Function = "󰊕 ",
			Interface = " ",
			Key = " ",
			Keyword = " ",
			Method = "󰊕 ",
			Module = " ",
			Namespace = "󰦮 ",
			Null = " ",
			Number = "󰎠 ",
			Object = " ",
			Operator = " ",
			Package = " ",
			Property = " ",
			Reference = " ",
			Snippet = "󱄽 ",
			String = " ",
			Struct = "󰆼 ",
			Text = " ",
			TypeParameter = " ",
			Unit = " ",
			Unknown = " ",
			Value = " ",
			Variable = "󰀫 ",
		},
	},
}

local M = {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		dashboard = dashboard,
		explorer = { enabled = false, replace_netrw = false },
		picker = picker,
		terminal = {
			win = {
				wo = {
					winbar = "",
					number = true,
					linebreak = true,
				},
			},
		},
		indent = { enabled = true },
		input = { enabled = true },
		notifier = {
			enabled = true,
			timeout = 3000,
		},
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = {
			enabled = true,
			-- filter = function(buf)
			-- 	-- Disable scroll animation during search
			-- 	return vim.bo[buf].buftype ~= "" or vim.fn.mode() == "/"
			-- end,
		},
		statuscolumn = { enabled = true },
		words = {
			enabled = true,
			modes = { "n", "i", "c" }, -- modes to show references
		},
		styles = {
			zen = {
				width = 130,
			},
		},
	},
}

return M

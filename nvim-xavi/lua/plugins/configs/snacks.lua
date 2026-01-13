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
	-- layout = {
	-- 	box = "vertical",
	-- 	backdrop = false,
	-- 	row = -1,
	-- 	width = 0,
	-- 	height = 0.4,
	-- 	border = "top",
	-- 	title = " {title} {live} {flags}",
	-- 	title_pos = "left",
	-- 	{ win = "input", height = 1, border = "bottom" },
	-- 	{
	-- 		box = "horizontal",
	-- 		{ win = "list", border = "none" },
	-- 		{ win = "preview", title = "{preview}", width = 0.6, border = "left" },
	-- 	},
	-- },
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
		indent = { enabled = true },
		input = { enabled = true },
		notifier = {
			enabled = true,
			timeout = 3000,
		},
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
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
	keys = {
		-- Top Pickers
		{
			"<leader><space>",
			function()
				Snacks.picker.smart()
			end,
			desc = "Smart Find Files",
		},
		{
			"<leader>,",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>/",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>N",
			function()
				Snacks.picker.notifications()
			end,
			desc = "[N]otification History",
		},
		-- Find
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "[F]ind [B]uffers",
		},
		{
			"<leader>fc",
			function()
				Snacks.picker.files({ cwd = vim.fn.stdpath("config"), hidden = true })
			end,
			desc = "[F]ind [C]onfig File",
		},
		{
			"<leader>.",
			function()
				Snacks.picker.files({ cwd = vim.fn.expand("%:p:h"), hidden = true })
			end,
			desc = "[F]ind files in current file dir",
		},
		{
			"<leader>ff",
			function()
				Snacks.picker.files({ hidden = true, ignored = true })
			end,
			desc = "[F]ind [F]iles",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.git_files()
			end,
			desc = "[F]ind [G]it Files",
		},
		{
			"<leader>fp",
			function()
				Snacks.picker.projects()
			end,
			desc = "[F]ind [P]rojects",
		},
		{
			"<leader>fr",
			function()
				Snacks.picker.recent()
			end,
			desc = "[F]ind [R]ecent",
		},
		-- git
		{
			"<leader>vcb",
			function()
				Snacks.picker.git_branches()
			end,
			desc = "[V]ersion [C]ontrol: branches",
		},
		{
			"<leader>vlr",
			function()
				Snacks.picker.git_log()
			end,
			desc = "[V]ersion [L]og: repo",
		},
		{
			"<leader>vll",
			function()
				Snacks.picker.git_log_line()
			end,
			desc = "[V]ersion [L]og: line",
		},
		{
			"<leader>vlf",
			function()
				Snacks.picker.git_log_file()
			end,
			desc = "[V]ersion [L]og: file",
		},
		{
			"<leader>vs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "[V]ersion [s]tatus",
		},
		{
			"<leader>vS",
			function()
				Snacks.picker.git_stash()
			end,
			desc = "[V]ersion [S]tash",
		},
		{
			"<leader>vd",
			function()
				Snacks.picker.git_diff()
			end,
			desc = "[V]ersion [d]iff (hunks)",
		},
		{
			"<leader>j",
			function()
				Snacks.scratch()
			end,
			desc = "[J]ot buffer",
		},
		{
			"<leader>J",
			function()
				Snacks.scratch.select()
			end,
			desc = "[J]ot buffer select",
		},
		{
			"<leader>z",
			function()
				Snacks.zen()
			end,
			desc = "[Z]en mode toggle",
		},
	},
}

return M

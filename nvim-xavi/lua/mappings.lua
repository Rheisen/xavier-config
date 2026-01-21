local M = {}

function M.register(mappings)
	local present, which_key = pcall(require, "which-key")

	if present then
		which_key.add(mappings)
	end
end

local function get_args(config)
	local args = vim.fn.input({
		prompt = "Arguments: ",
		default = config.args and table.concat(config.args, " ") or "",
		completion = "file",
	})
	if args and args ~= "" then
		config.args = vim.split(args, " ", { trimempty = true })
	end
	return config
end

function M.setup()
	local keymap = vim.keymap
	local cmd = vim.cmd

	local mapping

	local function map(...)
		mapping = { ... }
	end

	-- Defer until VimEnter
	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy", -- or use "VimEnter" if not using lazy.nvim
		once = true,
		callback = function()
			for _, item in ipairs(mapping) do
				local mode = item.mode or "n"
				local opts = {
					desc = item.desc,
					silent = item.silent,
					has = item.has,
					nowait = item.nowait,
				}

				require("snacks").keymap.set(mode, item[1], item[2], opts)
			end
		end,
	})

	-- Leader
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	-- Disable native keybindings
	keymap.set("n", "q", "<Nop>")

	-- Basic remaps
	keymap.set("n", "0", "^")
	keymap.set("n", "^", "0")
	keymap.set("n", "zo", "zO")

	-- Respect wrapping with jk navigation & utilize jump list
	cmd("nnoremap <expr> j v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'j' : 'gj'")
	cmd("nnoremap <expr> k v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'k' : 'gk'")

	-- Yank and paste

	keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "[y]ank to clipboard" })
	keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "[p]aste from clipboard" })
	keymap.set("n", "<leader>P", '"+P', { desc = "[P]aste from clipboard" })

	-- Search highlighting

	keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true })
	keymap.set("n", "<leader>n", ":noh<CR>", { desc = "[n]o highlight", silent = true })

	-- Window navigation
	keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
	keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
	keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
	keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

	-- Neotree

	keymap.set("n", "<leader>t", ":Neotree toggle reveal<CR>", { desc = "[t]ree", silent = true })

	-- Language Server Protocol

	keymap.set("n", "K", function()
		vim.lsp.buf.hover({ border = "rounded", max_height = 25, max_width = 120 })
	end, { desc = "Hover documentation" })

	-- Version Control (Git)
	-- <leader>v -> version control (status, commit, push, pull, blame, preview)
	-- <leader>s -> staging
	-- <leader>u -> unstaging
	-- <leader>r -> resetting

	keymap.set("n", "<leader>vbl", ":Gitsigns toggle_current_line_blame<CR>", { desc = "", silent = true })
	keymap.set("n", "<leader>vph", ":Gitsigns preview_hunk<CR>", { desc = "", silent = true })

	keymap.set("n", "<leader>vs", ":Neogit kind=tab<CR>", { desc = "[v]ersion [s]tatus" })
	keymap.set("n", "<leader>vc", ":Neogit commit<CR>", { desc = "[v]ersion [c]ommit" })
	keymap.set("n", "<leader>vp", ":Neogit pull<CR>", { desc = "[v]ersion [p]ull" })
	keymap.set("n", "<leader>vP", ":Neogit push<CR>", { desc = "[v]ersion [P]ush" })

	-- Staging / Unstaging / Resetting
	-- NOTE: :Gitsigns stage_hunk toggles staging and unstaging hunks
	keymap.set({ "n", "v" }, "<leader>sh", ":Gitsigns stage_hunk<CR>", { desc = "[s]tage [h]unk" })
	keymap.set({ "n", "v" }, "<leader>uh", ":Gitsigns stage_hunk<CR>", { desc = "[u]nstage [h]unk" })
	keymap.set({ "n", "v" }, "<leader>rh", ":Gitsigns reset_hunk<CR>", { desc = "[r]eset [h]unk" })
	keymap.set("n", "<leader>sb", ":Gitsigns stage_buffer<CR>", { desc = "[s]tage [b]uffer" })
	keymap.set("n", "<leader>ub", function()
		require("gitsigns").reset_buffer_index()
	end, { desc = "[u]nstage [b]uffer" })
	keymap.set("n", "<leader>rb", ":Gitsigns reset_buffer<CR>", { desc = "[r]eset [b]uffer" })

	-- Motion
	keymap.set("n", "<leader>gh", function()
		if vim.wo.diff then
			return "]c"
		end
		vim.schedule(function()
			require("gitsigns").next_hunk()
		end)
		return "<Ignore>"
	end, { desc = "[g]oto [h]unk (next)", expr = true })

	keymap.set("n", "<leader>gH", function()
		if vim.wo.diff then
			return "[c"
		end
		vim.schedule(function()
			require("gitsigns").prev_hunk()
		end)
		return "<Ignore>"
	end, { desc = "[g]oto [H]unk (previous)", expr = true })
	-- Preview windows

	keymap.set(
		"n",
		"gpd",
		"<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
		{ desc = "[g]oto [p]review: [d]efinition", silent = true }
	)
	keymap.set(
		"n",
		"gpD",
		"<cmd>lua require('goto-preview').goto_preview_declaration()<CR>",
		{ desc = "[g]oto [p]review: [D]eclaration", silent = true }
	)
	keymap.set(
		"n",
		"gpt",
		"<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
		{ desc = "[g]oto [p]review: [t]ype definition", silent = true }
	)
	keymap.set(
		"n",
		"gpi",
		"<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
		{ desc = "[g]oto [p]review: [i]mplementation", silent = true }
	)
	keymap.set(
		"n",
		"gP",
		"<cmd>lua require('goto-preview').close_all_win()<CR>",
		{ desc = "[g]oto [P]review: close all windows", silent = true }
	)

	-- Top Pickers
	-- keymap.set("n", "<leader><space>", function()
	-- 	require("snacks").picker.smart()
	-- end, { desc = "smart find files" })
	keymap.set("n", "<leader>,", function()
		require("snacks").picker.buffers()
	end, { desc = "find buffers" })

	keymap.set("n", "<leader>/", function()
		require("snacks").picker.grep()
	end, { desc = "find text" })

	keymap.set("n", "<leader>N", function()
		require("snacks").picker.notifications()
	end, { desc = "[N]otification history" })

	-- Find

	keymap.set("n", "<leader>fb", function()
		require("snacks").picker.buffers()
	end, { desc = "[f]ind [b]uffers" })

	keymap.set("n", "<leader>fc", function()
		require("snacks").picker.files({ cwd = vim.fn.stdpath("config"), hidden = true })
	end, {
		desc = "[f]ind [c]onfig file",
	})
	keymap.set("n", "<leader>.", function()
		require("snacks").picker.files({ cwd = vim.fn.expand("%:p:h"), hidden = true })
	end, {
		desc = "[f]ind files in current([.]) dir",
	})

	map(
		{
			"<leader>ff",
			function()
				require("snacks").picker.files({ hidden = true, ignored = true })
			end,
			desc = "[f]ind [f]iles",
		},
		{
			"<leader>ft",
			function()
				require("snacks").picker.grep()
			end,
			desc = "[f]ind [t]ext",
		},
		{
			"<leader>fg",
			function()
				require("snacks").picker.git_files()
			end,
			desc = "[f]ind [g]it files",
		},
		{
			"<leader>fp",
			function()
				require("snacks").picker.projects()
			end,
			desc = "[f]ind [p]rojects",
		},
		{
			"<leader>fr",
			function()
				require("snacks").picker.recent()
			end,
			desc = "[f]ind [r]ecent",
		},
		-- git
		{
			"<leader>vb",
			function()
				require("snacks").picker.git_branches()
			end,
			desc = "[v]ersion [b]ranches",
		},
		{
			"<leader>vlr",
			function()
				require("snacks").picker.git_log()
			end,
			desc = "[v]ersion [l]og: [r]epo",
		},
		{
			"<leader>vll",
			function()
				require("snacks").picker.git_log_line()
			end,
			desc = "[v]ersion [l]og: [l]ine",
		},
		{
			"<leader>vlf",
			function()
				require("snacks").picker.git_log_file()
			end,
			desc = "[v]ersion [l]og: [f]ile",
		},
		{
			"<leader>vS",
			function()
				require("snacks").picker.git_stash()
			end,
			desc = "[v]ersion [S]tash",
		},
		{
			"<leader>vd",
			function()
				require("snacks").picker.git_diff()
			end,
			desc = "[v]ersion [d]iff (hunks)",
		},
		{
			"<leader>j",
			function()
				require("snacks").scratch()
			end,
			desc = "[j]ot buffer",
		},
		{
			"<leader>J",
			function()
				require("snacks").scratch.select()
			end,
			desc = "[J]ot buffer select",
		},
		{
			"<leader>z",
			function()
				require("snacks").zen()
			end,
			desc = "[z]en mode toggle",
		},
		{
			"gd",
			function()
				vim.lsp.buf.definition()
			end,
			desc = "[g]oto [d]efinition",
			has = "definition",
		},
		-- {
		-- 	"gr",
		-- 	function()
		-- 		vim.lsp.buf.references()
		-- 	end,
		-- 	desc = "References",
		-- 	nowait = true,
		-- },
		{
			"gI",
			function()
				vim.lsp.buf.implementation()
			end,
			desc = "[g]oto [I]mplementation",
		},
		{
			"gy",
			function()
				vim.lsp.buf.type_definition()
			end,
			desc = "[g]oto t[y]pe definition",
		},
		{
			"gD",
			function()
				vim.lsp.buf.declaration()
			end,
			desc = "[g]oto [D]eclaration",
		},
		-- DAP
		{
			"<leader>dB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "[d]ap [B]reakpoint condition",
		},
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "[d]ap [b]reakpoint toggle",
		},
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "[d]ap [c]ontinue",
		},
		{
			"<leader>da",
			function()
				require("dap").continue({ before = get_args })
			end,
			desc = "[d]ap run with [a]rgs",
		},
		{
			"<leader>dC",
			function()
				require("dap").run_to_cursor()
			end,
			desc = "[d]ap run to [C]ursor",
		},
		{
			"<leader>dg",
			function()
				require("dap").goto_()
			end,
			desc = "[d]ap [g]o to line (no execute)",
		},
		{
			"<leader>di",
			function()
				require("dap").step_into()
			end,
			desc = "[d]ap step [i]nto",
		},
		{
			"<leader>dj",
			function()
				require("dap").down()
			end,
			desc = "[d]ap down ([j])",
		},
		{
			"<leader>dk",
			function()
				require("dap").up()
			end,
			desc = "[d]ap up ([k])",
		},
		{
			"<leader>dl",
			function()
				require("dap").run_last()
			end,
			desc = "[d]ap run [l]ast",
		},
		{
			"<leader>do",
			function()
				require("dap").step_out()
			end,
			desc = "[d]ap step [o]ut",
		},
		{
			"<leader>dO",
			function()
				require("dap").step_over()
			end,
			desc = "[d]ap step [O]ver",
		},
		{
			"<leader>dP",
			function()
				require("dap").pause()
			end,
			desc = "[d]ap [P]ause",
		},
		{
			"<leader>dr",
			function()
				require("dap").repl.toggle()
			end,
			desc = "[d]ap toggle [r]epl",
		},
		{
			"<leader>ds",
			function()
				require("dap").session()
			end,
			desc = "[d]ap [s]ession",
		},
		{
			"<leader>dt",
			function()
				require("dap").terminate()
			end,
			desc = "[d]ap [t]erminate",
		},
		{
			"<leader>dw",
			function()
				require("dap.ui.widgets").hover()
			end,
			desc = "[d]ap [w]idgets",
		},
		{
			"<leader>du",
			function()
				require("dapui").toggle({})
			end,
			desc = "[d]ap [u]i",
		},
		{
			"<leader>de",
			function()
				require("dapui").eval()
			end,
			desc = "[d]ap [e]val",
			mode = { "n", "x" },
		}
		-- Noice
		--     { "<leader>sn", "", desc = "+noice"},
		--     { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
		--     { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
		--     { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
		--     { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
		--     { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
		--     { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice Picker (Telescope/FzfLua)" },
		--     { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
		--     { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
	)
end

return M

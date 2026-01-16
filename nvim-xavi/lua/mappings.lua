local M = {}

function M.register(mappings)
	local present, which_key = pcall(require, "which-key")

	if present then
		which_key.add(mappings)
	end
end

function M.setup()
	local keymap = vim.keymap
	local cmd = vim.cmd

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
	vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
	vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
	vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
	vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

	-- Neotree

	keymap.set("n", "<leader>t", ":Neotree toggle reveal<CR>", { desc = "[t]ree", silent = true })

	-- Language Server Protocol

	keymap.set("n", "K", function()
		vim.lsp.buf.hover({ border = "rounded", max_height = 25, max_width = 120 })
	end, { desc = "Hover documentation" })

	-- Version Control (Git)

	keymap.set("n", "<leader>vbl", ":Gitsigns toggle_current_line_blame<CR>", { desc = "", silent = true })
	keymap.set("n", "<leader>vph", ":Gitsigns preview_hunk<CR>", { desc = "", silent = true })

	keymap.set("n", "<leader>vs", ":Neogit kind=tab<CR>", { desc = "[v]ersion [s]tatus" })
	keymap.set("n", "<leader>vc", ":Neogit commit<CR>", { desc = "[v]ersion [c]ommit" })
	keymap.set("n", "<leader>vp", ":Neogit pull<CR>", { desc = "[v]ersion [p]ull" })
	keymap.set("n", "<leader>vP", ":Neogit push<CR>", { desc = "[v]ersion [P]ush" })

	-- NOTE: :Gitsigns stage_hunk toggles staging and unstaging hunks
	keymap.set({ "n", "v" }, "<leader>sh", ":Gitsigns stage_hunk<CR>", { desc = "[s]tage [h]unk" })
	keymap.set({ "n", "v" }, "<leader>uh", ":Gitsigns stage_hunk<CR>", { desc = "[u]nstage [h]unk" })
	keymap.set({ "n", "v" }, "<leader>rh", ":Gitsigns reset_hunk<CR>", { desc = "[r]eset [h]unk" })
	keymap.set("n", "<leader>sb", ":Gitsigns stage_buffer<CR>", { desc = "[s]tage [b]uffer" })
	keymap.set("n", "<leader>ub", function()
		require("gitsigns").reset_buffer_index()
	end, { desc = "[u]nstage [b]uffer" })
	keymap.set("n", "<leader>rb", ":Gitsigns reset_buffer<CR>", { desc = "[r]eset [b]uffer" })

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
end

return M

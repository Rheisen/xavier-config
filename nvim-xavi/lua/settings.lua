local M = {}

function M.setup()
	local cmd = vim.cmd
	local opt = vim.opt
	local icons = require("icons")
	local TERMINAL = vim.fn.expand("$TERMINAL")
	-- local CACHE_PATH = vim.fn.stdpath("cache")

	---  VIM ONLY COMMANDS  ---

	cmd("filetype plugin on") -- filetype detection
	cmd('let &titleold="' .. TERMINAL .. '"')
	cmd("set inccommand=split") -- show what you are substituting in real time
	cmd("set iskeyword+=-") -- treat dash as a separate word

	cmd("set wrap linebreak") -- wrap on words
	cmd("let &showbreak = '" .. icons.arrow.right_down_curved .. " '") -- change the wrapping symbol
	cmd("set whichwrap+=<,>,[,],h,l") -- move to next line with theses keys

	-- Automatically equalize splits when Vim is resized
	cmd("autocmd VimResized * wincmd =")

	---  SETTINGS  ---

	-- Behavioral
	opt.timeoutlen = 100 -- time to wait for a mapped sequence to complete (millis)
	opt.mouse = "a" -- allow the mouse to be used in neovim
	opt.mousemoveevent = true -- allows mouse hovers to be detected

	-- Window
	opt.signcolumn = "yes"
	opt.colorcolumn = "120"
	opt.number = true

	-- KEY MAPPINGS
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

	vim.keymap.set("n", "<leader>n", ":noh<CR>")

	vim.keymap.set("n", "<leader>xcs", ":tabedit $NVIMXAVI/lua/settings.lua<CR>")
	vim.keymap.set("n", "<leader>xcr", ":source $NVIMXAVI/lua/settings.lua<CR>")
end

return M

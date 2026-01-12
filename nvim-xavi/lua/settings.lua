local M = {}

function M.setup()
	local cmd = vim.cmd
	local opt = vim.opt
	local keymap = vim.keymap
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

	-- Folds

	opt.foldlevelstart = 99
	cmd("autocmd BufWinEnter * silent! :%foldopen!")

	-- KEY MAPPINGS

	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	keymap.set("n", "0", "^")
	keymap.set("n", "^", "0")
	keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

	keymap.set("n", "<leader>y", '"+y')
	keymap.set("n", "<leader>p", '"+p')
	keymap.set("n", "<leader>P", '"+P')
	keymap.set("n", "<leader>n", ":noh<CR>")

	keymap.set("n", "<leader>xso", ":tabedit $NVIMXAVI/lua/settings.lua<CR>")
	keymap.set("n", "<leader>xsr", ":source $NVIMXAVI/lua/settings.lua<CR>")

	-- keymap.set("n", "<leader>t", ":Neotree toggle reveal<CR>", { desc = "[T]oggle [T]ree" })

	keymap.set("n", "<leader>ff", ":FzfLua files<CR>", { desc = "[F]ind [F]ile" })

	vim.api.nvim_create_autocmd("TextYankPost", {
		desc = "Highlight when yanking (copying) text",
		group = vim.api.nvim_create_augroup("xavi-config", { clear = true }),
		callback = function()
			vim.hl.on_yank()
		end,
	})

	-- Diagnostic Config
	-- See :help vim.diagnostic.Opts
	vim.diagnostic.config({
		severity_sort = true,
		float = { border = "rounded", source = "if_many" },
		underline = { severity = vim.diagnostic.severity.ERROR },
		signs = vim.g.have_nerd_font and {
			text = {
				[vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
				[vim.diagnostic.severity.WARN] = icons.diagnostics.warning,
				[vim.diagnostic.severity.INFO] = icons.diagnostics.info,
				[vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
			},
		} or {},
		virtual_text = {
			source = "if_many",
			spacing = 2,
			format = function(diagnostic)
				local diagnostic_message = {
					[vim.diagnostic.severity.ERROR] = diagnostic.message,
					[vim.diagnostic.severity.WARN] = diagnostic.message,
					[vim.diagnostic.severity.INFO] = diagnostic.message,
					[vim.diagnostic.severity.HINT] = diagnostic.message,
				}
				return diagnostic_message[diagnostic.severity]
			end,
		},
	})
end

return M

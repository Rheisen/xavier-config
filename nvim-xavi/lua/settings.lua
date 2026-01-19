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

	-- Automatically open folds when a buffer is entered
	cmd("autocmd BufWinEnter * silent! :%foldopen!")

	-- Incrementing and decrementing
	cmd("set nrformats=")

	---  SETTINGS  ---

	-- Behavioral
	opt.timeoutlen = 100 -- time to wait for a mapped sequence to complete (millis)
	opt.updatetime = 200 -- decrease update time
	opt.mouse = "a" -- allow the mouse to be used in neovim
	opt.mousemoveevent = true -- allows mouse hovers to be detected

	opt.showmode = false

	opt.expandtab = true -- convert tabs to spaces
	opt.shiftwidth = 4 -- the number of spaces inserted for each indentation
	opt.softtabstop = 4 -- how many columns when you hit Tab in insert mode
	opt.tabstop = 4 -- how many columns a tab counts for

	-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
	opt.ignorecase = true
	opt.smartcase = true

	-- Window
	opt.signcolumn = "yes" -- Keep signcolumn on by default
	opt.colorcolumn = "120" -- Color column for visibility
	opt.winborder = "rounded"
	opt.number = true

	opt.termguicolors = true
	opt.cmdheight = 2

	-- Show which line your cursor is on
	-- opt.cursorline = true

	-- Minimal number of screen lines to keep above and below the cursor.
	opt.scrolloff = 25

	opt.confirm = true

	-- Folds
	opt.foldlevelstart = 99

	-- KEY MAPPINGS

	-- vim.g.mapleader = " "
	-- vim.g.maplocalleader = " "

	-- Updated key configuration

	-- keymap.set("n", "<leader>xso", ":tabedit $NVIMXAVI/lua/settings.lua<CR>")
	-- keymap.set("n", "<leader>xsr", ":source $NVIMXAVI/lua/settings.lua<CR>")

	-- keymap.set("n", "<leader>ff", ":FzfLua files<CR>", { desc = "[F]ind [F]ile" })
	-- vim.keymap.set('n', '<leader>ac', '<cmd>ClaudeCode<CR>', { desc = 'Toggle Claude Code' })

	-- Automatically fold imports
	vim.api.nvim_create_autocmd("LspNotify", {
		callback = function(args)
			if args.data.method == "textDocument/didOpen" then
				vim.lsp.foldclose("imports", vim.fn.bufwinid(args.buf))
			end
		end,
	})

	vim.api.nvim_create_autocmd("TextYankPost", {
		desc = "Highlight when yanking (copying) text",
		group = vim.api.nvim_create_augroup("xavi-config", { clear = true }),
		callback = function()
			vim.hl.on_yank()
		end,
	})

	vim.api.nvim_create_autocmd("TermOpen", {
		callback = function()
			if vim.bo.buflisted then
				vim.opt_local.number = true
			end
		end,
	})

	-- Disable auto-insert and show numbers for Claude terminal
	vim.api.nvim_create_autocmd("TermOpen", {
		pattern = "*",
		callback = function()
			local buf_name = vim.api.nvim_buf_get_name(0)
			if buf_name:match("claude") then
				vim.opt_local.number = true
				-- vim.keymap.set("t", "<CR>", "<CR><C-\\><C-n>", { buffer = true })
			end
		end,
	})

	-- Claude terminal: stay in normal mode and exit to normal after Enter
	-- vim.api.nvim_create_autocmd("BufEnter", {
	-- 	callback = function()
	-- 		if vim.bo.buftype == "terminal" and vim.api.nvim_buf_get_name(0):match("claude") then
	-- 			-- vim.opt_local.number = true
	-- 			-- vim.keymap.set("t", "<CR>", "<CR><C-\\><C-n>", { buffer = true })
	-- 		end
	-- 	end,
	-- })

	vim.api.nvim_create_autocmd("BufEnter", {
		callback = function()
			if vim.bo.buftype == "terminal" and vim.api.nvim_buf_get_name(0):match("claude") then
				-- vim.opt_local.number = true
				-- vim.defer_fn(function()
				vim.cmd("stopinsert")
				-- end, 10)
			end
		end,
	})

	vim.api.nvim_create_autocmd("WinEnter", {
		callback = function()
			if vim.bo.buftype == "terminal" and vim.api.nvim_buf_get_name(0):match("claude") then
				-- vim.opt_local.number = true
				vim.defer_fn(function()
					vim.cmd("stopinsert")
				end, 10)
			end
		end,
	})

	-- Diagnostic Config
	-- See :help vim.diagnostic.Opts
	vim.diagnostic.config({
		severity_sort = true,
		float = { border = "rounded", source = "if_many" },
		underline = { severity = vim.diagnostic.severity.ERROR },
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
				[vim.diagnostic.severity.WARN] = icons.diagnostics.warning,
				[vim.diagnostic.severity.INFO] = icons.diagnostics.info,
				[vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
			},
		},
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

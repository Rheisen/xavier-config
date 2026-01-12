local M = {}

function M.setup()
	vim.lsp.enable("gopls")
	vim.lsp.enable("lua_ls")
	vim.lsp.enable("ts_ls")

	-- vim.api.nvim_create_autocmd("LspAttach", {
	-- 	group = vim.api.nvim_create_augroup("xavi-config", { clear = true }),
	-- 	callback = function(event)
	-- 		-- NOTE: Remember that Lua is a real programming language, and as such it is possible
	-- 		-- to define small helper and utility functions so you don't have to repeat yourself.
	-- 		--
	-- 		-- In this case, we create a function that lets us more easily define mappings specific
	-- 		-- for LSP related items. It sets the mode, buffer and description for us each time.
	-- 		local map = function(keys, func, desc, mode)
	-- 			mode = mode or "n"
	-- 			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
	-- 		end
	--
	-- 		-- Rename the variable under your cursor.
	-- 		--  Most Language Servers support renaming across files, etc.
	-- 		-- map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
	--
	-- 		-- Execute a code action, usually your cursor needs to be on top of an error
	-- 		-- or a suggestion from your LSP for this to activate.
	-- 		-- map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
	--
	-- 		-- Find references for the word under your cursor.
	-- 		map("grr", require("plugins.configs.fzf").lsp_references, "[G]oto [R]eferences")
	--
	-- 		-- Jump to the implementation of the word under your cursor.
	-- 		--  Useful when your language has ways of declaring types without an actual implementation.
	-- 		map("gri", require("plugins.configs.fzf").lsp_implementations, "[G]oto [I]mplementation")
	--
	-- 		-- Jump to the definition of the word under your cursor.
	-- 		--  This is where a variable was first declared, or where a function is defined, etc.
	-- 	end,
	-- })
end

return M

local M = {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- or if using mini.icons/mini.nvim
	-- dependencies = { "nvim-mini/mini.icons" },
	opts = {},
	config = function()
		local fzf = require("fzf-lua")

		-- Override the default handlers globally
		vim.lsp.buf.references = fzf.lsp_references
		vim.lsp.buf.implementation = fzf.lsp_implementations
		vim.lsp.buf.definition = fzf.lsp_definitions
		vim.lsp.buf.type_definition = fzf.lsp_typedefs
		vim.lsp.buf.document_symbol = fzf.lsp_document_symbols
	end,
}

return M

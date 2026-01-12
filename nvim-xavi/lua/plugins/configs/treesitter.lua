local M = {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	lazy = false,
	opts = {
		install_dir = vim.fn.stdpath("data") .. "/site",
		indent = { enable = true },
		highlight = { enable = true },
		folds = { enable = true },
	},
}

function M.config()
	local treesitter = require("nvim-treesitter")

	treesitter.setup()

	treesitter
		.install({
			"bash",
			"c",
			"diff",
			"go",
			"gomod",
			"gosum",
			"gowork",
			"html",
			"javascript",
			"jsdoc",
			"json",
			"lua",
			"luadoc",
			"luap",
			"markdown",
			"markdown_inline",
			"printf",
			"python",
			"query",
			"regex",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"xml",
			"yaml",
		})
		:wait(30000)

	-- Enable treesitter capabilities
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("xavi_treesitter", { clear = true }),
		callback = function(args)
			local buf = args.buf
			local filetype = args.match

			-- Check if a parser exists for the current language
			local language = vim.treesitter.language.get_lang(filetype) or filetype
			if not vim.treesitter.language.add(language) then
				return
			end

			-- Folding
			vim.wo.foldmethod = "expr"
			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

			-- Highlighting
			vim.treesitter.start(buf, language)

			-- Indentation
			vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
	})
end

return M

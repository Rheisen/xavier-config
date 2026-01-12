local M = {
    "mason-org/mason-lspconfig.nvim",
    opts = {
		ensure_installed = {
			"lua_ls",
			"rust_analyzer",
			"gopls",
			"ts_ls",
		},
	},
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
}

return M


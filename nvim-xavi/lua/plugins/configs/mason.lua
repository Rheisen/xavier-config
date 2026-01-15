local M = {
	"mason-org/mason-lspconfig.nvim",
	dependencies = {
		{
			"mason-org/mason.nvim",
			opts = {},
		},
		"neovim/nvim-lspconfig",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
}

M.config = function()
	local servers = {
		lua_ls = {},
		rust_analyzer = {},
		gopls = {},
		ts_ls = {},
	}

	local ensure_servers_installed = vim.tbl_keys(servers or {})
	require("mason-lspconfig").setup({ ensure_installed = ensure_servers_installed })

	-- Formatters, linters, etc.
	local addons = {
		stylua = {},
		goimports = {},
		gofumpt = {},
	}

	local ensure_addons_installed = vim.tbl_keys(addons or {})
	require("mason-tool-installer").setup({ ensure_installed = ensure_addons_installed })
end

return M

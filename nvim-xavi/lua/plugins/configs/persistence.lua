local M = {
	-- 	"folke/persistence.nvim",
	-- 	event = "BufReadPre", -- this will only start session saving when an actual file was opened
	-- 	opts = {
	-- 		-- add any custom options here
	-- 	},
	-- 	config = function(_, opts)
	-- 		require("persistence").setup(opts)
	--
	-- 		-- Close neo-tree before saving session
	-- 		vim.api.nvim_create_autocmd("User", {
	-- 			pattern = "PersistenceSavePre",
	-- 			callback = function()
	-- 				vim.cmd("Neotree close")
	-- 			end,
	-- 		})
	--
	-- 		-- Reopen neo-tree after loading session
	-- 		vim.api.nvim_create_autocmd("User", {
	-- 			pattern = "PersistenceLoadPost",
	-- 			callback = function()
	-- 				vim.cmd("Neotree show")
	-- 			end,
	-- 		})
	-- 	end,
}
--
return M

local M = {}

function M.register(mappings)
	local present, which_key = pcall(require, "which-key")

	if present then
		which_key.add(mappings)
	end
end

function M.setup()
	-- Leader
	vim.g.mapleader = " "

	-- Disable native keybindings
	vim.keymap.set("n", "q", "<Nop>")

	-- Incrementing and decrementing
	vim.cmd("set nrformats=")

	-- Respect wrapping with jk navigation
	vim.cmd("nnoremap <expr> j v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'j' : 'gj'")
	vim.cmd("nnoremap <expr> k v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'k' : 'gk'")

	-- NOTE: Additional critical mappings are set in the `which-key` plugin's config,
	--       as we want to register using `M.register` only once that plugin is loaded.
	--       If you remove `which-key`, you should move those mappings here.
end

return M

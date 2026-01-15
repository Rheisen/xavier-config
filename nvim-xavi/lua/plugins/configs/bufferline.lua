local icons = require("icons")

local M = {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = {
		options = {
			mode = "tabs",
			max_name_length = 30,
			tab_size = 20,
			get_element_icon = function(element)
				local devicons = require("nvim-web-devicons")
				local icon = devicons.get_icon_by_filetype(element.filetype, { default = false })
				if not icon then
					if element.type == "terminal" then
						return icons.terminal, "BufferLineIconCustom"
					elseif element.filetype == "neo-tree" then
						return icons.folder.default, "BufferLineIconCustom"
					elseif element.filetype == "snacks_picker_input" or element.filetype == "snacks_picker_list" then
						return icons.lupa, "BufferLineIconCustom"
					elseif element.filetype == "snacks_picker_preview" then
						return icons.lupa, "BufferLineIconCustom"
					elseif element.path == "[No Name]" then
						return icons.sparkle, "BufferLineIconCustom"
					end

					vim.print("bufferline icon miss:", vim.inspect(element))
					icon = devicons.get_icon_by_filetype(element.filetype, { default = true })
				end
				return icon, "BufferLineIconCustom"
			end,
			numbers = function(opts)
				if vim.fn.tabpagenr("$") > 5 then
					return string.format("%s.", opts.ordinal)
				end

				return ""
			end,
			name_formatter = function(buf)
				-- term://~/.xavier-config//88660:claude --continue
				local ft = vim.bo[buf.bufnr].filetype
				local name = vim.fn.bufname(buf.bufnr)

				-- local name = buf.path or ""

				if ft == "neo-tree" then
					return "neotree"
				elseif ft == "snacks_picker_input" or ft == "snacks_picker_list" then
					return "search"
				elseif ft == "snacks_picker_preview" then
					return "preview"
				elseif name:match("^term.*claude") then
					return "claude"
				elseif buf.path == "[No Name]" then
					return "new"
				end

				return buf.name
			end,
			-- close_command = function(n)
			-- 	Snacks.bufdelete(n)
			-- end,
			-- right_mouse_command = function(n)
			-- 	Snacks.bufdelete(n)
			-- end,
			diagnostics = "nvim_lsp",
			always_show_bufferline = true,
			offsets = {
				{
					filetype = "neo-tree",
					text = "neotree",
					highlight = "Directory",
					text_align = "left",
				},
				{
					filetype = "snacks_layout_box",
				},
			},
		},
	},
	config = function(_, opts)
		vim.api.nvim_set_hl(0, "BufferLineIconCustom", { fg = "#B1A2FF" })
		require("bufferline").setup(opts)
	end,
	-- config = function(_, opts)
	-- 	require("bufferline").setup(opts)
	-- 	-- Fix bufferline when restoring a session
	-- 	vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
	-- 		callback = function()
	-- 			vim.schedule(function()
	-- 				pcall(nvim_bufferline)
	-- 			end)
	-- 		end,
	-- 	})
	-- end,
}

return M

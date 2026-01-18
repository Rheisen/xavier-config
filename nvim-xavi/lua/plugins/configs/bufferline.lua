local icons = require("icons")

-- bufferline icon miss:
-- {
--   directory = false,
--   extension = "",
--   filetype = "trouble",
--   path = "[No Name]",
--   type = "nofile"
-- }

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
					elseif element.filetype == "NeogitStatus" then
						return icons.git.logo, "BufferLineIconCustom"
					elseif element.path and element.path:match("NeogitCommitPopup") then
						return icons.git.commit, "BufferLineIconCustom"
					elseif element.path and element.path:match("NeogitHelpPopup") then
						return icons.diagnostics.hint, "BufferLineIconCustom"
					elseif element.path and element.path:match("Neogit(%w+)Popup") then
						return icons.git.logo, "BufferLineIconCustom"
					elseif element.filetype == "neo-tree" then
						return icons.folder.default, "BufferLineIconCustom"
					elseif element.filetype == "snacks_picker_input" or element.filetype == "snacks_picker_list" then
						return icons.lupa, "BufferLineIconCustom"
					elseif element.filetype == "snacks_picker_preview" then
						return icons.lupa, "BufferLineIconCustom"
					elseif element.filetype == "neo-tree-popup" then
						return icons.folder.default, "BufferLineIconCustom"
					elseif element.filetype == "snacks_input" then
						return icons.filled_lightning, "BufferLineIconCustom"
					elseif element.filetype == "markdown.snacks_picker_preview" then
						return icons.file.page, "BufferLineIconCustom"
					elseif element.path == "[No Name]" then
						vim.print("bufferline icon miss:", vim.inspect(element))
						return icons.file.page, "BufferLineIconCustom"
					end

					-- vim.print("bufferline icon miss:", vim.inspect(element))
					icon = devicons.get_icon_by_filetype(element.filetype, { default = true })
				elseif element.filetype == "gitcommit" or (element.path and element.path:match("COMMIT_EDITMSG$")) then
					return icons.git.commit, "BufferLineIconCustom" -- override the commit message icon
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
				elseif buf.path and buf.path:match("Neogit(%w+)Popup") then
					local popup_type = buf.path:match("Neogit(%w+)Popup")
					return "neogit " .. popup_type:lower()
				elseif ft and ft:match("^Neogit(%w+)") then
					local neogit_type = ft:match("^Neogit(%w+)")
					local spaced = neogit_type:gsub("(%l)(%u)", "%1 %2"):lower()
					return "neogit " .. spaced
				elseif ft == "gitcommit" or (name and name:match("COMMIT_EDITMSG$")) then
					return "commit message"
				elseif ft == "snacks_input" then
					return "input"
				elseif ft == "markdown.snacks_picker_preview" then
					return "preview"
				elseif ft == "neo-tree-popup" and buf.path == "[No Name]" then
					return "neotree"
				elseif buf.path == "[No Name]" then
					return icons.file.page
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

local M = {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
		"ray-x/yamlmatter.nvim",
	},
	ft = { "markdown", "quarto", "rmd", "Avante", "noice" },
}

-- local _toggle_state = true

function M.init()
	require("mappings").register({
		{ "<leader>M", group = "[M]arkdown" },
		{
			"<leader>Mr",
			function()
				vim.cmd("RenderMarkdown toggle")
				-- local _, present = pcall(require, "yamlmatter")
				-- if present then
				-- 	if _toggle_state then
				-- 		vim.cmd("YamlMatterDisable")
				-- 	else
				-- 		vim.cmd("YamlMatter")
				-- 	end
				-- end
				-- _toggle_state = not _toggle_state
			end,
			desc = "[M]arkdown [r]endering",
		},
	})
end

function M.config()
	local icons = require("icons")
	local block = icons.bar.vertical_block

	local base = "#B1A2FF"

	vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { fg = base, bg = "#1D2228", bold = true })
	vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { fg = base, bg = "#1D2228", bold = true })
	vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { fg = base, bg = "#1D2228", bold = true })
	vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { fg = base, bg = "#1D2228", bold = true })
	vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { fg = base, bg = "#1D2228", bold = true })
	vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { fg = base, bg = "#1D2228", bold = true })

	require("render-markdown").setup({
		render_modes = { "n", "no", "i", "v", "V", "^V", "r", "x", "c" },
		file_types = { "markdown", "quarto", "rmd", "Avante", "noice" },

		completions = {
			-- Settings for blink.cmp completions source
			blink = { enabled = true },
			lsp = { enabled = true },
		},

		link = {
			-- Inlined with 'image' elements.
			image = "󰥶 ",
			-- Inlined with 'email_autolink' elements.
			email = "󰀓 ",
			-- Fallback icon for 'inline_link' and 'uri_autolink' elements.
			hyperlink = "󰌹 ",
		},

		heading = {
			-- Turn on / off heading icon & background rendering
			enabled = true,
			-- Turn on / off a border on top and bottom of the heading
			border = true,
			-- Apply the prefix icons to the border if `border = true`
			-- border_prefix = true,
			border_prefix = false,
			-- Turn on / off any sign column related rendering
			sign = false,
			-- Width of the heading background:
			--  block: width of the heading text
			--  full: full width of the window
			width = "full",
			-- Amount of padding to add to the left of headings
			-- If a floating point value < 1 is provided it is treated as a percentage of the available window space
			left_pad = 0,
			-- Amount of padding to add to the right of headings when width is 'block'
			right_pad = 2,
			-- Amount of margin to add to the left of headings
			-- If a floating point value < 1 is provided it is treated as a percentage of the available window space
			-- Margin available space is computed after accounting for padding
			left_margin = 0,

			-- Minimum width to use for headings when width is 'block'
			min_width = 30,
			-- Determines how the icon fills the available space:
			--  inline: underlying '#'s are concealed resulting in a left aligned icon
			--  overlay: result is left padded with spaces to hide any additional '#'
			position = "inline",
			-- Replaces '#+' of 'atx_h._marker'
			-- The number of '#' in the heading determines the 'level'
			-- The 'level' is used to index into the array using a cycle
			-- The result is left padded with spaces to hide any additional '#'
			icons = {
				block .. block .. block .. block .. block .. block .. " " .. icons.numbers.header[1] .. " ",
				block .. block .. block .. block .. block .. " " .. icons.numbers.header[2] .. " ",
				block .. block .. block .. block .. " " .. icons.numbers.header[3] .. " ",
				block .. block .. block .. " " .. icons.numbers.header[4] .. " ",
				block .. block .. " " .. icons.numbers.header[5] .. " ",
				block .. " " .. icons.numbers.header[6] .. " ",
			},
			-- icons = { "", "", "", "", "", "" },
			-- Highlight for the heading icon and extends through the entire line
			backgrounds = {
				"RenderMarkdownH1Bg",
				"RenderMarkdownH2Bg",
				"RenderMarkdownH3Bg",
				"RenderMarkdownH4Bg",
				"RenderMarkdownH5Bg",
				"RenderMarkdownH6Bg",
			},
			-- The 'level' is used to index into the array using a clamp
			-- Highlight for the heading and sign icons
			foregrounds = {
				"RenderMarkdownH1",
				"RenderMarkdownH2",
				"RenderMarkdownH3",
				"RenderMarkdownH4",
				"RenderMarkdownH5",
				"RenderMarkdownH6",
			},
		},

		sign = {
			enabled = false,
		},

		code = {
			-- Turn on / off code block & inline code rendering
			enabled = true,
			-- Turn on / off any sign column related rendering
			sign = false,
			-- Determines how code blocks & inline code are rendered:
			--  none: disables all rendering
			--  normal: adds highlight group to code blocks & inline code, adds padding to code blocks
			--  language: adds language icon to sign column if enabled and icon + name above code blocks
			--  full: normal + language
			style = "full",
			-- Width of the code block background:
			-- * full: full width of the window
			-- * block: width of the code block
			width = "block",
			-- Determines where language icon is rendered:
			--  right: Right side of code block
			--  left: Left side of code block
			position = "right",
			-- Amount of padding to add around the language
			-- If a floating point value < 1 is provided it is treated as a percentage of the available window space
			language_pad = 2,
			-- Used above code blocks for thin border
			above = icons.bar.lower_horizontal_thick,
			-- Used below code blocks for thin border
			below = icons.bar.upper_horizontal_thick,
			-- Amount of margin to add to the left of code blocks.
			-- If a float < 1 is provided it is treated as a percentage of available window space.
			-- Margin available space is computed after accounting for padding.
			left_margin = 0,
			-- Amount of padding to add to the left of code blocks.
			-- If a float < 1 is provided it is treated as a percentage of available window space.
			left_pad = 0,
			-- Amount of padding to add to the right of code blocks when width is 'block'.
			-- If a float < 1 is provided it is treated as a percentage of available window space.
			right_pad = 2,
			-- Minimum width to use for code blocks when width is 'block'.
			min_width = 40,
			-- Determines how the top / bottom of code block are rendered.
			-- | none  | do not render a border                               |
			-- | thick | use the same highlight as the code body              |
			-- | thin  | when lines are empty overlay the above & below icons |
			-- | hide  | conceal lines unless language name or icon is added  |
			border = "thin",
			-- Padding to add to the left & right of inline code.
			inline_pad = 1,
			highlight = "RenderMarkdownCode",
		},

		latex = {
			enabled = true, -- using mdmath plugin
			converter = "latex2text",
		},

		bullet = {
			enabled = true,
			icons = { icons.small_circle },
			right_pad = 0,
		},

		overrides = {
			buftype = {
				-- Particularly for LSP hover
				nofile = {
					anti_conceal = {
						enabled = false,
					},
					win_options = {
						conceallevel = {
							rendered = 3,
						},
						concealcursor = {
							rendered = "n",
						},
					},
					code = {
						enabled = true,
						sign = false,
						style = "normal",
						width = "full",
						left_pad = 0,
						right_pad = 0,
						border = "thick",
						highlight = "RenderMarkdownCodeNoFile",
					},
					heading = {
						border = false,
						left_pad = 0,
						icons = {
							block .. " ",
							block .. block .. " ",
							block .. block .. block .. " ",
							block .. block .. block .. block .. " ",
							block .. block .. block .. block .. block .. " ",
							block .. block .. block .. block .. block .. block .. " ",
						},
					},
				},
			},
		},
	})

	-- local hls = require("highlights")
	-- -- local colors = hls.colors()
	-- hls.register_hls({
	-- 	-- RenderMarkdownH1 = { fg = colors.cyan_virtual_fg, bg = colors.cyan_virtual_bg, bold = true },
	-- 	-- RenderMarkdownH1Bg = { fg = colors.cyan_virtual_fg, bg = colors.cyan_virtual_bg, bold = true },
	-- 	-- RenderMarkdownH2 = { fg = colors.green_virtual_fg, bg = colors.green_virtual_bg, bold = true },
	-- 	-- RenderMarkdownH2Bg = { fg = colors.green_virtual_fg, bg = colors.green_virtual_bg, bold = true },
	-- 	-- RenderMarkdownH3 = { fg = colors.yellow_virtual_fg, bg = colors.yellow_virtual_bg, bold = true },
	-- 	-- RenderMarkdownH3Bg = { fg = colors.yellow_virtual_fg, bg = colors.yellow_virtual_bg, bold = true },
	-- 	-- RenderMarkdownH4 = { fg = colors.red_virtual_fg, bg = colors.red_virtual_bg, bold = true },
	-- 	-- RenderMarkdownH4Bg = { fg = colors.red_virtual_fg, bg = colors.red_virtual_bg, bold = true },
	-- 	-- RenderMarkdownH5 = { fg = colors.blue_virtual_fg, bg = colors.blue_virtual_bg, bold = true },
	-- 	-- RenderMarkdownH5Bg = { fg = colors.blue_virtual_fg, bg = colors.blue_virtual_bg, bold = true },
	-- 	-- RenderMarkdownH6 = { fg = colors.blue_virtual_fg, bg = colors.blue_virtual_bg, bold = true },
	-- 	-- RenderMarkdownH6Bg = { fg = colors.blue_virtual_fg, bg = colors.blue_virtual_bg, bold = true },
	-- 	RenderMarkdownH1 = { bold = true },
	-- 	RenderMarkdownH1Bg = { bold = true },
	-- 	RenderMarkdownH2 = { bold = true },
	-- 	RenderMarkdownH2Bg = { bold = true },
	-- 	RenderMarkdownH3 = { bold = true },
	-- 	RenderMarkdownH3Bg = { bold = true },
	-- 	RenderMarkdownH4 = { bold = true },
	-- 	RenderMarkdownH4Bg = { bold = true },
	-- 	RenderMarkdownH5 = { bold = true },
	-- 	RenderMarkdownH5Bg = { bold = true },
	-- 	RenderMarkdownH6 = { bold = true },
	-- 	RenderMarkdownH6Bg = { bold = true },
	-- 	-- RenderMarkdownCode = { bg = colors.statusline_bg },
	-- 	-- RenderMarkdownCodeNoFile = { bg = colors.statusline_bg },
	-- })
end

return M

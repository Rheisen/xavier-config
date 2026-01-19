vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("settings").setup()
require("lsp").setup()
require("mappings").setup()
require("plugins").setup()

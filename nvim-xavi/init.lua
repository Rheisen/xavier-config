vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("settings").setup()
require("plugins").setup()
require("lsp").setup()

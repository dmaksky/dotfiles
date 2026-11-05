vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('config.options')
require('config.plugins')
require('config.autocmds')
require('config.lsp')
require('config.keymaps')
require('config.navigation')

vim.cmd.colorscheme('catppuccin-nvim')

require('plugins.lualine')
require('plugins.cattpuccin')
require('plugins.telescope')
require('plugins.treesitter')

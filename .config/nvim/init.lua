vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('config.options')
require('config.plugins')

vim.cmd.colorscheme('catppuccin')

require('config.autocmds')
require('config.lsp')
require('config.keymaps')
require('config.navigation')
require('config.statusline')

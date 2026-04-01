local g = vim.g

g.mapleader = ' '
g.maplocalleader = g.mapleader

if vim.fn.has('termguicolors') == 1 then
  vim.opt.termguicolors = true
end

require("config.plugins")
require("plugins")

require("config.lsp")
require("config.options")
require("config.keymaps")
require("config.autocmds")

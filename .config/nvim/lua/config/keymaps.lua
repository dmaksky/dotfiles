local map = vim.keymap.set
local builtin = require('telescope.builtin')

-- Search
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Telescope
vim.keymap.set('n', '<leader>ff', function()
  builtin.find_files({
    hidden = true,
    find_command = { 'rg', '--files', '-g', '!.git/' },
  })
end, { desc = 'Find files' })

-- search hidden files in telescope (except .git)
vim.keymap.set('n', '<leader>fg', function()
  builtin.live_grep({
    additional_args = { '--hidden', '-g', '!.git/' },
  })
end, { desc = 'Live grep' })

map('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
map('n', '<leader>fd', builtin.diagnostics, { desc = 'Diagnostics' })
map('n', '<leader>fws', builtin.lsp_workspace_symbols, { desc = 'Workspace symbols' })
map('n', '<leader>fr', builtin.lsp_references, { desc = 'References' })
map('n', '<leader>fic', builtin.lsp_incoming_calls, { desc = 'Incoming calls' })
map('n', '<leader>foc', builtin.lsp_outgoing_calls, { desc = 'Outgoing calls' })
map('n', '<leader>fgs', builtin.git_status, { desc = 'Git status' })

-- Move lines
map('x', 'J', ":m '>+1<CR>gv=gv")
map('x', 'K', ":m '<-2<CR>gv=gv")

-- Join lines without moving cursor
map('n', 'J', 'mzJ`z')

-- Scrolling
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- Clipboard
map('x', '<leader>p', '"_dP')
map({ 'n', 'x' }, '<leader>y', '"+y')
map('n', '<leader>Y', '"+Y')

-- Formatting
map({ 'n', 'x' }, '<leader>cf', function()
  vim.lsp.buf.format()
end, { desc = 'Format with LSP' })

-- File browser
map('n', '<leader>e', function()
  local file = vim.api.nvim_buf_get_name(0)
  local dir = file ~= '' and vim.fs.dirname(file) or vim.fn.getcwd()

  vim.cmd.edit(vim.fn.fnameescape(dir))
end, { desc = 'File browser' })

-- Undotree
map('n', '<leader>u', function()
  vim.cmd.packadd('nvim.undotree')
  vim.cmd.Undotree()
end, { desc = 'Toggle Undotree' })

-- Restart
map('n', '<leader>r', '<cmd>restart<CR>', {
  desc = 'Restart Neovim',
})

-- Flush colors when searching
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>', { silent = true })

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff',  builtin.find_files,            { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg',  builtin.live_grep,             { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb',  builtin.buffers,               { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fd',  builtin.diagnostics,           { desc = 'Telescope diagnostics' })
vim.keymap.set('n', '<leader>fws', builtin.lsp_workspace_symbols, { desc = 'Telescope workspace symbols' })
vim.keymap.set('n', '<leader>fr',  builtin.lsp_references,        { desc = 'Telescope references' })
vim.keymap.set('n', '<leader>fic', builtin.lsp_incoming_calls,    { desc = 'Telescope incoming calls' })
vim.keymap.set('n', '<leader>foc', builtin.lsp_outgoing_calls,    { desc = 'Telescope outgoing calls' })

-- Move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Split lines
vim.keymap.set("n", "J", "mzJ`z")

-- Navigation
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Hacks ???
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Visual * / # search
_G.VSetSearch = function(cmdtype)
  local temp = vim.fn.getreg("s")
  vim.cmd('normal! gv"sy')
  vim.fn.setreg(
    "/",
    "\\V" .. vim.fn.substitute(vim.fn.escape(vim.fn.getreg("s"), cmdtype .. "\\"), "\n", "\\n", "g")
  )
  vim.fn.setreg("s", temp)
end
vim.keymap.set("x", "*", [[:<C-u>lua VSetSearch('/')<CR>/<C-R>=@/<CR><CR>]], { noremap = true })
vim.keymap.set("x", "#", [[:<C-u>lua VSetSearch('?')<CR>?<C-R>=@/<CR><CR>]], { noremap = true })

vim.keymap.set('n', '<leader>cf', function() require('config.format').format() end,
  { desc = 'Format buffer (explicit)' })
vim.keymap.set('n', '<leader>e', '<cmd>Explore<CR>', { desc = 'File browser' })
vim.keymap.set('n', '<leader>ud', '<cmd>undolist<CR>', { desc = 'Undo branches' })

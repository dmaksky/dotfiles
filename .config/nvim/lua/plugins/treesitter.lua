vim.api.nvim_create_user_command('TSInstallDefaults', function()
  require('nvim-treesitter').install({
    'c', 'cpp', 'python', 'lua', 'vim', 'vimdoc', 'bash', 'markdown', 'markdown_inline',
  })
end, { desc = 'Install the dotfiles parser set (explicit network operation)' })

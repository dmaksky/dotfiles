vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
})

vim.api.nvim_create_user_command('TSInstallDefaults', function()
  require('nvim-treesitter').install({
    'c', 'cpp', 'python', 'lua', 'vim', 'vimdoc', 'bash', 'markdown', 'markdown_inline',
  })
end, { desc = 'Install the dotfiles parser set (explicit network operation)' })

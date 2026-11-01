local group = vim.api.nvim_create_augroup('Dotfiles', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = group,
  callback = function(ev)
    vim.opt_local.formatoptions:remove({ 'r', 'o' })

    if vim.bo[ev.buf].buftype == '' then
      pcall(vim.treesitter.start, ev.buf)
    end
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = group,
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = group,
  callback = function()
    local view = vim.fn.winsaveview()

    vim.cmd([[keepjumps keeppatterns %s/\s\+$//e]])

    vim.fn.winrestview(view)
  end,
})

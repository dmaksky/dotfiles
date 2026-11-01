local group = vim.api.nvim_create_augroup('DotfilesEditing', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  callback = function(ev)
    vim.opt_local.formatoptions:remove({ 'r', 'o' })
    if vim.bo[ev.buf].buftype ~= '' then return end
    -- Missing parsers are normal; installing them is an explicit action.
    pcall(vim.treesitter.start, ev.buf)
  end,
})
vim.api.nvim_create_autocmd('TextYankPost', {
  group = group,
  callback = function() vim.hl.on_yank() end,
})

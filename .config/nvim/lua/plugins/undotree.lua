-- Define the directory to store undo files
local undodir = vim.fn.stdpath('data') .. '/undotree'

-- Create the directory if it doesn't exist
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, 'p')
end

-- Enable persistent undo and set the directory
vim.opt.undodir = undodir
vim.opt.undofile = true

local opt = vim.opt
local g = vim.g

-- Number lines
opt.number = true
opt.relativenumber = true

-- Scrolling
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false

-- Sign column
opt.signcolumn = 'yes'

-- Don't print welcome message
opt.shortmess:append("I")

-- Show different not printable chars
opt.list = true
opt.listchars = {
  tab = '→ ',
  lead = '·',
  trail = '·',
  nbsp = '␣',
  extends = '⟩',
  precedes = '⟨',
}

-- Tabs and formatting
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.smartindent = true
opt.breakindent = true
opt.textwidth = 0
opt.colorcolumn = "81"
opt.formatoptions = 'cqjnl'

-- Searching
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"
opt.infercase = true

-- Files and Buffers
opt.clipboard = "unnamedplus"
opt.swapfile = false
opt.undofile = true
opt.confirm = true

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Folding
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevelstart = 99

-- Mouse
opt.mouse = "a"
opt.whichwrap = 'h,l,<,>,[,]'

-- Command-line completion
opt.wildmode = "longest:full,full"
opt.wildignore:append {
  '*.o',
  '*.obj',
  '*.pyc',
  '*.so',
  '.git',
  '.svn',
  '__pycache__',
}

-- Sessions
opt.sessionoptions:append("localoptions")

-- Timeouts
opt.timeoutlen = 500
opt.updatetime = 200

-- Netrw
g.netrw_keepdir = 0
g.netrw_winsize = 30
g.netrw_banner = 0
g.netrw_liststyle = 3
g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]]

-- Cursor
opt.guicursor = "i:block"

-- Colorscheme
opt.termguicolors = true
opt.background = 'light'
vim.cmd.colorscheme('catppuccin')

opt.completeopt = { "menu", "menuone", "noselect", "popup" }
opt.laststatus = 3

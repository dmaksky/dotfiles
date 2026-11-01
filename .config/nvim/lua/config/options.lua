local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'
opt.laststatus = 3
opt.termguicolors = true
opt.background = 'light'
opt.shortmess:append('I')

-- Scrolling
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.breakindent = true

-- Whitespace
opt.list = true
opt.listchars = {
  tab = '→ ',
  lead = '·',
  trail = '·',
  nbsp = '␣',
  extends = '⟩',
  precedes = '⟨',
}

-- Indentation
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.smartindent = true
opt.colorcolumn = '81'

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = 'split'

-- Files
opt.undofile = true
opt.confirm = true

-- Windows
opt.splitbelow = true
opt.splitright = true

-- Folding
opt.foldmethod = 'expr'
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
opt.foldlevelstart = 99

-- Completion
opt.completeopt = { 'menu', 'menuone', 'noselect', 'popup' }
opt.wildmode = 'longest:full,full'

-- Timing
opt.timeoutlen = 500
opt.updatetime = 200

-- Other
opt.mouse = 'a'
opt.whichwrap = 'h,l,<,>,[,]'
opt.sessionoptions:append('localoptions')

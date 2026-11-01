-- Run with the configured Neovim in an isolated XDG environment (see README).
local function check()
  assert(vim.g.colors_name == 'catppuccin')
  assert(#vim.tbl_filter(function(plugin) return plugin.active end, vim.pack.get()) == 6)
  assert(vim.fn.exists(':Telescope') == 2)
  assert(vim.fn.exists(':TSInstallDefaults') == 2)
  assert(vim.fn.maparg('<C-h>', 'n') ~= '')
  assert(vim.lsp.config.clangd.cmd[2] == '--function-arg-placeholders=false')
  assert(vim.lsp.config.pyright.root_markers)
  for _, name in ipairs({ 'clangd', 'pyright', 'lua_ls', 'bashls', 'marksman' }) do
    vim.lsp.enable(name, false)
  end

  local dir = vim.fn.tempname()
  vim.fn.mkdir(dir, 'p')
  vim.cmd.edit(dir .. '/example.md')
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'hard break  ', 'next line' })
  vim.cmd.write()
  assert(vim.fn.readfile(dir .. '/example.md')[1] == 'hard break  ')
  vim.cmd.enew()
  vim.v.errmsg = ''
  vim.bo.filetype = 'no_parser_for_this_type'
  assert(vim.v.errmsg == '', vim.v.errmsg)
  assert(vim.fn.undofile(dir .. '/example.md') ~= '')

  local status = require('config.statusline').render()
  assert(vim.api.nvim_eval_statusline(status, {}).str ~= '')
  require('telescope.builtin').find_files({ cwd = dir })
  assert(vim.bo.filetype == 'TelescopePrompt')
  require('telescope.actions').close(vim.api.nvim_get_current_buf())
  print('PASS: startup, plugins, theme, filetypes, Markdown, Telescope')
end

local ok, err = xpcall(check, debug.traceback)
if not ok then
  io.stderr:write(err .. '\n')
  vim.cmd.cquit(1)
else
  vim.cmd('qa!')
end

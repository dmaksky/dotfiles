-- Run with the configured Neovim in an isolated XDG environment (see README).
local function check()
  assert(vim.g.colors_name == 'catppuccin')
  assert(#vim.pack.get() == 7)
  assert(vim.fn.exists(':Telescope') == 2)
  assert(vim.fn.exists(':TSInstallDefaults') == 2)
  assert(vim.fn.maparg('ys', 'n') ~= '')
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

  vim.cmd.edit(dir .. '/example.c')
  local original = 'int main(){return 0;}'
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { original })
  vim.cmd.write()
  local tick = vim.api.nvim_buf_get_changedtick(0)
  require('config.format').format()
  assert(vim.wait(5000, function() return vim.api.nvim_buf_get_changedtick(0) > tick end))
  assert(vim.api.nvim_get_current_line() ~= original)
  vim.cmd.undo()
  assert(vim.api.nvim_get_current_line() == original, 'format must be undoable')

  -- Control the async boundary to test edits made while the process is running.
  local system, notify = vim.system, vim.notify
  local callback, message
  vim.system = function(_, _, cb) callback = cb end
  vim.notify = function(msg) message = msg end
  require('config.format').format()
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'newer edit' })
  callback({ code = 0, stdout = 'stale result\n' })
  assert(vim.wait(1000, function() return message ~= nil end))
  assert(vim.api.nvim_get_current_line() == 'newer edit')
  assert(message:match('discarded'))
  message = nil
  require('config.format').format()
  callback({ code = 1, stderr = 'formatter error' })
  assert(vim.wait(1000, function() return message ~= nil end))
  assert(message:match('formatter error'))
  assert(vim.api.nvim_get_current_line() == 'newer edit')
  vim.system, vim.notify = system, notify

  local executable = vim.fn.executable
  vim.fn.executable = function() return 0 end
  vim.notify = function(msg) message = msg end
  require('config.format').format()
  assert(message:match('Install clang%-format'))
  vim.fn.executable, vim.notify = executable, notify

  local status = require('config.statusline').render()
  assert(vim.api.nvim_eval_statusline(status, {}).str ~= '')
  require('telescope.builtin').find_files({ cwd = dir })
  assert(vim.bo.filetype == 'TelescopePrompt')
  require('telescope.actions').close(vim.api.nvim_get_current_buf())
  print('PASS: startup, plugins, theme, filetypes, Markdown, formatting, undo, async safety, Telescope')
end

local ok, err = xpcall(check, debug.traceback)
if not ok then
  io.stderr:write(err .. '\n')
  vim.cmd.cquit(1)
else
  vim.cmd('qa!')
end

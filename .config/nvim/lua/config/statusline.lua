local M = {}

function M.render()
  local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
  local names = { n = 'NORMAL', i = 'INSERT', v = 'VISUAL', V = 'V-LINE', ['\22'] = 'V-BLOCK', c = 'COMMAND', R = 'REPLACE', t = 'TERMINAL' }
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local diagnostics = (errors > 0 and (' E:' .. errors) or '') .. (warnings > 0 and (' W:' .. warnings) or '')
  return ' ' .. (names[mode] or mode) .. ' | %<%f %m%r%=' .. diagnostics .. ' | %y | %l:%c %p%% '
end

vim.opt.statusline = "%!v:lua.require'config.statusline'.render()"
return M

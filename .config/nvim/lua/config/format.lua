local M = {}

local commands = {
  c = { 'clang-format', '--assume-filename' },
  cpp = { 'clang-format', '--assume-filename' },
  python = { 'ruff', 'format', '--stdin-filename' },
  lua = { 'stylua', '--search-parent-directories', '--stdin-filepath' },
  sh = { 'shfmt', '-filename' },
  bash = { 'shfmt', '-filename' },
  markdown = { 'prettier', '--stdin-filepath' },
}

function M.format()
  local buf = vim.api.nvim_get_current_buf()
  local cmd = vim.deepcopy(commands[vim.bo[buf].filetype])
  if not cmd or vim.bo[buf].buftype ~= '' or not vim.bo[buf].modifiable then
    vim.notify('No formatter for this buffer', vim.log.levels.INFO)
    return
  end
  if vim.fn.executable(cmd[1]) ~= 1 then
    vim.notify('Install ' .. cmd[1] .. ' with :Mason', vim.log.levels.WARN)
    return
  end
  local name = vim.api.nvim_buf_get_name(buf)
  if name == '' then
    vim.notify('Name the file before formatting', vim.log.levels.WARN)
    return
  end
  table.insert(cmd, name)
  if cmd[1] == 'ruff' or cmd[1] == 'stylua' then table.insert(cmd, '-') end
  local tick = vim.api.nvim_buf_get_changedtick(buf)
  local input = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), '\n')
  if vim.bo[buf].endofline then input = input .. '\n' end
  vim.system(cmd, { stdin = input, text = true, cwd = vim.fs.dirname(name), timeout = 10000 }, function(result)
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(buf) then return end
      if result.code ~= 0 then
        vim.notify('Formatting failed: ' .. (result.stderr or tostring(result.code)), vim.log.levels.ERROR)
        return
      end
      if vim.api.nvim_buf_get_changedtick(buf) ~= tick or not vim.bo[buf].modifiable then
        vim.notify('Buffer changed; format result discarded', vim.log.levels.WARN)
        return
      end
      local output = result.stdout or ''
      if output == input then return end
      local eol = output:sub(-1) == '\n'
      if eol then output = output:sub(1, -2) end
      local views = {}
      for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        views[win] = vim.api.nvim_win_call(win, vim.fn.winsaveview)
      end
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, '\n', { plain = true }))
      vim.bo[buf].endofline = eol
      for win, view in pairs(views) do
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_call(win, function() vim.fn.winrestview(view) end)
        end
      end
    end)
  end)
end

return M

local directions = { h = 'L', j = 'D', k = 'U', l = 'R' }
for key, direction in pairs(directions) do
  vim.keymap.set('n', '<C-' .. key .. '>', function()
    local win = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(key)
    if vim.api.nvim_get_current_win() == win and vim.env.TMUX and vim.env.TMUX_PANE then
      -- Stay inside a zoomed pane; do not silently switch away from it.
      local pane = vim.env.TMUX_PANE
      vim.system({ 'tmux', 'display-message', '-p', '-t', pane, '#{window_zoomed_flag}' }, { text = true }, vim.schedule_wrap(function(result)
        if result.code == 0 and vim.trim(result.stdout) == '0' then
          vim.system({ 'tmux', 'select-pane', '-t', pane, '-' .. direction })
        end
      end))
    end
  end, { desc = 'Navigate Neovim/tmux ' .. key })
end

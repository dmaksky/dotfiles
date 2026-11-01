local directions = { h = 'L', j = 'D', k = 'U', l = 'R' }

for key, dir in pairs(directions) do
  vim.keymap.set('n', '<C-' .. key .. '>', function()
    local current = vim.api.nvim_get_current_win()

    -- Try moving inside Neovim.
    vim.cmd.wincmd(key)

    if vim.api.nvim_get_current_win() ~= current then
      return
    end

    -- Otherwise, move to the adjacent tmux pane.
    local pane = vim.env.TMUX_PANE
    if pane then
      vim.system({ 'tmux', 'select-pane', '-' .. dir, '-t', pane })
    end
  end, { desc = 'Navigate Neovim/tmux ' .. key })
end


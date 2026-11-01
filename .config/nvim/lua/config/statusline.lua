local M = {}


local modes = {
    n = 'NORMAL',
    i = 'INSERT',
    v = 'VISUAL',
    V = 'V-LINE',
    ['\22'] = 'V-BLOCK',
    c = 'COMMAND',
    R = 'REPLACE',
    t = 'TERMINAL',
}

function M.render()
    local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
    local counts = vim.diagnostic.count(0)

    local errors = counts[vim.diagnostic.severity.ERROR] or 0
    local warnings = counts[vim.diagnostic.severity.WARN] or 0

    local diagnostics =
        (errors > 0 and (' E:' .. errors) or '') ..
        (warnings > 0 and (' W:' .. warnings) or '')

    return ' ' .. (modes[mode] or mode) ..
        ' | %<%f %m%r%=' ..
        diagnostics ..
        ' | %y | %l:%c %p%% '
end

vim.opt.statusline = "%!v:lua.require'config.statusline'.render()"

return M

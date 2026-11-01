local M = {}

local modes = {
    n = { 'NORMAL', 'StatusModeNormal' },
    i = { 'INSERT', 'StatusModeInsert' },
    v = { 'VISUAL', 'StatusModeVisual' },
    V = { 'V-LINE', 'StatusModeVisual' },
    ['\22'] = { 'V-BLOCK', 'StatusModeVisual' },
    c = { 'COMMAND', 'StatusModeCommand' },
    R = { 'REPLACE', 'StatusModeReplace' },
    s = { 'SELECT', 'StatusModeVisual' },
    S = { 'S-LINE', 'StatusModeVisual' },
    t = { 'TERMINAL', 'StatusModeTerminal' },
}

-- Colors from the active colorscheme
local accents = {
    StatusModeNormal  = 0x1e66f5,
    StatusModeInsert  = 0xdf8e1d,
    StatusModeVisual  = 0x8839ef,
    StatusModeCommand = 0xfe640b,
    StatusModeReplace = 0xd20f39,
    StatusModeTerminal = 0x179299,
}

local function get_color(group, fallback)
    local hl = vim.api.nvim_get_hl(0, {
        name = group,
        link = false,
    })
    return hl.fg or fallback
end

-- Choose readable text for colored backgrounds
local function contrast_fg(color)
    local function channel(x)
        x = x / 255
        return x <= 0.04045
            and x / 12.92
            or ((x + 0.055) / 1.055) ^ 2.4
    end

    local r = channel(math.floor(color / 65536) % 256)
    local g = channel(math.floor(color / 256) % 256)
    local b = channel(color % 256)

    local luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
    return luminance > 0.179 and '#1e1e2e' or '#ffffff'
end

local function setup_highlights()
    local hl = vim.api.nvim_set_hl

    for name, bg in pairs(accents) do
        hl(0, name, {
            fg = contrast_fg(bg),
            bg = bg,
            bold = true,
        })
    end

    local status = vim.api.nvim_get_hl(0, {
        name = 'StatusLine',
        link = false,
    })

    for name, source in pairs({
        StatusError = 'DiagnosticError',
        StatusWarn = 'DiagnosticWarn',
    }) do
        hl(0, name, {
            fg = get_color(source),
            bg = status.bg,
            bold = true,
        })
    end
end

-- Refresh highlights when colorscheme changes
vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup(
        'CustomStatusline',
        { clear = true }
    ),
    callback = setup_highlights,
})

setup_highlights()

function M.render()
    local raw_mode = vim.api.nvim_get_mode().mode
    local current = modes[raw_mode]
        or modes[raw_mode:sub(1, 1)]
        or { raw_mode, 'StatusModeNormal' }

    local counts = vim.diagnostic.count(0)
    local errors = counts[vim.diagnostic.severity.ERROR] or 0
    local warnings = counts[vim.diagnostic.severity.WARN] or 0

    local diagnostics = ''

    if errors > 0 then
        diagnostics = diagnostics
            .. '%#StatusError# E:' .. errors
    end

    if warnings > 0 then
        diagnostics = diagnostics
            .. '%#StatusWarn# W:' .. warnings
    end

    return table.concat({
        -- Left: mode
        '%#' .. current[2] .. '# ' .. current[1] .. ' ',

        -- Left: filename
        '%#StatusLine# %<%f %m%r',

        -- Right: diagnostics and position
        '%=',
        diagnostics,
        '%#StatusLine# %y %l:%c %p%% ',
    })
end

vim.opt.laststatus = 3
vim.opt.showmode = false
vim.opt.statusline = "%!v:lua.require'config.statusline'.render()"

return M

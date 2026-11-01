-- Servers
vim.lsp.config('clangd', {
  cmd = { 'clangd', '--function-arg-placeholders=false' },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
    },
  },
})

-- Mason
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'clangd',
    'pyright',
    'lua_ls',
    'bashls',
    'marksman',
  },
})

-- Diagnostics
vim.diagnostic.config({
  virtual_lines = { current_line = true },
  severity_sort = true,
  float = { border = 'rounded' },
})

-- Native completion
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('DotfilesLsp', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client or not client:supports_method('textDocument/completion') then
      return
    end

    vim.lsp.completion.enable(true, client.id, ev.buf, {
      autotrigger = true,
    })

    vim.keymap.set('i', '<C-Space>', vim.lsp.completion.get, {
      buffer = ev.buf,
      desc = 'LSP completion',
    })
  end,
})


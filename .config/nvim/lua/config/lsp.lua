require("mason").setup()
require("mason-lspconfig").setup()

local capabilities = vim.lsp.protocol.make_client_capabilities()

vim.lsp.config("*", {
  capabilities = capabilities,
  root_markers = { ".git", "." },
})

vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--function-arg-placeholders=false",
  },
})

vim.diagnostic.config({
  virtual_lines = { current_line = true },
  severity_sort = true,
})

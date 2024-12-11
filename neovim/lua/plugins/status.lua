return {
  'linrongbin16/lsp-progress.nvim',
  config = function()
    require('lsp-progress').setup({
      client_name = {
        default = 'LSP',
        pyright = 'Pyright',
        ruff_lsp = 'Ruff'
      }
    })
  end
}

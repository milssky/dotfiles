return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'saghen/blink.cmp',
    },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'pyright',
          'rust_analyzer',
          'clangd',
          'lua_ls',
          'vimls',
          'dockerls',
          'docker_compose_language_service',
        }
      })

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local function enable(server, opts)
        opts = opts or {}
        opts.capabilities = vim.tbl_deep_extend(
          "force",
          {},
          capabilities,
          opts.capabilities or {}
        )
        vim.lsp.config(server, opts)
        vim.lsp.enable(server)
      end

      enable('pyright', {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
            }
          }
        }
      })

      for _, server in ipairs({
        'rust_analyzer',
        'clangd',
        'lua_ls',
        'vimls',
        'dockerls',
        'docker_compose_language_service',
      }) do
        enable(server)
      end
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
    end
  }
}

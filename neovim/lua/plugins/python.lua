return {
  -- Выбор и активация виртуального окружения
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      local venv_selector = require('venv-selector')
      venv_selector.setup({
        -- defaults are enough, but keep cached venv reactivation enabled
        options = {
          enable_cached_venvs = true,
          cached_venv_automatic_activation = true,
        },
      })

      vim.keymap.set('n', '<leader>vs', '<cmd>VenvSelect<CR>', { desc = 'Select virtualenv' })
      vim.keymap.set('n', '<leader>vc', function()
        require('venv-selector.cached_venv').retrieve()
      end, { desc = 'Activate cached virtualenv' })
    end,
    event = 'VeryLazy',
  }
}

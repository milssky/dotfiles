return {
  -- Выбор и активация виртуального окружения
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = { 
      'neovim/nvim-lspconfig', 
      'nvim-telescope/telescope.nvim' 
    },
    config = function()
      require('venv-selector').setup({
        name = {"venv", ".venv"},
        stay_on_this_version=true,
        poetry_paths = function()
          return vim.fn.systemlist("poetry env list --full-path")
        end,
        auto_refresh = true,
        vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*.py",
      callback = function()
        local venv_path = vim.fn.getcwd() .. "/.venv"
        if vim.fn.isdirectory(venv_path) == 1 then
          require('venv-selector').retrieve_from_cache()
        end
      end
    })
      })
      
      -- Горячие клавиши для работы с venv
      vim.keymap.set('n', '<leader>vs', ':VenvSelect<CR>')
      vim.keymap.set('n', '<leader>vc', ':VenvSelectCached<CR>')
    end,
    event = 'VeryLazy'
  }
}

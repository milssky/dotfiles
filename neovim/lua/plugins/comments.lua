return {
    -- Плагин для комментирования
    {
      'numToStr/Comment.nvim',
      dependencies = {
        'JoosepAlviste/nvim-ts-context-commentstring'
      },
      config = function()
        -- Настройка Comment.nvim
        require('Comment').setup {
          -- Основные маппинги
          toggler = {
            line = '<leader>/',   -- Комментирование/раскомментирование текущей строки
            block = '<leader>?'   -- Комментирование блока
          },
          opleader = {
            line = '<leader>/',   -- Комментирование выделенного в Visual mode
            block = '<leader>?'   -- Блочное комментирование
          },
          
          -- Поддержка разных языков с помощью treesitter
          pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        }
  
        -- Дополнительные кастомные маппинги
        vim.keymap.set('n', '<leader>/', function()
          require('Comment.api').toggle.linewise.current()
        end, { noremap = true, silent = true })
  
        vim.keymap.set('v', '<leader>/', function()
          local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
          vim.api.nvim_feedkeys(esc, 'nx', false)
          require('Comment.api').toggle.linewise(vim.fn.visualmode())
        end, { noremap = true, silent = true })
      end
    },
    

  }